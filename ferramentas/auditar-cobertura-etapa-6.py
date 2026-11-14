"""Executa o inventário Lua com as entradas de referência e os lotes do acervo."""

import argparse
import csv
from hashlib import sha256
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory


def entradas_dos_lotes(acervo):
    for manifesto in sorted(acervo.glob("*/casos.tsv")):
        with manifesto.open(encoding="utf-8", newline="") as arquivo:
            for linha in csv.DictReader(arquivo, delimiter="\t"):
                nome = linha["entrada"]
                if Path(nome).name != nome or not nome.endswith(".txt"):
                    raise ValueError(f"Nome de entrada inválido em {manifesto}: {nome}")
                yield manifesto.parent / nome


def entradas_unicas(arquivos, vistos):
    for caminho in arquivos:
        dados = caminho.read_bytes().replace(b"\r\n", b"\n")
        digest = sha256(dados).digest()
        if digest not in vistos:
            vistos.add(digest)
            yield caminho


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--raiz", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--texlua", default="texlua")
    args = parser.parse_args()
    raiz = args.raiz.resolve()
    acervo = raiz / "acervo" / "validacao"
    exemplo = raiz / "motor" / "mapa-editorial-v1.txt"
    referencias = [
        *(acervo / "entradas" / f"mapa-{nome}.txt" for nome in ("b", "c", "d")),
        *(acervo / "entradas" / f"teste-{numero:02}.txt" for numero in range(1, 8)),
        *sorted((raiz / "ferramentas" / "mapas-validacao").glob("sol-*.txt")),
    ]
    lotes = list(entradas_dos_lotes(acervo))
    if not lotes:
        parser.error(f"Nenhum lote com casos.tsv encontrado em {acervo}")
    vistos = set()
    base = list(entradas_unicas([exemplo, *referencias], vistos))
    extras = list(entradas_unicas(lotes, vistos))
    print(
        f"{len(base)} entradas de referência + {len(extras)} entradas distintas dos lotes "
        f"({len(lotes)} casos registrados) = {len(base) + len(extras)} entradas.",
        file=sys.stderr,
    )
    # A lista em arquivo evita o limite de argumentos do Windows.
    # O inventário Lua já abre o exemplo como primeira entrada.
    with TemporaryDirectory() as pasta:
        lista = Path(pasta) / "entradas.txt"
        lista.write_text(
            "".join(f"{caminho.relative_to(raiz).as_posix()}\n" for caminho in [*base[1:], *extras]),
            encoding="utf-8",
            newline="\n",
        )
        chamada = Path(pasta) / "executar.lua"
        chamada.write_text(
            'local arquivo = assert(io.open(arg[1], "r"))\n'
            'arg = {[0] = "motor/inventario-editorial.lua"}\n'
            "for caminho in arquivo:lines() do arg[#arg + 1] = caminho end\n"
            "arquivo:close()\n"
            "dofile(arg[0])\n",
            encoding="ascii",
        )
        return subprocess.run([args.texlua, chamada, lista], cwd=raiz, check=False).returncode


if __name__ == "__main__":
    raise SystemExit(main())
