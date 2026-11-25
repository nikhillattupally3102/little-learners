"""Draws globe pictures for the Continents & Oceans topic, in the app's
picture style, from Natural Earth data (public domain, naturalearthdata.com).

Usage: python3 -I tool/make_globes.py <natural-earth-geojson-dir>
  needs ne_110m_admin_0_countries, ne_110m_land and
  ne_110m_geography_marine_polys (.geojson)
Writes tool/pics/batch_10_globes.py; then run tool/make_pics.py.
"""
import json
import math
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
D = sys.argv[1]
countries = json.load(open(os.path.join(D, 'ne_110m_admin_0_countries.geojson')))['features']
land = json.load(open(os.path.join(D, 'ne_110m_land.geojson')))['features']
marine = json.load(open(os.path.join(D, 'ne_110m_geography_marine_polys.geojson')))['features']

CX = CY = 60
R = 50
INK = '#2D2A4A'

# name → (centre lon, centre lat, colour, continent names or ocean names)
CONTINENTS = {
    'africa': (18, 3, '#FFB627', ['Africa']),
    'asia': (95, 38, '#F2453F', ['Asia']),
    'europe': (18, 52, '#B07CE8', ['Europe']),
    'north_america': (-98, 42, '#5CC56E', ['North America']),
    'south_america': (-60, -16, '#FF8C42', ['South America']),
    'australia': (138, -24, '#FF6FB5', ['Oceania']),
    'antarctica': (0, -88, '#FFFFFF', ['Antarctica']),
}
OCEANS = {
    'pacific': (-165, 5, ['North Pacific Ocean', 'South Pacific Ocean', 'Coral Sea',
                         'Tasman Sea', 'Philippine Sea', 'Gulf of Alaska', 'South China Sea',
                         'Sea of Okhotsk', 'Sea of Japan']),
    'atlantic': (-32, 12, ['North Atlantic Ocean', 'South Atlantic Ocean', 'Caribbean Sea',
                           'Gulf of Mexico', 'Labrador Sea']),
    'indian': (78, -18, ['INDIAN OCEAN', 'Arabian Sea', 'Bay of Bengal']),
    'arctic': (0, 89, ['Arctic Ocean', 'Beaufort Sea', 'Baffin Bay']),
    'southern': (0, -89, ['SOUTHERN OCEAN', 'Ross Sea', 'Weddell Sea']),
}


def rings(geom):
    t, c = geom['type'], geom['coordinates']
    if t == 'Polygon':
        return c
    if t == 'MultiPolygon':
        return [r for poly in c for r in poly]
    return []


def densify(ring, step=3.0):
    out = []
    for (a, b), (c, d) in zip(ring, ring[1:] + ring[:1]):
        n = max(1, int(max(abs(c - a), abs(d - b)) / step))
        for i in range(n):
            out.append((a + (c - a) * i / n, b + (d - b) * i / n))
    return out


def _xyz(lon, lat, lon0, lat0):
    """Orthographic coordinates (x, y on the unit disc) and depth (>0 = front)."""
    lam, phi = math.radians(lon - lon0), math.radians(lat)
    p0 = math.radians(lat0)
    depth = math.sin(p0) * math.sin(phi) + math.cos(p0) * math.cos(phi) * math.cos(lam)
    x = math.cos(phi) * math.sin(lam)
    y = math.cos(p0) * math.sin(phi) - math.sin(p0) * math.cos(phi) * math.cos(lam)
    return x, y, depth


def _edge_point(a, b, lon0, lat0):
    """Where the segment a→b crosses the horizon (binary search)."""
    lo, hi = 0.0, 1.0
    va = _xyz(*a, lon0, lat0)[2] >= 0
    for _ in range(30):
        mid = (lo + hi) / 2
        p = (a[0] + (b[0] - a[0]) * mid, a[1] + (b[1] - a[1]) * mid)
        if (_xyz(*p, lon0, lat0)[2] >= 0) == va:
            lo = mid
        else:
            hi = mid
    p = (a[0] + (b[0] - a[0]) * lo, a[1] + (b[1] - a[1]) * lo)
    x, y, _ = _xyz(*p, lon0, lat0)
    d = math.hypot(x, y) or 1
    return math.atan2(y / d, x / d)


def _arc(a1, a2, steps=24):
    """Points along the horizon from angle a1 to a2 (shorter way round)."""
    d = (a2 - a1 + math.pi) % (2 * math.pi) - math.pi
    return [(math.cos(a1 + d * i / steps), math.sin(a1 + d * i / steps)) for i in range(steps + 1)]


