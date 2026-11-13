"""Gera evidências para o inventário editorial. Ferramenta de desenvolvimento."""

import argparse
import csv
from datetime import date, timedelta
from hashlib import sha256
from math import asin, atan2, cos, degrees, radians, sin
from pathlib import Path

import swisseph as swe


SIGNS = "Aries Taurus Gemini Cancer Leo Virgo Libra Scorpio Sagittarius Capricorn Aquarius Pisces".split()
BODIES = {
    "Sun": [(swe.SUN, "planeta")],
    "Moon": [(swe.MOON, "planeta")],
    "Mercury": [(swe.MERCURY, "planeta")],
    "Venus": [(swe.VENUS, "planeta")],
    "Mars": [(swe.MARS, "planeta")],
    "Jupiter": [(swe.JUPITER, "planeta")],
    "Saturn": [(swe.SATURN, "planeta")],
    "Uranus": [(swe.URANUS, "planeta")],
    "Neptune": [(swe.NEPTUNE, "planeta")],
    "Pluto": [(swe.PLUTO, "planeta")],
    "North Node": [(swe.MEAN_NODE, "medio"), (swe.TRUE_NODE, "verdadeiro")],
    "Lilith": [(swe.MEAN_APOG, "medio"), (swe.OSCU_APOG, "osculante")],
    "Chiron": [(swe.CHIRON, "asteroide")],
}
EPHEMERIS_FILES = {
    "seas_18.se1": "a2cd8fc33807c78ca9a700c91c2e042258b12fc4796519e00781440b5ad8b2e2",
    "semo_18.se1": "1ca07bd67c24374d77226180c20a4f9996cba013697894810518e7eb582ca4f7",
    "sepl_18.se1": "ca1393ceab3a44fbc895887cf789c68819ae6a1cbc9b22225872dbe4ccd99a66",
}
FLAGS = swe.FLG_SWIEPH | swe.FLG_SPEED
EPHEMERIS_FLAGS = swe.FLG_JPLEPH | swe.FLG_SWIEPH | swe.FLG_MOSEPH
MARGIN = 0.02  # Graus. Evita que o arredondamento mude a chave registrada.
FIRST_DAY = date(1800, 1, 1)
LAST_DAY = date(2099, 12, 31)


def longitude_and_speed(jd, body):
    values, flags, warning = swe.calc_ut(jd, body, FLAGS)
    if warning or (flags & EPHEMERIS_FLAGS) != swe.FLG_SWIEPH:
        raise RuntimeError(f"Efeméride inesperada para {body} em {jd}: {warning or flags}")
    return values[0], values[3]


