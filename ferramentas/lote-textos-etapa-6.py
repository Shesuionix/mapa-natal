"""Prepara um lote de chaves e verifica a resposta JSONL do modelo de redação."""

import argparse
import csv
import json
from pathlib import Path
import re
import unicodedata


LIMITS = {
    "posicoes": (130, 190),
    "estacionarias": (130, 190),
    "casas": (145, 220),
    "aspectos": (85, 130),
}
FIELDS = {"secao", "chave", "subtitulo", "paragrafos"}
WORD = re.compile(r"[^\W_]+(?:[-’'][^\W_]+)*", re.UNICODE)


def batch(queue, section, start, size):
    with queue.open(encoding="utf-8-sig", newline="") as source:
        rows = [row for row in csv.DictReader(source, delimiter="\t") if row["secao"] == section]
    selected = rows[start - 1:start - 1 + size]
    if not selected:
        raise ValueError(f"Nenhuma chave em {section} a partir de {start}")
    return [{"secao": row["secao"], "chave": row["chave"]} for row in selected]


def read_jsonl(path):
    with path.open(encoding="utf-8-sig") as source:
        for number, line in enumerate(source, 1):
            try:
                row = json.loads(line)
            except json.JSONDecodeError as error:
                raise ValueError(f"{path}, linha {number}: JSON inválido") from error
            if not isinstance(row, dict):
                raise ValueError(f"{path}, linha {number}: esperado um objeto")
            yield row


def plain(value):
    if not isinstance(value, str) or value != value.strip() or not value:
        return False
    if any(character in value for character in ("\\", "{", "}", "`", "<", ">", "[", "]", ";", ":", "\n", "\r", "\t")):
        return False
    return not any(unicodedata.category(character) in ("Cc", "Cf") for character in value)


def unique_form(text):
    return " ".join(WORD.findall(text.casefold()))


def validate(request, answer):
    expected = [(row["secao"], row["chave"]) for row in request]
    if not expected or len(set(expected)) != len(expected):
        raise ValueError("Lote vazio ou com chaves repetidas")
    if len(answer) != len(expected):
        raise ValueError(f"Esperadas {len(expected)} respostas, recebidas {len(answer)}")
    titles, bodies = set(), set()
    for index, (row, identity) in enumerate(zip(answer, expected, strict=True), 1):
        where = f"Linha {index} ({identity[1]})"
        if set(row) != FIELDS or (row.get("secao"), row.get("chave")) != identity:
            raise ValueError(f"{where}: campos, seção, chave ou ordem divergentes")
        title, paragraphs = row["subtitulo"], row["paragrafos"]
        if not plain(title) or not 6 <= len(WORD.findall(title)) <= 20 or title.endswith((".", "!", "?", "…")):
            raise ValueError(f"{where}: subtítulo inválido")
        if not isinstance(paragraphs, list) or len(paragraphs) != 2 or not all(map(plain, paragraphs)):
            raise ValueError(f"{where}: esperados dois parágrafos de prosa simples")
        minimum, maximum = LIMITS[identity[0]]
        length = sum(len(WORD.findall(paragraph)) for paragraph in paragraphs)
        if not minimum <= length <= maximum:
            raise ValueError(f"{where}: {length} palavras no corpo, esperado {minimum}–{maximum}")
        heading = unique_form(title)
        body = unique_form(" ".join(paragraphs))
        if body.startswith(heading + " ") or heading in titles or body in bodies:
            raise ValueError(f"{where}: repetição do subtítulo ou do texto")
        titles.add(heading)
        bodies.add(body)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    prepare = commands.add_parser("preparar")
    prepare.add_argument("fila", type=Path)
    prepare.add_argument("secao", choices=LIMITS)
    prepare.add_argument("inicio", type=int, help="Índice da primeira chave na seção, começando em 1")
    prepare.add_argument("quantidade", type=int)
    prepare.add_argument("lote", type=Path)
    check = commands.add_parser("verificar")
    check.add_argument("lote", type=Path)
    check.add_argument("resposta", type=Path)
    args = parser.parse_args()
    try:
        if args.command == "preparar":
            if args.inicio < 1 or args.quantidade < 1:
                raise ValueError("Índice e quantidade devem ser positivos")
            rows = batch(args.fila, args.secao, args.inicio, args.quantidade)
            with args.lote.open("x", encoding="utf-8", newline="\n") as destination:
                for row in rows:
                    destination.write(json.dumps(row, ensure_ascii=False) + "\n")
            print(f"{len(rows)} chaves preparadas")
        else:
            rows = list(read_jsonl(args.lote))
            validate(rows, list(read_jsonl(args.resposta)))
            print(f"{len(rows)} textos passaram pela validação de formato")
    except (OSError, ValueError, KeyError) as error:
        parser.error(str(error))


if __name__ == "__main__":
    main()
