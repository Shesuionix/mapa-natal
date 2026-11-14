from pathlib import Path
import csv
import importlib.util
import re
import sys


root = Path(sys.argv[2]).resolve()
target = Path(sys.argv[3]).resolve()
target.mkdir(parents=True, exist_ok=True)
generator_path = root / "ferramentas/gerar-evidencias-posicoes.py"
spec = importlib.util.spec_from_file_location("evidence", generator_path)
generator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generator)
assert generator.swe.version == "2.10.03", generator.swe.version
generator.swe.set_ephe_path(sys.argv[1])

catalog = (root / "motor/catalogo-editorial.lua").read_text(encoding="utf-8")
found = re.findall(r'^\s*\["(Moon\|[^|]+\|[56]\|false)"\]\s*=\s*(\d+),', catalog, re.M)
ids = {key: int(identifier) for key, identifier in found}
assert len(found) == len(ids) == 24
assert set(ids.values()) == {17, 95, *range(384, 406)}

with (root / "docs/evidencias-posicoes.tsv").open(encoding="ascii", newline="") as source:
    rows = {row["chave"]: row for row in csv.DictReader(source, delimiter="\t")}

evidence = []
for house in (5, 6):
    for sign in generator.SIGNS:
        key = f"Moon|{sign}|{house}|false"
        row = rows[key]
        jd, latitude, longitude = (float(row[field]) for field in ("dia_juliano_ut", "latitude", "longitude"))
        data = generator.validation_input(jd, latitude, longitude, row["sistema"], ("Moon", sign, house, "false"))
        filename = f"lua-{sign.lower()}-casa-{house}.txt"
        (target / filename).write_text(data, encoding="utf-8", newline="\n")
        evidence.append((key, ids[key], filename, row["dia_juliano_ut"], row["latitude"], row["longitude"], row["sistema"]))

with (target / "casos.tsv").open("w", encoding="utf-8", newline="") as output:
    writer = csv.writer(output, delimiter="\t", lineterminator="\n")
    writer.writerow(("chave", "texto", "entrada", "dia_juliano_ut", "latitude", "longitude", "sistema"))
    writer.writerows(evidence)
print(f"{len(evidence)} mapas lunares reproduzidos.")
