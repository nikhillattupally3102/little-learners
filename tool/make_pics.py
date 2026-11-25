"""Run: python3 tool/make_pics.py . tool/picture_pack.html

Builds the app's picture library: assets/pics/<codepoints>.svg + lib/widgets/pic_index.dart.

Pictures come from (1) the approved gallery page and (2) the NEW batch below.
Every SVG uses inline attributes only (flutter_svg doesn't support CSS classes).
"""
import re, sys, pathlib

APP = pathlib.Path(sys.argv[1])
GALLERY = pathlib.Path(sys.argv[2])
OUT = APP / 'assets' / 'pics'
OUT.mkdir(parents=True, exist_ok=True)

INKC = '#2D2A4A'
O = f'stroke="{INKC}" stroke-width="4" stroke-linejoin="round" stroke-linecap="round"'
O3 = f'stroke="{INKC}" stroke-width="3" stroke-linejoin="round" stroke-linecap="round"'
L = f'fill="none" {O}'
L3 = f'fill="none" {O3}'
INK = f'fill="{INKC}"'
SH = 'fill="#FFFFFF" fill-opacity="0.55"'
CK = 'fill="#FF8FA3" fill-opacity="0.7"'


def code(emoji):
    if emoji.startswith('pic:'):  # named pictures with no emoji, e.g. pic:mars
        return emoji[4:]
    return '-'.join(f'{ord(c):x}' for c in emoji if ord(c) != 0xFE0F)


def wrap(body):
    return f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">{body}</svg>'


# ------------------------------------------------ 1. approved gallery pictures
CLASS = {'o': O, 'l': L, 'ink': INK, 'shine': SH, 'cheek': CK}
GALLERY_EMOJI = {
    'Lion': ['🦁'], 'Elephant': ['🐘'], 'Cat': ['🐱', '🐈'], 'Dog': ['🐶', '🐕'], 'Frog': ['🐸'],
    'Pig': ['🐷', '🐖'], 'Owl': ['🦉'], 'Fish': ['🐟'], 'Apple': ['🍎'], 'Banana': ['🍌'],
    'Strawberry': ['🍓'], 'Grapes': ['🍇'], 'Orange': ['🍊'], 'Watermelon slice': ['🍉'], 'Pear': ['🍐'],
    'Cherries': ['🍒'], 'Eye': ['👀'], 'Ear': ['👂'], 'Nose': ['👃'], 'Mouth': ['👄'], 'Hand': ['✋', '🖐️'],
    'Foot': ['🦶'], 'Tooth': ['🦷'], 'Brain': ['🧠'],
}


def inline(svg_inner):
    def fix(m):
        tag = m.group(0)
        cls = re.search(r'class="([^"]+)"', tag)
        style = re.search(r'style="stroke-width:([\d.]+)"', tag)
        attrs = ' '.join(CLASS[c] for c in cls.group(1).split()) if cls else ''
        tag = re.sub(r'\s*class="[^"]+"', '', tag)
        tag = re.sub(r'\s*style="[^"]+"', '', tag)
        if style:
            attrs = re.sub(r'stroke-width="[\d.]+"', f'stroke-width="{style.group(1)}"', attrs)
        if attrs:
            # Explicit fill on the element wins over a class fill.
            if 'fill="' in tag and 'fill="' in attrs:
                attrs = re.sub(r'fill="[^"]+"\s*', '', attrs)
            tag = re.sub(r'(/?>)$', f' {attrs}\\1', tag)
        return tag
    return re.sub(r'<[a-z]+\b[^>]*>', fix, svg_inner)


html = GALLERY.read_text()
pics = {}
for m in re.finditer(r'<svg viewBox="0 0 120 120" role="img" aria-label="([^"]+)">(.*?)</svg>', html, re.S):
    label, inner = m.group(1), m.group(2)
    body = inline(inner.strip())
    for e in GALLERY_EMOJI[label]:
        pics[e] = body

# ---------------------------------------------------------------- 2. new batch
def star_points(cx, cy, R, r):
    import math
    pts = []
    for i in range(10):
        rad = R if i % 2 == 0 else r
        a = math.radians(-90 + i * 36)
        pts.append(f'{cx + rad * math.cos(a):.1f},{cy + rad * math.sin(a):.1f}')
    return ' '.join(pts)


