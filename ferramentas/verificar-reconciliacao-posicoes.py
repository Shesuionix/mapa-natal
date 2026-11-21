"""Recalcula as evidencias suplementares com a API Swiss usada pelo gerador do projeto."""
import argparse
import csv
import hashlib
import importlib.util
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('efemerides', type=Path)
    parser.add_argument('--deps', type=Path, help='Diretorio opcional do modulo swisseph')
    parser.add_argument('--arquivo', type=Path, help='TSV de proveniencia alternativo')
    args = parser.parse_args()
    if args.deps:
        sys.path.insert(0, str(args.deps.resolve()))
    import swisseph as swe
    repo = Path(__file__).resolve().parents[1]
    spec = importlib.util.spec_from_file_location('gerador', repo/'ferramentas/gerar-evidencias-posicoes.py')
    generator = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(generator)
    assert swe.version == '2.10.03', 'Versao Swiss divergente'
    for filename, digest in generator.EPHEMERIS_FILES.items():
        assert hashlib.sha256((args.efemerides/filename).read_bytes()).hexdigest() == digest, filename
    swe.set_ephe_path(str(args.efemerides.resolve()))
    path = args.arquivo or repo/'docs/geracao-editorial/reconciliacao-296-posicoes.tsv'
    with path.open(encoding='utf-8', newline='') as stream:
        rows = list(csv.DictReader(stream, delimiter='\t'))
    for row in rows:
        body, sign, house, motion = row['chave'].split('|')
        jd, lat, lon, system = row['evidencia'].split(';')
        jd, lat, lon = map(float, (jd, lat, lon))
        cusps, angles = generator.chart(jd, lat, lon, system)
        if body == 'Vertex':
            longitude, speed = angles[3], 0
        else:
            bodies = [b for b, v in generator.BODIES[body] if v == row['variante']]
            assert len(bodies) == 1, row['chave']
            longitude, speed = generator.longitude_and_speed(jd, bodies[0])
        arc = round(longitude*60) % 21600
        cusp_minutes = [round(c*60) % 21600 for c in cusps]
        actual_house = next(i+1 for i, c in enumerate(cusp_minutes)
                            if (arc-c) % 21600 < (cusp_minutes[(i+1) % 12]-c) % 21600)
        if motion == 'stationary':
            before = generator.longitude_and_speed(jd-.02, bodies[0])[1]
            after = generator.longitude_and_speed(jd+.02, bodies[0])[1]
            assert abs(speed) < 1e-6 and before*after < 0, row['chave']
            actual_motion = 'stationary'
        else:
            actual_motion = str(speed < 0).lower()
        actual = f'{body}|{generator.SIGNS[arc//1800]}|{actual_house}|{actual_motion}'
        assert actual == row['chave'], (row['chave'], actual)
        if 'chave_recalculada' in row:
            assert actual == row['chave_recalculada']
    print(f'{len(rows)} evidencias recalculadas e conferidas')


if __name__ == '__main__':
    main()