def sign_of(longitude):
    degree = longitude % 30
    if MARGIN < degree < 30 - MARGIN:
        return SIGNS[int(longitude // 30)]
    return None


def house_of(longitude, cusps):
    for index, cusp in enumerate(cusps):
        width = (cusps[(index + 1) % 12] - cusp) % 360
        if MARGIN < (longitude - cusp) % 360 < width - MARGIN:
            return index + 1
    return None


def chart(jd, lat, lon, system):
    cusps, angles = swe.houses_ex(jd, lat, lon, system.encode("ascii"))
    cusps = cusps[1:]
    widths = [(cusps[(index + 1) % 12] - cusp) % 360 for index, cusp in enumerate(cusps)]
    if min(widths) <= 2 * MARGIN or abs(sum(widths) - 360) > 1e-8:
        return None
    if abs((cusps[0] - angles[0] + 180) % 360 - 180) > 1e-8:
        return None
    if abs((cusps[9] - angles[1] + 180) % 360 - 180) > 1e-8:
        return None
    return cusps, angles


def register(witnesses, name, longitude, cusps, retrograde, context):
    sign = sign_of(longitude)
    house = house_of(longitude, cusps)
    if sign and house:
        key = (name, sign, house, "true" if retrograde else "false")
        witnesses.setdefault(key, context)


def find_planets_and_fortune(witnesses):
    pending = {(name, sign, retrograde) for name in BODIES for sign in SIGNS
               for retrograde in (False, True) if not (retrograde and name in {"Sun", "Moon"})}
    fortune_pending = {(sign, house) for sign in SIGNS for house in range(1, 13)}
    for offset in range((LAST_DAY - FIRST_DAY).days + 1):
        day = FIRST_DAY + timedelta(days=offset)
        jd = swe.julday(day.year, day.month, day.day, 12)
        positions = {}
        found = []
        for name, variants in BODIES.items():
            for body, variant in variants:
                longitude, speed = longitude_and_speed(jd, body)
                positions[name] = longitude
                sign = sign_of(longitude)
                retrograde = speed < 0
                if abs(speed) > 0.0002 and (name, sign, retrograde) in pending:
                    found.append((name, longitude, retrograde, variant))
        if not found and not fortune_pending:
            continue
        for lon in range(-180, 180, 15):
            geometry = chart(jd, 0, lon, "P")
            if geometry is None:
                continue
            cusps, angles = geometry
            for name, longitude, retrograde, variant in found:
                register(witnesses, name, longitude, cusps, retrograde, (jd, 0, lon, "P", variant))
            if fortune_pending:
                asc = angles[0]
                sun_from_asc = (positions["Sun"] - asc) % 360
                if min(sun_from_asc, abs(sun_from_asc - 180), 360 - sun_from_asc) > MARGIN:
                    day_chart = sun_from_asc > 180
                    phase = positions["Moon"] - positions["Sun"]
                    fortune = (asc + (phase if day_chart else -phase)) % 360
                    register(witnesses, "Fortune", fortune, cusps, False, (jd, 0, lon, "P", "dia-noite"))
                    fortune_pending.discard((sign_of(fortune), house_of(fortune, cusps)))
        for name, longitude, retrograde, _ in found:
            sign = sign_of(longitude)
            if all((name, sign, house, str(retrograde).lower()) in witnesses for house in range(1, 13)):
                pending.discard((name, sign, retrograde))
        if not pending and not fortune_pending:
            break


def find_vertex(witnesses):
    jd = swe.julday(2000, 1, 1, 12)
    for system in ("P", "C"):
        for lat in range(-66, 67):
            for lon in range(-180, 180):
                geometry = chart(jd, lat, lon, system)
                if geometry:
                    cusps, angles = geometry
                    register(witnesses, "Vertex", angles[3], cusps, False, (jd, lat, lon, system, "primeira-vertical"))

    # Perto do zênite, Vertex e MC podem cair no mesmo minuto exportado.
    # No intervalo usado pelo leitor, a cúspide é o primeiro ponto da casa 10.
    obliquity = radians(swe.calc_ut(jd, swe.ECL_NUT)[0][0])
    sidereal = swe.sidtime(jd) * 15
    for index, sign in enumerate(SIGNS):
        target = radians(index * 30 + 15.254)
        right_ascension = degrees(atan2(cos(obliquity) * sin(target), cos(target)))
        declination = degrees(asin(sin(obliquity) * sin(target)))
        longitude = (right_ascension - sidereal + 180) % 360 - 180
        for offset in (-0.00005, 0.00005):
            latitude = declination + offset
            cusps, angles = chart(jd, latitude, longitude, "P")
            vertex, mc = angles[3], cusps[9]
            separation = (mc - vertex) % 360
            if (0 < separation < 1 / 60 and sign_of(vertex) == sign
                    and int(vertex * 60) == int(mc * 60) and round(vertex * 60) == round(mc * 60)):
                witnesses[("Vertex", sign, 10, "false")] = (jd, latitude, longitude, "P", "cuspide-minuto")
                break
        else:
            raise RuntimeError(f"Vertex junto ao MC não encontrado para {sign}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ephemeris", type=Path, help="Diretório com os três arquivos .se1")
    parser.add_argument("output", type=Path, help="Arquivo TSV a gravar")
    args = parser.parse_args()
    if swe.version != "2.10.03":
        raise RuntimeError(f"Esperado Swiss Ephemeris 2.10.03, recebido {swe.version}")
    for filename, expected_hash in EPHEMERIS_FILES.items():
        digest = sha256((args.ephemeris / filename).read_bytes()).hexdigest()
        if digest != expected_hash:
            raise RuntimeError(f"SHA-256 inesperado: {filename}")
    swe.set_ephe_path(str(args.ephemeris.resolve()))
    witnesses = {}
    find_planets_and_fortune(witnesses)
    find_vertex(witnesses)
    with args.output.open("w", encoding="ascii", newline="") as output:
        writer = csv.writer(output, delimiter="\t", lineterminator="\n")
        writer.writerow(("chave", "dia_juliano_ut", "latitude", "longitude", "sistema", "variante"))
        for key, context in sorted(witnesses.items()):
            writer.writerow(("|".join(map(str, key)), *context))


if __name__ == "__main__":
    main()