def rays(cx, cy, r1, r2, n, color):
    import math
    segs = []
    for i in range(n):
        a = math.radians(i * 360 / n)
        segs.append(f'M{cx + r1 * math.cos(a):.1f} {cy + r1 * math.sin(a):.1f} L{cx + r2 * math.cos(a):.1f} {cy + r2 * math.sin(a):.1f}')
    d = ' '.join(segs)
    return (f'<path d="{d}" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>'
            f'<path d="{d}" fill="none" stroke="{color}" stroke-width="5" stroke-linecap="round"/>')


def blob(circles, fill):
    """Overlapping circles with a single outer outline (cloud/tree-top shape)."""
    outl = ''.join(f'<circle cx="{x}" cy="{y}" r="{r}" fill="{fill}" {O}/>' for x, y, r in circles)
    cover = ''.join(f'<circle cx="{x}" cy="{y}" r="{r - 2.2}" fill="{fill}"/>' for x, y, r in circles)
    return outl + cover


def outlined(d, fill, extra=''):
    return f'<path d="{d}" fill="{fill}" {O} {extra}/>'


def eyes(x1, x2, y, r=3.6):
    return f'<circle cx="{x1}" cy="{y}" r="{r}" {INK}/><circle cx="{x2}" cy="{y}" r="{r}" {INK}/>'


def smile(x1, x2, y, depth=6):
    return f'<path d="M{x1} {y} Q{(x1 + x2) / 2} {y + depth} {x2} {y}" {L3}/>'


def cheeks(x1, x2, y, r=3.8):
    return f'<circle cx="{x1}" cy="{y}" r="{r}" {CK}/><circle cx="{x2}" cy="{y}" r="{r}" {CK}/>'


def wheel(cx, cy, r=11):
    return f'<circle cx="{cx}" cy="{cy}" r="{r}" {INK}/><circle cx="{cx}" cy="{cy}" r="{r * 0.42:.1f}" fill="#B8C4D6"/>'


petals = ''.join(f'<ellipse cx="60" cy="20" rx="9" ry="15" fill="#FFD93D" {O3} transform="rotate({k * 30} 60 46)"/>' for k in range(12))

