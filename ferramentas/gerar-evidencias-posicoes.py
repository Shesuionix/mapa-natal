"""Gera evidências para o inventário editorial. Ferramenta de desenvolvimento."""

import argparse
import csv
from datetime import date, timedelta
from hashlib import sha256
from itertools import combinations
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
VALIDATION_SUNS = (
    ("Sun", "Aries", 10, "false"),
    ("Sun", "Virgo", 10, "false"),
    ("Sun", "Cancer", 12, "false"),
    ("Sun", "Aquarius", 12, "false"),
)
ASPECT_ANGLES = {"Conjunction": 0, "Sextile": 60, "Square": 90, "Trine": 120, "Opposition": 180}
HOUSE_SUFFIXES = {1: "st", 2: "nd", 3: "rd"}


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


def chart_for_validation(jd, lat, lon, system):
    geometry = chart(jd, lat, lon, system)
    if geometry is None:
        raise ValueError(f"Geometria de casas incompatível para {jd}, {lat}, {lon}, {system}")
    cusps, angles = geometry
    planets = {name: longitude_and_speed(jd, variants[0][0]) for name, variants in BODIES.items()}
    sun, moon = planets["Sun"][0], planets["Moon"][0]
    phase = moon - sun
    fortune = (angles[0] + (phase if (sun - angles[0]) % 360 > 180 else -phase)) % 360
    planets.update({"Fortune": (fortune, 0), "Vertex": (angles[3], 0)})
    locations = {name: longitude for name, (longitude, _) in planets.items()}
    angle_houses = {"ASC": 1, "DSC": 7, "MC": 10, "IC": 4}
    locations.update({name: cusps[house - 1] for name, house in angle_houses.items()})
    return cusps, planets, locations


def validation_input(jd, lat, lon, system, expected_sun):
    cusps, planets, locations = chart_for_validation(jd, lat, lon, system)
    _, _, before = chart_for_validation(jd - 1 / 1440, lat, lon, system)
    _, _, after = chart_for_validation(jd + 1 / 1440, lat, lon, system)
    minutes = {name: round(longitude * 60) % 21600 for name, longitude in locations.items()}
    cusp_minutes = [round(cusp * 60) % 21600 for cusp in cusps]

    def location(value):
        sign, within = divmod(value, 1800)
        return f"{SIGNS[sign]} {within // 60}°{within % 60:02}'"

    positions = []
    for name, (_, speed) in planets.items():
        value = minutes[name]
        house = next(index + 1 for index, cusp in enumerate(cusp_minutes)
                     if (value - cusp) % 21600 < (cusp_minutes[(index + 1) % 12] - cusp) % 21600)
        if name == "Sun" and (name, SIGNS[value // 1800], house, str(speed < 0).lower()) != expected_sun:
            raise ValueError(f"Posição solar divergente: {expected_sun}")
        marker = ", Retrograde" if speed < 0 else ""
        suffix = HOUSE_SUFFIXES.get(house, "th")
        positions.append(f"{name} in {location(value)}{marker}, in {house}{suffix} House")
    positions += [f"{name} in {location(minutes[name])}" for name in ("ASC", "MC")]
    houses = [f"{i}{HOUSE_SUFFIXES.get(i, 'th')} House in {location(cusp)}"
              for i, cusp in enumerate(cusp_minutes, 1)]

    def separation(values, first, second, cycle):
        return abs((values[first] - values[second] + cycle / 2) % cycle - cycle / 2)

    aspects = []
    for first, second in combinations(locations, 2):
        if first not in planets and second not in planets:
            continue
        distance = separation(locations, first, second, 360)
        kind, angle = min(ASPECT_ANGLES.items(), key=lambda item: abs(distance - item[1]))
        maximum = 3 if first not in planets or second not in planets else 6
        if abs(distance - angle) > maximum:
            continue
        orb = round(abs(separation(minutes, first, second, 21600) - angle * 60))
        earlier_orb = abs(separation(before, first, second, 360) - angle)
        later_orb = abs(separation(after, first, second, 360) - angle)
        approaching = later_orb < earlier_orb
        phase = "Applying" if approaching else "Separating"
        aspects.append(f"{first} {kind} {second} (Orb: {orb // 60}°{orb % 60:02}', {phase})")

    speed = planets["Sun"][1]
    seconds = round(speed * 3600)
    degrees_per_day, remainder = divmod(seconds, 3600)
    ratio = speed / (360 / 365.2422)
    solar_speed = f"Sun: {degrees_per_day}°{remainder // 60:02}'{remainder % 60:02}'' (Direct, cca {ratio:.4f}x avg speed)"
    return "\n\n".join(("\n".join(positions), "\n".join(houses), "\n".join(aspects), solar_speed)) + "\n"


def write_validation_inputs(directory, evidence):
    directory.mkdir(parents=True, exist_ok=True)
    with evidence.open(encoding="ascii", newline="") as source:
        rows = {tuple(row["chave"].split("|")): row for row in csv.DictReader(source, delimiter="\t")}
    for body, sign, house, motion in VALIDATION_SUNS:
        key = (body, sign, str(house), motion)
        row = rows[key]
        jd, lat, lon = (float(row[field]) for field in ("dia_juliano_ut", "latitude", "longitude"))
        contents = validation_input(jd, lat, lon, row["sistema"], (body, sign, house, motion))
        filename = f"sol-{sign.lower()}-casa-{house}.txt"
        (directory / filename).write_text(contents, encoding="utf-8", newline="\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ephemeris", type=Path, help="Diretório com os três arquivos .se1")
    parser.add_argument("output", type=Path, help="Arquivo TSV a gravar ou usar como fonte dos mapas")
    parser.add_argument("--mapas-validacao", type=Path, metavar="DIRETORIO",
                        help="Gerar mapas sintéticos a partir do TSV existente")
    args = parser.parse_args()
    if swe.version != "2.10.03":
        raise RuntimeError(f"Esperado Swiss Ephemeris 2.10.03, recebido {swe.version}")
    for filename, expected_hash in EPHEMERIS_FILES.items():
        digest = sha256((args.ephemeris / filename).read_bytes()).hexdigest()
        if digest != expected_hash:
            raise RuntimeError(f"SHA-256 inesperado: {filename}")
    swe.set_ephe_path(str(args.ephemeris.resolve()))
    if args.mapas_validacao:
        write_validation_inputs(args.mapas_validacao, args.output)
        return
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