def clip_ring(ring, lon0, lat0):
    """The visible part of a ring on the globe, closed along the horizon."""
    pts = densify(ring)
    vis = [_xyz(lo, la, lon0, lat0)[2] >= 0 for lo, la in pts]
    if not any(vis):
        return None
    if all(vis):
        return [_xyz(lo, la, lon0, lat0)[:2] for lo, la in pts]
    k = vis.index(False)  # start somewhere hidden, so runs are whole
    pts, vis = pts[k:] + pts[:k], vis[k:] + vis[:k]
    out, exit_angle = [], None
    n = len(pts)
    for i in range(n):
        a, b = pts[i], pts[(i + 1) % n]
        if vis[i]:
            out.append(_xyz(*a, lon0, lat0)[:2])
        if vis[i] and not vis[(i + 1) % n]:
            exit_angle = _edge_point(a, b, lon0, lat0)
            out.append((math.cos(exit_angle), math.sin(exit_angle)))
        elif not vis[i] and vis[(i + 1) % n]:
            entry = _edge_point(a, b, lon0, lat0)
            if exit_angle is not None:
                out.extend(_arc(exit_angle, entry))
            else:
                out.append((math.cos(entry), math.sin(entry)))
            exit_angle = None
    return out


def path(features, lon0, lat0, keep=lambda f: True):
    parts = []
    for f in features:
        if not keep(f):
            continue
        for ring in rings(f['geometry']):
            pts = clip_ring(ring, lon0, lat0)
            if not pts or len(pts) < 3:
                continue
            parts.append('M' + 'L'.join(f'{CX + R * x:.1f} {CY - R * y:.1f}' for x, y in pts) + 'Z')
    return ''.join(parts)


def globe(lon0, lat0, highlight_svg):
    clip = f'<clipPath id="g{abs(hash((lon0, lat0))) % 99999}"><circle cx="{CX}" cy="{CY}" r="{R}"/></clipPath>'
    cid = clip.split('"')[1]
    land_d = path(land, lon0, lat0)
    return (
        f'<defs>{clip}</defs>'
        f'<circle cx="{CX}" cy="{CY}" r="{R}" fill="#9ED8FF"/>'
        f'<g clip-path="url(#{cid})">{highlight_svg(land_d)}</g>'
        f'<circle cx="{CX}" cy="{CY}" r="{R}" fill="none" stroke="{INK}" stroke-width="4"/>'
        f'<ellipse cx="42" cy="34" rx="14" ry="8" fill="#FFFFFF" fill-opacity="0.35" transform="rotate(-30 42 34)"/>'
    )


batch = {}
for name, (lon0, lat0, color, conts) in CONTINENTS.items():
    hl = path(countries, lon0, lat0, lambda f: f['properties']['CONTINENT'] in conts)
    if name == 'antarctica':
        hl = path(land, lon0, lat0, lambda f: all(la < -60 for ring in rings(f['geometry']) for _, la in ring))
    batch[f'pic:{name}'] = globe(lon0, lat0, lambda land_d, hl=hl, color=color: (
        f'<path d="{land_d}" fill="#CDE6B8" stroke="#CDE6B8" stroke-width="0.6"/>'
        f'<path d="{hl}" fill="{INK}" stroke="{INK}" stroke-width="3.2" stroke-linejoin="round"/>'
        f'<path d="{hl}" fill="{color}" stroke="{color}" stroke-width="0.9" stroke-linejoin="round"/>'
    ))

for name, (lon0, lat0, seas) in OCEANS.items():
    hl = path(marine, lon0, lat0, lambda f: (f['properties'].get('name') or '') in seas)
    batch[f'pic:{name}'] = globe(lon0, lat0, lambda land_d, hl=hl: (
        f'<path d="{hl}" fill="#1F6FD1" stroke="#1F6FD1" stroke-width="1"/>'
        f'<path d="{land_d}" fill="#CDE6B8" stroke="#8FB57A" stroke-width="0.8" stroke-linejoin="round"/>'
    ))

out = os.path.join(ROOT, 'tool', 'pics', 'batch_10_globes.py')
with open(out, 'w') as f:
    f.write('# GENERATED by tool/make_globes.py from Natural Earth (public domain).\n')
    f.write('BATCH = {\n')
    for k, v in batch.items():
        f.write(f'    {k!r}: {v!r},\n')
    f.write('}\n')
print(len(batch), 'globes →', out)