NEW = {
    '🐝': f'''<ellipse cx="46" cy="34" rx="13" ry="18" fill="#DFF3FF" {O3} transform="rotate(-20 46 34)"/>
<ellipse cx="72" cy="32" rx="13" ry="18" fill="#DFF3FF" {O3} transform="rotate(20 72 32)"/>
<path d="M94 64 L108 62 L94 72 Z" {INK} {O3}/>
<ellipse cx="62" cy="66" rx="34" ry="25" fill="#FFD93D" {O}/>
<path d="M52 44 V88 M70 43 V89" fill="none" stroke="{INKC}" stroke-width="8"/>
<circle cx="30" cy="64" r="15" fill="#FFD93D" {O}/>
<path d="M26 50 Q20 36 13 34 M33 49 Q35 36 41 32" {L3}/><circle cx="13" cy="34" r="3.5" {INK}/><circle cx="41" cy="32" r="3.5" {INK}/>
<circle cx="25" cy="61" r="3.2" {INK}/><path d="M21 70 Q26 74 31 70" {L3}/><circle cx="34" cy="69" r="3" {CK}/>''',

    '⭐': f'''<polygon points="{star_points(60, 63, 50, 23)}" fill="#FFD93D" {O}/>
<circle cx="52" cy="60" r="3.6" {INK}/><circle cx="68" cy="60" r="3.6" {INK}/>
<path d="M53 70 Q60 76 67 70" {L3}/><circle cx="45" cy="68" r="3.5" {CK}/><circle cx="75" cy="68" r="3.5" {CK}/>''',

    '🦆': f'''<path d="M98 62 L112 48 L106 72 Z" fill="#FFD93D" {O}/>
<ellipse cx="66" cy="74" rx="38" ry="25" fill="#FFD93D" {O}/>
<path d="M58 72 Q76 60 90 75 Q74 88 58 72 Z" fill="#F5C518" {O3}/>
<circle cx="36" cy="44" r="21" fill="#FFD93D" {O}/>
<path d="M17 45 Q4 49 14 57 L24 55 L24 45 Z" fill="#FF9F2E" {O3}/>
<circle cx="38" cy="39" r="3.6" {INK}/><circle cx="44" cy="50" r="3.5" {CK}/>''',

    '🚗': f'''<path d="M12 72 V62 Q14 52 26 50 H36 L46 34 Q49 30 55 30 H80 Q86 30 90 36 L99 50 Q108 52 108 62 V72 Q108 78 102 78 H18 Q12 78 12 72 Z" fill="#F2545B" {O}/>
<path d="M50 36 H64 V50 H42 Z" fill="#CDEBFF" {O3}/><path d="M70 36 H82 Q85 36 87 40 L92 50 H70 Z" fill="#CDEBFF" {O3}/>
<path d="M66 54 V74" {L3}/><circle cx="104" cy="63" r="3.5" fill="#FFD93D"/>
<circle cx="36" cy="80" r="12" {INK}/><circle cx="36" cy="80" r="5" fill="#B8C4D6"/>
<circle cx="88" cy="80" r="12" {INK}/><circle cx="88" cy="80" r="5" fill="#B8C4D6"/>
<ellipse cx="28" cy="60" rx="7" ry="3" {SH}/>''',

    '🐻': f'''<circle cx="33" cy="30" r="13" fill="#A0704D" {O}/><circle cx="87" cy="30" r="13" fill="#A0704D" {O}/>
<circle cx="33" cy="30" r="6" fill="#E8C9A0"/><circle cx="87" cy="30" r="6" fill="#E8C9A0"/>
<circle cx="60" cy="62" r="38" fill="#A0704D" {O}/>
<ellipse cx="60" cy="77" rx="17" ry="13" fill="#E8C9A0" {O3}/><ellipse cx="60" cy="71" rx="6" ry="4.5" {INK}/>
<path d="M60 75 V79 Q55 84 51 80 M60 79 Q65 84 69 80" {L3}/>
<circle cx="46" cy="54" r="4" {INK}/><circle cx="74" cy="54" r="4" {INK}/>
<circle cx="37" cy="70" r="4.5" {CK}/><circle cx="83" cy="70" r="4.5" {CK}/>''',

    '🌳': f'''<path d="M52 70 L49 110 H71 L68 70 Z" fill="#8A5A3B" {O}/>
{blob([(38, 58, 22), (82, 58, 22), (60, 36, 27), (60, 66, 22)], '#4CAF50')}
<circle cx="44" cy="52" r="4.5" fill="#F2545B"/><circle cx="74" cy="44" r="4.5" fill="#F2545B"/><circle cx="66" cy="70" r="4.5" fill="#F2545B"/>
<ellipse cx="50" cy="30" rx="8" ry="4" {SH}/>''',

    '🌙': f'''<path d="M72 12 A47 47 0 1 0 106 82 A36 36 0 0 1 72 12 Z" fill="#FFD93D" {O}/>
<path d="M36 56 Q41 60 46 56" {L3}/><path d="M38 72 Q45 78 52 72" {L3}/><circle cx="32" cy="66" r="3.5" {CK}/>
<polygon points="{star_points(98, 28, 10, 4.5)}" fill="#FFD93D" {O3}/>''',

    '⚽': f'''<circle cx="60" cy="60" r="47" fill="#FFFFFF" {O}/>
<polygon points="60,44 73.3,53.7 68.2,69.3 51.8,69.3 46.7,53.7" {INK}/>
<path d="M60 44 V18 M73.3 53.7 L95 46 M68.2 69.3 L82 90 M51.8 69.3 L38 90 M46.7 53.7 L25 46" fill="none" stroke="{INKC}" stroke-width="3"/>
<path d="M50 14 L60 18 L70 14 M95 46 L104 40 M95 46 L100 58 M82 90 L80 102 M82 90 L94 86 M38 90 L40 102 M38 90 L26 86 M25 46 L16 40 M25 46 L20 58" fill="none" stroke="{INKC}" stroke-width="3"/>''',

    '🏠': f'''<rect x="76" y="22" width="12" height="24" fill="#B5734F" {O}/>
<rect x="24" y="56" width="72" height="50" fill="#FFD9A0" {O}/>
<path d="M12 62 L60 18 L108 62 Z" fill="#F2545B" {O}/>
<rect x="50" y="76" width="20" height="30" rx="4" fill="#8A5A3B" {O3}/><circle cx="65" cy="92" r="2" fill="#FFD93D"/>
<rect x="30" y="68" width="14" height="14" fill="#CDEBFF" {O3}/><rect x="76" y="68" width="14" height="14" fill="#CDEBFF" {O3}/>''',

    '🎈': f'''<path d="M60 90 Q52 99 60 106 Q68 113 60 119" fill="none" stroke="{INKC}" stroke-width="2.5" stroke-linecap="round"/>
<path d="M60 12 C36 12 24 32 26 50 C28 70 46 86 60 89 C74 86 92 70 94 50 C96 32 84 12 60 12 Z" fill="#F2545B" {O}/>
<path d="M55 89 H65 L60 95 Z" fill="#F2545B" {O3}/>
<ellipse cx="44" cy="36" rx="6" ry="12" {SH} transform="rotate(20 44 36)"/>''',

    '☀️': f'''{rays(60, 60, 42, 54, 8, '#FF9F2E')}
<circle cx="60" cy="60" r="32" fill="#FFD93D" {O}/>
<circle cx="50" cy="56" r="3.6" {INK}/><circle cx="70" cy="56" r="3.6" {INK}/>
<path d="M50 67 Q60 75 70 67" {L3}/><circle cx="43" cy="65" r="3.5" {CK}/><circle cx="77" cy="65" r="3.5" {CK}/>''',

    '🚌': f'''<rect x="8" y="24" width="104" height="62" rx="12" fill="#FFC93C" {O}/>
<path d="M8 68 H112" fill="none" stroke="#F28C28" stroke-width="5"/>
<rect x="18" y="34" width="18" height="20" rx="3" fill="#CDEBFF" {O3}/><rect x="42" y="34" width="18" height="20" rx="3" fill="#CDEBFF" {O3}/>
<rect x="66" y="34" width="18" height="20" rx="3" fill="#CDEBFF" {O3}/><rect x="90" y="34" width="14" height="28" rx="3" fill="#CDEBFF" {O3}/>
<circle cx="102" cy="76" r="3.5" fill="#FFFFFF" {O3}/>
<circle cx="32" cy="88" r="11" {INK}/><circle cx="32" cy="88" r="4.5" fill="#B8C4D6"/>
<circle cx="86" cy="88" r="11" {INK}/><circle cx="86" cy="88" r="4.5" fill="#B8C4D6"/>''',

    '🦋': f'''<ellipse cx="36" cy="44" rx="26" ry="22" fill="#8E5CF7" {O} transform="rotate(-20 36 44)"/>
<ellipse cx="84" cy="44" rx="26" ry="22" fill="#8E5CF7" {O} transform="rotate(20 84 44)"/>
<ellipse cx="40" cy="82" rx="18" ry="16" fill="#FF8FA3" {O}/><ellipse cx="80" cy="82" rx="18" ry="16" fill="#FF8FA3" {O}/>
<circle cx="32" cy="42" r="7" fill="#FFFFFF" fill-opacity="0.7"/><circle cx="88" cy="42" r="7" fill="#FFFFFF" fill-opacity="0.7"/>
<circle cx="40" cy="84" r="5" fill="#FFD93D"/><circle cx="80" cy="84" r="5" fill="#FFD93D"/>
<ellipse cx="60" cy="66" rx="7" ry="32" {INK}/><circle cx="60" cy="30" r="9" {INK}/>
<path d="M57 23 Q50 9 43 8 M63 23 Q70 9 77 8" {L3}/><circle cx="43" cy="8" r="3.5" {INK}/><circle cx="77" cy="8" r="3.5" {INK}/>
<circle cx="56.5" cy="29" r="1.8" fill="#FFFFFF"/><circle cx="63.5" cy="29" r="1.8" fill="#FFFFFF"/>''',

    '🐰': f'''<ellipse cx="44" cy="30" rx="10" ry="26" fill="#EDEDF2" {O}/><ellipse cx="76" cy="30" rx="10" ry="26" fill="#EDEDF2" {O}/>
<ellipse cx="44" cy="32" rx="5" ry="17" fill="#F7A1B0"/><ellipse cx="76" cy="32" rx="5" ry="17" fill="#F7A1B0"/>
<ellipse cx="60" cy="74" rx="35" ry="30" fill="#EDEDF2" {O}/>
<circle cx="47" cy="68" r="4" {INK}/><circle cx="73" cy="68" r="4" {INK}/>
<path d="M56 77 H64 L60 81 Z" fill="#F27C8E"/>
<path d="M60 81 Q56 86 52 83 M60 81 Q64 86 68 83" {L3}/>
<rect x="56" y="85" width="8" height="7" rx="1.5" fill="#FFFFFF" stroke="{INKC}" stroke-width="2"/>
<circle cx="38" cy="80" r="4.5" {CK}/><circle cx="82" cy="80" r="4.5" {CK}/>''',
    '🐇': None,

    '🦒': f'''<path d="M52 114 L50 50 H70 L72 114 Z" fill="#F6C453" {O}/>
<circle cx="57" cy="66" r="5" fill="#C9822A"/><circle cx="64" cy="82" r="6" fill="#C9822A"/><circle cx="56" cy="97" r="5" fill="#C9822A"/><circle cx="66" cy="106" r="4" fill="#C9822A"/>
<path d="M52 26 L49 11 M68 24 L71 9" {L}/><circle cx="49" cy="10" r="4.5" fill="#A0704D" {O3}/><circle cx="71" cy="8" r="4.5" fill="#A0704D" {O3}/>
<ellipse cx="38" cy="30" rx="9" ry="4.5" fill="#F6C453" {O3} transform="rotate(-20 38 30)"/>
<ellipse cx="60" cy="38" rx="24" ry="17" fill="#F6C453" {O}/>
<ellipse cx="74" cy="45" rx="13" ry="10" fill="#FBE3A6" {O3}/><circle cx="79" cy="43" r="1.8" {INK}/><circle cx="71" cy="43" r="1.8" {INK}/>
<circle cx="54" cy="34" r="3.6" {INK}/><path d="M69 51 Q74 54 79 51" {L3}/>''',

    '🎂': f'''<ellipse cx="60" cy="102" rx="50" ry="8" fill="#E8E3F3" {O3}/>
<rect x="22" y="56" width="76" height="44" rx="8" fill="#F7C08A" {O}/>
<path d="M22 66 Q22 54 34 54 H86 Q98 54 98 66 Q92 74 86 66 Q80 74 74 66 Q68 74 62 66 Q56 74 50 66 Q44 74 38 66 Q32 74 26 70 Z" fill="#FF8FC0" {O3}/>
<rect x="40" y="34" width="7" height="22" fill="#4FA8F0" {O3}/><rect x="57" y="34" width="7" height="22" fill="#8BD346" {O3}/><rect x="74" y="34" width="7" height="22" fill="#8E5CF7" {O3}/>
<path d="M43.5 18 Q50 27 43.5 31 Q37 27 43.5 18 Z M60.5 18 Q67 27 60.5 31 Q54 27 60.5 18 Z M77.5 18 Q84 27 77.5 31 Q71 27 77.5 18 Z" fill="#FFB020" stroke="{INKC}" stroke-width="2.5" stroke-linejoin="round"/>
<path d="M34 84 l5 -3 M54 88 l5 2 M76 82 l4 4 M88 90 l4 -3" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>''',

    '🥚': f'''<path d="M60 12 C40 12 26 48 26 72 C26 94 42 108 60 108 C78 108 94 94 94 72 C94 48 80 12 60 12 Z" fill="#FFF6E5" {O}/>
<circle cx="72" cy="58" r="2.5" fill="#E8C9A0"/><circle cx="54" cy="84" r="2" fill="#E8C9A0"/><circle cx="76" cy="88" r="2.5" fill="#E8C9A0"/>
<ellipse cx="45" cy="50" rx="6" ry="13" {SH} transform="rotate(15 45 50)"/>''',

    '🐮': f'''<path d="M34 32 Q29 17 40 15 Q40 25 45 30 Z" fill="#F3E6C8" {O3}/><path d="M86 32 Q91 17 80 15 Q80 25 75 30 Z" fill="#F3E6C8" {O3}/>
<ellipse cx="23" cy="48" rx="13" ry="7" fill="#FFFFFF" {O} transform="rotate(-20 23 48)"/><ellipse cx="97" cy="48" rx="13" ry="7" fill="#FFFFFF" {O} transform="rotate(20 97 48)"/>
<ellipse cx="60" cy="58" rx="31" ry="33" fill="#FFFFFF" {O}/>
<path d="M38 36 Q48 29 53 40 Q51 53 40 53 Q33 46 38 36 Z" {INK}/>
<ellipse cx="60" cy="84" rx="25" ry="16" fill="#F9B8C6" {O}/>
<ellipse cx="51" cy="84" rx="3.2" ry="4.6" fill="#B5536A"/><ellipse cx="69" cy="84" rx="3.2" ry="4.6" fill="#B5536A"/>
<circle cx="70" cy="58" r="4" {INK}/><circle cx="48" cy="58" r="4.6" fill="#FFFFFF"/><circle cx="48" cy="58" r="3" {INK}/>''',
    '🐄': None,

    '🐭': f'''<circle cx="31" cy="40" r="19" fill="#B8C4D6" {O}/><circle cx="89" cy="40" r="19" fill="#B8C4D6" {O}/>
<circle cx="31" cy="40" r="10" fill="#F7A1B0"/><circle cx="89" cy="40" r="10" fill="#F7A1B0"/>
<ellipse cx="60" cy="70" rx="31" ry="29" fill="#B8C4D6" {O}/>
<circle cx="50" cy="64" r="4" {INK}/><circle cx="70" cy="64" r="4" {INK}/>
<circle cx="60" cy="77" r="5" fill="#F27C8E" {O3}/>
<path d="M30 74 L46 77 M30 84 L46 81 M90 74 L74 77 M90 84 L74 81" fill="none" stroke="{INKC}" stroke-width="2.5" stroke-linecap="round"/>
<path d="M54 86 Q60 90 66 86" {L3}/>''',
    '🐁': None,

    '🐒': f'''<circle cx="23" cy="60" r="13" fill="#A0704D" {O}/><circle cx="97" cy="60" r="13" fill="#A0704D" {O}/>
<circle cx="23" cy="60" r="7" fill="#F3D3A8"/><circle cx="97" cy="60" r="7" fill="#F3D3A8"/>
<circle cx="60" cy="58" r="37" fill="#A0704D" {O}/>
<path d="M60 44 C48 30 30 40 34 58 C36 72 30 84 46 90 Q60 96 74 90 C90 84 84 72 86 58 C90 40 72 30 60 44 Z" fill="#F3D3A8" {O3}/>
<circle cx="48" cy="58" r="4" {INK}/><circle cx="72" cy="58" r="4" {INK}/>
<circle cx="56" cy="72" r="2" {INK}/><circle cx="64" cy="72" r="2" {INK}/>
<path d="M47 80 Q60 90 73 80" {L3}/>''',
    '🐵': None,

    '🐢': f'''<path d="M12 74 L2 79 L12 82 Z" fill="#8BD346" {O3}/>
<ellipse cx="34" cy="86" rx="10" ry="8" fill="#8BD346" {O}/><ellipse cx="82" cy="86" rx="10" ry="8" fill="#8BD346" {O}/>
<circle cx="101" cy="62" r="13" fill="#8BD346" {O}/>
<path d="M12 78 Q14 30 58 28 Q100 30 104 78 Z" fill="#4CAF50" {O}/>
<path d="M36 78 L44 56 H72 L80 78 M44 56 L36 40 M72 56 L80 40 M52 31 L58 56 M64 31 L58 56" fill="none" stroke="#2E7D32" stroke-width="3" stroke-linecap="round"/>
<circle cx="105" cy="58" r="3.2" {INK}/><path d="M99 67 Q104 70 109 67" {L3}/>''',

    '🥕': f'''<path d="M52 34 Q38 10 45 5 Q56 17 58 30 Q60 4 69 5 Q72 20 63 32 Q78 12 85 16 Q81 30 67 36 Z" fill="#4CAF50" {O3}/>
<path d="M38 36 Q60 26 82 36 Q75 70 63 108 Q60 115 57 108 Q45 70 38 36 Z" fill="#FF8C42" {O}/>
<path d="M48 52 H56 M64 64 H72 M52 80 H59 M62 92 H67" fill="none" stroke="#D9661F" stroke-width="3" stroke-linecap="round"/>''',

    '🎩': f'''<ellipse cx="60" cy="94" rx="48" ry="12" fill="#2D2A4A" {O}/>
<path d="M30 94 L34 30 Q60 22 86 30 L90 94 Z" fill="#3B3660" {O}/>
<ellipse cx="60" cy="30" rx="26" ry="7" fill="#4A4475" {O3}/>
<path d="M33 74 Q60 80 87 74 L88 86 Q60 92 32 86 Z" fill="#F2545B" {O3}/>
<ellipse cx="44" cy="52" rx="4" ry="12" fill="#FFFFFF" fill-opacity="0.25"/>''',

    '🐧': f'''<ellipse cx="24" cy="72" rx="8" ry="21" fill="#2D2A4A" {O} transform="rotate(15 24 72)"/>
<ellipse cx="96" cy="72" rx="8" ry="21" fill="#2D2A4A" {O} transform="rotate(-15 96 72)"/>
<ellipse cx="46" cy="110" rx="11" ry="5" fill="#FF9F2E" {O3}/><ellipse cx="74" cy="110" rx="11" ry="5" fill="#FF9F2E" {O3}/>
<ellipse cx="60" cy="64" rx="36" ry="48" fill="#3B3660" {O}/>
<ellipse cx="60" cy="74" rx="24" ry="35" fill="#FFFFFF"/>
<circle cx="50" cy="48" r="4" {INK}/><circle cx="70" cy="48" r="4" {INK}/>
<path d="M54 56 H66 L60 64 Z" fill="#FF9F2E" {O3}/>
<circle cx="44" cy="58" r="3.5" {CK}/><circle cx="76" cy="58" r="3.5" {CK}/>''',

    '🐞': f'''<path d="M24 56 L12 50 M22 72 L8 72 M26 88 L14 96 M96 56 L108 50 M98 72 L112 72 M94 88 L106 96" {L}/>
<circle cx="60" cy="24" r="15" {INK} {O}/>
<path d="M54 12 Q48 2 42 4 M66 12 Q72 2 78 4" {L3}/>
<circle cx="60" cy="66" r="40" fill="#F2545B" {O}/>
<path d="M60 27 V106" {L}/>
<circle cx="41" cy="52" r="7" {INK}/><circle cx="79" cy="52" r="7" {INK}/><circle cx="36" cy="76" r="6" {INK}/><circle cx="84" cy="76" r="6" {INK}/>
<circle cx="49" cy="94" r="5" {INK}/><circle cx="71" cy="94" r="5" {INK}/>
<circle cx="54" cy="22" r="3" fill="#FFFFFF"/><circle cx="66" cy="22" r="3" fill="#FFFFFF"/>
<ellipse cx="42" cy="40" rx="6" ry="3" {SH}/>''',

    '🦊': f'''<path d="M26 50 L22 10 L52 34 Z" fill="#FF8C42" {O}/><path d="M94 50 L98 10 L68 34 Z" fill="#FF8C42" {O}/>
<path d="M30 40 L28 20 L44 33 Z" {INK}/><path d="M90 40 L92 20 L76 33 Z" {INK}/>
<path d="M14 52 Q24 30 60 34 Q96 30 106 52 Q96 76 60 100 Q24 76 14 52 Z" fill="#FF8C42"/>
<path d="M16 54 Q34 62 46 76 L60 98 Q24 78 16 54 Z M104 54 Q86 62 74 76 L60 98 Q96 78 104 54 Z" fill="#FFFFFF"/>
<path d="M14 52 Q24 30 60 34 Q96 30 106 52 Q96 76 60 100 Q24 76 14 52 Z" {L}/>
<ellipse cx="44" cy="58" rx="4" ry="5" {INK}/><ellipse cx="76" cy="58" rx="4" ry="5" {INK}/>
<circle cx="60" cy="94" r="5" {INK}/>''',

    '🐴': f'''<path d="M40 32 L44 10 L54 27 Z" fill="#B5734F" {O}/><path d="M80 32 L76 10 L66 27 Z" fill="#B5734F" {O}/>
<path d="M38 30 Q60 18 82 30 Q86 70 78 98 Q60 112 42 98 Q34 70 38 30 Z" fill="#C98A5A" {O}/>
<path d="M56 44 H64 L62 80 H58 Z" fill="#FFFFFF"/>
<path d="M50 22 Q60 6 70 22 L66 40 Q60 32 54 40 Z" fill="#5B3A22" {O3}/>
<ellipse cx="60" cy="94" rx="18" ry="12" fill="#E8B98E" {O3}/>
<ellipse cx="53" cy="94" rx="2.6" ry="3.6" {INK}/><ellipse cx="67" cy="94" rx="2.6" ry="3.6" {INK}/>
<circle cx="46" cy="56" r="4" {INK}/><circle cx="74" cy="56" r="4" {INK}/>''',

    '🔑': f'''<rect x="88" y="62" width="8" height="16" fill="#FFC93C" {O3}/><rect x="100" y="62" width="8" height="12" fill="#FFC93C" {O3}/>
<rect x="52" y="54" width="60" height="12" rx="4" fill="#FFC93C" {O}/>
<circle cx="34" cy="60" r="23" fill="#FFC93C" {O}/><circle cx="34" cy="60" r="8" fill="#FFFFFF" {O3}/>
<ellipse cx="25" cy="48" rx="6" ry="3" {SH}/>''',

    '🌻': f'''<path d="M60 70 Q58 92 60 116" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>
<path d="M60 70 Q58 92 60 116" fill="none" stroke="#4CAF50" stroke-width="6" stroke-linecap="round"/>
<path d="M59 98 Q40 80 28 94 Q44 108 59 98 Z" fill="#6CC24A" {O3}/>
{petals}
<circle cx="60" cy="46" r="18" fill="#8A5A3B" {O}/>
<circle cx="54" cy="42" r="2" fill="#5B3A22"/><circle cx="64" cy="40" r="2" fill="#5B3A22"/><circle cx="60" cy="50" r="2" fill="#5B3A22"/><circle cx="68" cy="50" r="2" fill="#5B3A22"/><circle cx="52" cy="52" r="2" fill="#5B3A22"/>''',

    '🐜': f'''<path d="M44 66 L32 88 M50 68 V92 M56 66 L68 88" {L3}/>
<path d="M20 46 Q16 32 8 30 M28 45 Q30 32 38 26" {L3}/>
<ellipse cx="86" cy="62" rx="23" ry="18" fill="#B5402A" {O}/>
<ellipse cx="51" cy="60" rx="13" ry="10" fill="#B5402A" {O}/>
<circle cx="24" cy="56" r="13" fill="#B5402A" {O}/>
<circle cx="20" cy="53" r="3.2" fill="#FFFFFF" stroke="{INKC}" stroke-width="2"/>
<ellipse cx="80" cy="54" rx="7" ry="3" {SH}/>''',
}

