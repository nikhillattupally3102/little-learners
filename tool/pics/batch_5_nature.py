# Batch 5: nature, weather and space (including named planet pictures).
def planet(fill, extra=''):
    return f'<circle cx="60" cy="60" r="42" fill="{fill}" {O}/>{extra}<ellipse cx="44" cy="40" rx="10" ry="6" fill="#FFFFFF" fill-opacity="0.4" transform="rotate(-30 44 40)"/>'


def cloud(fill='#FFFFFF', y=0):
    return blob([(36, 62 + y, 18), (58, 50 + y, 22), (82, 58 + y, 18), (60, 70 + y, 16), (40, 72 + y, 14), (80, 72 + y, 14)], fill)


BATCH = {
    '🌱': f'''<path d="M20 100 Q60 92 100 100 Q100 112 60 112 Q20 112 20 100 Z" fill="#8A5A3B" {O3}/>
<path d="M60 100 V54" {L}/>
<path d="M60 64 Q30 66 22 40 Q50 32 60 64 Z" fill="#6CC24A" {O3}/>
<path d="M60 56 Q84 56 96 30 Q66 24 60 56 Z" fill="#8BD346" {O3}/>''',

    '💧': f'''<path d="M60 10 Q34 50 30 70 Q28 102 60 104 Q92 102 90 70 Q86 50 60 10 Z" fill="#4FA8F0" {O}/>
<ellipse cx="46" cy="72" rx="5" ry="12" {SH}/>{eyes(52, 68, 70, 3.2)}{smile(54, 66, 80, 4)}''',

    '💦': f'''<path d="M44 20 Q28 46 26 58 Q26 78 44 78 Q62 78 62 58 Q60 46 44 20 Z" fill="#4FA8F0" {O3}/>
<path d="M82 46 Q70 66 68 74 Q68 90 82 90 Q96 90 96 74 Q94 66 82 46 Z" fill="#4FA8F0" {O3}/>
<path d="M56 78 Q48 92 48 98 Q48 108 56 108 Q64 108 64 98 Q64 92 56 78 Z" fill="#4FA8F0" {O3}/>''',

    '🌈': f'''{''.join(f'<path d="M{14 + i * 8} 92 A{46 - i * 8} {46 - i * 8} 0 0 1 {106 - i * 8} 92" fill="none" stroke="{c}" stroke-width="8"/>' for i, c in enumerate(['#F2453F', '#FF9F2E', '#FFD93D', '#6CC24A', '#4FA8F0', '#8E5CF7']))}
<path d="M10 92 A50 50 0 0 1 110 92 M58 92 A2 2 0 0 1 62 92" {L3}/>
{blob([(18, 90, 12), (32, 94, 11)], '#FFFFFF')}{blob([(88, 94, 11), (102, 90, 12)], '#FFFFFF')}''',

    '🌸': f'''{''.join(f'<circle cx="60" cy="32" r="18" fill="#FFB3CE" {O3} transform="rotate({a} 60 60)"/>' for a in (0, 72, 144, 216, 288))}
{''.join(f'<circle cx="60" cy="32" r="15.5" fill="#FFB3CE" transform="rotate({a} 60 60)"/>' for a in (0, 72, 144, 216, 288))}
<circle cx="60" cy="60" r="12" fill="#FFD93D" {O3}/>''',

    '🍃': f'''<path d="M20 100 Q14 40 70 24 Q96 18 110 10 Q108 60 82 84 Q56 106 20 100 Z" fill="#6CC24A" {O}/>
<path d="M20 100 Q60 60 100 20 M50 72 L46 52 M66 56 L64 38 M50 72 L70 74 M66 56 L86 58" fill="none" stroke="#3E8E2A" stroke-width="3" stroke-linecap="round"/>''',

    '🌿': f'''<path d="M60 112 Q58 70 62 12" {L}/>
{''.join(f'<ellipse cx="{x}" cy="{y}" rx="16" ry="8" fill="#6CC24A" {O3} transform="rotate({r} {x} {y})"/>' for x, y, r in [(44, 88, 30), (78, 80, -30), (44, 60, 30), (78, 52, -30), (46, 34, 30), (76, 26, -30)])}''',

    '☁️': cloud(),

    '🌧️': f'''{cloud('#D6E2F0', -14)}
<path d="M38 82 L32 96 M58 84 L52 100 M78 82 L72 96 M48 102 L44 112 M68 102 L64 112" fill="none" stroke="#4FA8F0" stroke-width="5" stroke-linecap="round"/>''',

    '🌨️': f'''{cloud('#E3EAF4', -14)}
{''.join(f'<path d="M{x} {y - 6} V{y + 6} M{x - 5} {y - 3} L{x + 5} {y + 3} M{x + 5} {y - 3} L{x - 5} {y + 3}" fill="none" stroke="#4FA8F0" stroke-width="2.5" stroke-linecap="round"/>' for x, y in [(36, 92), (60, 98), (84, 92), (48, 110), (72, 110)])}''',

    '🌫️': f'''<path d="M14 40 H86 M30 56 H106 M14 72 H90 M28 88 H100" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>
<path d="M14 40 H86 M30 56 H106 M14 72 H90 M28 88 H100" fill="none" stroke="#D6E2F0" stroke-width="6" stroke-linecap="round"/>''',

    '🌪️': f'''<path d="M14 22 H106 Q100 38 22 36 M24 44 H94 Q88 58 32 56 M36 64 H84 Q78 76 44 74 M46 82 H72 Q68 92 54 92 M54 98 Q58 106 62 108" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M14 22 H106 Q100 38 22 36 M24 44 H94 Q88 58 32 56 M36 64 H84 Q78 76 44 74 M46 82 H72 Q68 92 54 92 M54 98 Q58 106 62 108" fill="none" stroke="#B8C4D6" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>''',

    '🌬️': f'''{cloud('#FFFFFF', -20)}
<path d="M18 74 H70 Q82 74 82 84 Q82 94 72 92 M18 88 H50 M30 100 H84 Q96 100 96 92" fill="none" stroke="#4FA8F0" stroke-width="5" stroke-linecap="round"/>''',

    '⛄': f'''<circle cx="60" cy="84" r="28" fill="#FFFFFF" {O}/>
<circle cx="60" cy="42" r="21" fill="#FFFFFF" {O}/>
<path d="M40 30 H80 L76 26 V10 H44 V26 Z" fill="#2D2A4A" {O3}/>
<path d="M40 56 Q60 66 80 56 L82 64 Q60 74 38 64 Z" fill="#F2453F" {O3}/>
<path d="M60 44 L76 48 L60 50 Z" fill="#FF8C42" {O3}/>
{eyes(53, 67, 38, 3)}
<g {INK}><circle cx="60" cy="78" r="3"/><circle cx="60" cy="90" r="3"/></g>
<path d="M34 76 L14 64 M86 76 L106 64" fill="none" stroke="#8A5A3B" stroke-width="4" stroke-linecap="round"/>''',

    '❄️': f'''<path d="M60 10 V110 M17 35 L103 85 M103 35 L17 85" {L}/>
<path d="M60 10 V110 M17 35 L103 85 M103 35 L17 85" fill="none" stroke="#9AD0FF" stroke-width="1"/>
<path d="M50 20 L60 30 L70 20 M50 100 L60 90 L70 100 M22 48 L34 46 L30 34 M98 72 L86 74 L90 86 M98 48 L86 46 L90 34 M22 72 L34 74 L30 86" {L3}/>''',

    '✨': f'''<polygon points="50,14 58,44 88,52 58,60 50,90 42,60 12,52 42,44" fill="#FFD93D" {O}/>
<polygon points="92,72 96,86 110,90 96,94 92,108 88,94 74,90 88,86" fill="#FFD93D" {O3}/>
<polygon points="92,12 95,22 105,25 95,28 92,38 89,28 79,25 89,22" fill="#FFD93D" {O3}/>''',

    '🌟': f'''<polygon points="{star_points(60, 62, 50, 23)}" fill="#FFD93D" {O}/>
<polygon points="{star_points(60, 62, 34, 16)}" fill="#FFF3A8"/>
<path d="M14 18 V30 M8 24 H20 M104 92 V104 M98 98 H110" fill="none" stroke="#FFB020" stroke-width="3.5" stroke-linecap="round"/>''',

    '🔥': f'''<path d="M60 8 Q66 34 86 48 Q104 64 98 84 Q90 108 60 110 Q30 108 22 84 Q16 62 36 46 Q38 60 46 62 Q42 40 60 8 Z" fill="#FF6B35" {O}/>
<path d="M60 46 Q64 64 76 74 Q84 84 78 96 Q72 106 60 106 Q48 106 42 96 Q38 82 50 72 Q52 82 56 82 Q52 66 60 46 Z" fill="#FFD25A"/>''',

    '⚡': f'''<polygon points="66,6 24,66 54,66 44,114 96,46 64,46 78,6" fill="#FFD93D" {O}/>''',

    '🌊': f'''<path d="M6 70 Q20 30 56 32 Q84 34 88 60 Q76 52 66 58 Q78 66 76 80 Q60 70 52 82 Q44 96 60 104 H6 Z" fill="#4FA8F0" {O}/>
<path d="M6 104 H114 V84 Q100 76 86 86 Q72 96 60 104" fill="#2E7FC4" {O}/>
<path d="M60 40 Q74 40 80 50" fill="none" stroke="#FFFFFF" stroke-width="4" stroke-linecap="round"/>''',

    '🌾': f'''{''.join(f'<path d="M{x} 112 Q{x + d} 70 {x + d * 2} 20" fill="none" stroke="#C9922A" stroke-width="4" stroke-linecap="round"/>' for x, d in [(44, -6), (60, 0), (76, 6)])}
{''.join(f'<ellipse cx="{x}" cy="{y}" rx="5" ry="9" fill="#F0C050" {O3} transform="rotate({r} {x} {y})"/>' for x, y, r in [(32, 26, -30), (40, 22, 20), (28, 40, -30), (38, 38, 25), (60, 18, -20), (66, 16, 25), (56, 32, -25), (66, 30, 25), (84, 26, -20), (92, 22, 30), (82, 40, -25), (92, 38, 30)])}''',

    '🌴': f'''<path d="M58 112 Q54 80 62 46" fill="none" stroke="{INKC}" stroke-width="14" stroke-linecap="round"/>
<path d="M58 112 Q54 80 62 46" fill="none" stroke="#A0704D" stroke-width="8" stroke-linecap="round"/>
<path d="M62 44 Q40 22 12 34 Q36 34 46 46 Z M62 44 Q84 22 110 34 Q86 34 76 46 Z M62 44 Q50 12 24 12 Q44 20 52 42 Z M62 44 Q74 12 100 12 Q80 20 72 42 Z M62 44 Q30 48 22 72 Q38 56 56 52 Z M62 44 Q94 48 102 72 Q86 56 68 52 Z" fill="#4CAF50" {O3}/>
<circle cx="56" cy="50" r="5" fill="#8A5A3B" {O3}/><circle cx="66" cy="52" r="5" fill="#8A5A3B" {O3}/>''',

    '🌵': f'''<path d="M48 112 V30 Q48 16 60 16 Q72 16 72 30 V112 Z" fill="#5FAE3B" {O}/>
<path d="M48 70 H32 Q24 70 24 60 V42 Q24 34 30 34 Q36 34 36 42 V58 H48 M72 60 H86 Q94 60 94 50 V32 Q94 24 88 24 Q82 24 82 32 V48 H72" fill="#5FAE3B" {O}/>
<path d="M56 34 v4 M64 50 v4 M56 70 v4 M64 88 v4 M30 48 v4 M88 36 v4" fill="none" stroke="#3E8E2A" stroke-width="3" stroke-linecap="round"/>
<path d="M30 112 H90" {L}/>''',

    '🏜️': f'''<circle cx="88" cy="30" r="14" fill="#FFD93D" {O3}/>
<path d="M4 82 Q30 56 56 74 Q80 52 116 70 V112 H4 Z" fill="#F0C080" {O}/>
<path d="M4 96 Q40 82 70 96 Q94 86 116 92" fill="none" stroke="#D99A50" stroke-width="3" stroke-linecap="round"/>
<path d="M30 72 V48 M30 58 H22 V50 M30 62 H38 V54" fill="none" stroke="#5FAE3B" stroke-width="5" stroke-linecap="round"/>''',

    '🌋': f'''<path d="M8 110 L44 40 H76 L112 110 Z" fill="#8A6A5A" {O}/>
<path d="M44 40 Q52 52 58 44 Q62 60 66 46 Q70 56 76 40 Z" fill="#FF6B35" {O3}/>
<path d="M48 40 Q40 22 52 14 Q56 4 66 10 Q80 10 76 24 Q74 34 70 40" fill="#9AA3B5" {O3}/>
<path d="M58 46 Q56 70 50 90 M66 48 Q70 66 74 80" fill="none" stroke="#FF6B35" stroke-width="5" stroke-linecap="round"/>''',

    '⛰️': f'''<path d="M4 108 L44 30 L66 70 L80 50 L116 108 Z" fill="#8F9BB3" {O}/>
<path d="M44 30 L33 52 L40 48 L46 56 L52 46 L56 52 Z" fill="#FFFFFF" {O3}/>
<path d="M80 50 L72 64 L80 60 L86 66 L89 60 Z" fill="#FFFFFF" stroke="{INKC}" stroke-width="2.5" stroke-linejoin="round"/>''',

    '🏞️': f'''<rect x="6" y="14" width="108" height="92" rx="10" fill="#CDEBFF" {O}/>
<path d="M6 76 L36 40 L56 62 L72 46 L114 86 V96 Q114 106 104 106 H16 Q6 106 6 96 Z" fill="#6CC24A" {O3}/>
<path d="M44 106 Q52 86 64 82 Q78 78 84 72" fill="none" stroke="#4FA8F0" stroke-width="7" stroke-linecap="round"/>
<circle cx="92" cy="32" r="9" fill="#FFD93D" {O3}/>''',

    '🏔️': f'''<path d="M4 108 L40 36 L60 64 L76 30 L116 108 Z" fill="#7F8FA6" {O}/>
<path d="M40 36 L28 60 L36 56 L42 64 L50 52 Z M76 30 L64 54 L72 50 L78 58 L86 46 Z" fill="#FFFFFF" {O3}/>''',

    '🍁': f'''<path d="M60 8 L68 30 L84 22 L80 44 L104 40 L92 56 L110 66 L84 72 L88 90 L64 80 L62 98 H58 L56 80 L32 90 L36 72 L10 66 L28 56 L16 40 L40 44 L36 22 L52 30 Z" fill="#E8522E" {O}/>
<path d="M60 98 V116 M60 44 V88" fill="none" stroke="{INKC}" stroke-width="3" stroke-linecap="round"/>''',

    '🍀': f'''{''.join(f'<path d="M60 58 Q36 50 38 30 Q42 16 56 22 Q62 26 60 32 Q58 26 64 22 Q78 16 82 30 Q84 50 60 58 Z" fill="#4CAF50" {O3} transform="rotate({a} 60 58)"/>' for a in (0, 90, 180, 270))}
<path d="M62 62 Q70 90 86 108" {L}/>''',

    '🌷': f'''<path d="M60 112 V58" fill="none" stroke="{INKC}" stroke-width="10" stroke-linecap="round"/>
<path d="M60 112 V58" fill="none" stroke="#4CAF50" stroke-width="4" stroke-linecap="round"/>
<path d="M60 98 Q34 92 30 68 Q50 72 60 92 Z" fill="#6CC24A" {O3}/>
<path d="M34 22 L46 34 L60 14 L74 34 L86 22 Q90 56 60 62 Q30 56 34 22 Z" fill="#FF6F9E" {O}/>''',

    '🌞': f'''{rays(60, 60, 42, 54, 12, '#FF9F2E')}
<circle cx="60" cy="60" r="32" fill="#FFD93D" {O}/>
<path d="M44 52 Q50 46 56 52 M64 52 Q70 46 76 52" {L3}/>
<path d="M48 68 Q60 80 72 68 Z" fill="#FFFFFF" {O3}/>{cheeks(42, 78, 64)}''',

    '🌍': f'''<circle cx="60" cy="60" r="46" fill="#4FA8F0" {O}/>
<path d="M30 30 Q44 22 52 32 Q46 40 54 46 Q60 56 48 62 Q40 70 44 84 Q32 78 26 62 Q24 44 30 30 Z M66 18 Q86 22 96 38 Q88 42 80 38 Q72 34 66 18 Z M70 54 Q86 50 98 58 Q100 76 88 92 Q78 96 74 86 Q80 74 70 66 Z" fill="#6CC24A" {O3}/>
<ellipse cx="40" cy="40" rx="8" ry="5" {SH} transform="rotate(-30 40 40)"/>''',

    '🪐': f'''<path d="M10 80 Q2 92 26 88 Q60 82 100 56 Q122 40 108 34" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>
<path d="M10 80 Q2 92 26 88 Q60 82 100 56 Q122 40 108 34" fill="none" stroke="#E8C38A" stroke-width="6" stroke-linecap="round"/>
<circle cx="60" cy="60" r="34" fill="#F0C77A" {O}/>
<path d="M30 50 Q60 44 88 46 M28 66 Q60 62 92 60" fill="none" stroke="#D9A050" stroke-width="4" stroke-linecap="round"/>
<path d="M14 82 Q40 80 64 72 M80 64 Q96 56 108 46" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>
<path d="M14 82 Q40 80 64 72 M80 64 Q96 56 108 46" fill="none" stroke="#E8C38A" stroke-width="6" stroke-linecap="round"/>''',

    '🌑': f'''<circle cx="60" cy="60" r="44" fill="#7A7699" {O}/>
<g fill="#5B5878"><circle cx="44" cy="44" r="9"/><circle cx="74" cy="70" r="12"/><circle cx="46" cy="80" r="6"/><circle cx="80" cy="38" r="5"/></g>''',

    '🌓': f'''<circle cx="60" cy="60" r="44" fill="#5B5878" {O}/>
<path d="M60 16 A44 44 0 0 1 60 104 Z" fill="#FFE98A"/>
<circle cx="60" cy="60" r="44" {L}/>''',

    '🌗': f'''<circle cx="60" cy="60" r="44" fill="#5B5878" {O}/>
<path d="M60 16 A44 44 0 0 0 60 104 Z" fill="#FFE98A"/>
<circle cx="60" cy="60" r="44" {L}/>''',

    '🌌': f'''<rect x="6" y="10" width="108" height="100" rx="14" fill="#2D2A4A" {O}/>
<path d="M14 92 Q60 70 106 26" fill="none" stroke="#8E7CF0" stroke-width="22" stroke-linecap="round" stroke-opacity="0.6"/>
<g fill="#FFFFFF"><circle cx="30" cy="30" r="2"/><circle cx="84" cy="80" r="2.5"/><circle cx="56" cy="56" r="3"/><circle cx="96" cy="50" r="1.8"/><circle cx="24" cy="74" r="1.8"/><circle cx="70" cy="30" r="2"/></g>
<polygon points="{star_points(40, 50, 8, 3.5)}" fill="#FFD93D"/>''',

    '🕳️': f'''<ellipse cx="60" cy="70" rx="48" ry="22" fill="#8A5A3B" {O}/>
<ellipse cx="60" cy="70" rx="38" ry="15" fill="#2D2A4A"/>''',

    'pic:mercury': planet('#A8A2A0', '<g fill="#8A847F"><circle cx="46" cy="66" r="8"/><circle cx="72" cy="44" r="6"/><circle cx="74" cy="78" r="9"/></g>'),
    'pic:venus': planet('#F2C46A', '<path d="M24 50 Q60 40 96 52 M20 70 Q60 60 100 72" fill="none" stroke="#E0A040" stroke-width="5" stroke-linecap="round"/>'),
    'pic:mars': planet('#D9572E', '<g fill="#B04020"><circle cx="44" cy="64" r="7"/><circle cx="76" cy="50" r="9"/><circle cx="68" cy="82" r="5"/></g>'),
    'pic:jupiter': planet('#E8B07A', '<path d="M20 44 H100 M18 58 H102 M20 76 H100" fill="none" stroke="#C07A4A" stroke-width="6"/><ellipse cx="74" cy="68" rx="10" ry="6" fill="#D7453A" stroke="#2D2A4A" stroke-width="2.5"/>'),
    'pic:uranus': planet('#8FE0E0', '<path d="M60 14 V106" fill="none" stroke="#6CC5C5" stroke-width="4"/>'),
    'pic:neptune': planet('#3B6CF6', '<path d="M22 54 Q60 46 98 54 M24 72 Q60 64 96 72" fill="none" stroke="#2A50C9" stroke-width="5" stroke-linecap="round"/><ellipse cx="44" cy="62" rx="7" ry="4" fill="#2A3FA0"/>'),
}