# Further batches: tool/pics/batch_*.py, each defining BATCH = {emoji: svg body}
# (and optionally ALIASES), using the helpers above.
import glob as _glob
_extra_aliases = {}
for _f in sorted(_glob.glob(str(APP / 'tool' / 'pics' / 'batch_*.py'))):
    _ns = dict(globals())
    exec(open(_f, encoding='utf-8').read(), _ns)
    NEW.update(_ns['BATCH'])
    _extra_aliases.update(_ns.get('ALIASES', {}))

# Aliases: same drawing for closely related emoji.
ALIASES = {'🐇': '🐰', '🐄': '🐮', '🐁': '🐭', '🐵': '🐒'}
for e, body in NEW.items():
    if body is not None:
        pics[e] = body
ALIASES.update(_extra_aliases)
for alias, src in ALIASES.items():
    pics[alias] = pics[src]

for e, body in pics.items():
    (OUT / f'{code(e)}.svg').write_text(wrap(body.replace('\n', '')))

codes = sorted({code(e) for e in pics})
index = APP / 'lib' / 'widgets' / 'pic_index.dart'
index.write_text(
    '// GENERATED by make_pics.py — the emoji that have hand-drawn pictures.\n'
    '// File names are the emoji code points (without FE0F), e.g. 1f981.svg for 🦁.\n'
    f'const drawnPictures = <String>{{{", ".join(repr(c).replace(chr(39), chr(39)) for c in codes)}}};\n'
)
print(len(pics), 'emoji →', len(codes), 'files')
