# Batch 11: landforms and geography icons.
SKY = '#BFE6FF'
WATER = '#4FA8F0'
GRASS = '#7BD389'


def frame(inner):
    """A rounded landscape card, like a little window onto the place."""
    return (f'<rect x="8" y="14" width="104" height="92" rx="18" fill="{SKY}"/>'
            f'{inner}'
            f'<rect x="8" y="14" width="104" height="92" rx="18" fill="none" {O}/>')


BATCH = {
    '🏝️': frame(f'''<path d="M10 82 Q60 70 110 82 V90 Q110 104 96 104 H24 Q10 104 10 90 Z" fill="{WATER}"/>
<ellipse cx="60" cy="82" rx="34" ry="9" fill="#F3D3A8" {O3}/>
<path d="M62 80 Q64 56 58 40" fill="none" stroke="#8A5A3B" stroke-width="6" stroke-linecap="round"/>
<path d="M58 40 Q42 30 30 42 Q44 38 58 44 Q50 26 64 22 Q60 34 62 42 Q78 30 90 40 Q74 38 60 44 Z" fill="{GRASS}" {O3}/>
<circle cx="92" cy="30" r="8" fill="#FFD93D" {O3}/>'''),
    '🌲': f'''<path d="M60 8 L86 44 H74 L94 72 H80 L102 100 H18 L40 72 H26 L46 44 H34 Z" fill="#3E9E5B" {O}/>
<rect x="52" y="100" width="16" height="14" fill="#8A5A3B" {O3}/>''',
    'pic:lake': frame(f'''<path d="M8 50 L30 32 L48 46 L66 26 L90 48 L112 36 V64 H8 Z" fill="#9AA3B5" {O3}/>
<path d="M8 62 H112 V90 Q112 104 98 104 H22 Q8 104 8 90 Z" fill="{GRASS}"/>
<ellipse cx="60" cy="80" rx="40" ry="14" fill="{WATER}" {O3}/>
<path d="M36 78 H52 M64 84 H84" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>'''),
    'pic:river': frame(f'''<path d="M8 52 H112 V90 Q112 104 98 104 H22 Q8 104 8 90 Z" fill="{GRASS}"/>
<path d="M54 52 Q40 66 58 76 Q78 88 60 104 H84 Q100 88 80 74 Q64 64 72 52 Z" fill="{WATER}" {O3}/>
<path d="M8 52 L34 30 L54 52 M58 52 L84 26 L112 52" fill="#9AA3B5" {O3}/>'''),
    'pic:waterfall': frame(f'''<path d="M8 30 H50 V104 H22 Q8 104 8 90 Z" fill="#9AA3B5" {O3}/>
<path d="M70 30 H112 V90 Q112 104 98 104 H70 Z" fill="#9AA3B5" {O3}/>
<rect x="48" y="24" width="24" height="70" fill="{WATER}" {O3}/>
<path d="M54 30 V86 M62 34 V90 M68 30 V82" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>
<ellipse cx="60" cy="96" rx="30" ry="8" fill="#FFFFFF" {O3}/>'''),
    'pic:cave': f'''<path d="M10 104 Q10 30 60 22 Q110 30 110 104 Z" fill="#9AA3B5" {O}/>
<path d="M36 104 Q36 58 60 54 Q84 58 84 104 Z" fill="#2D2A4A"/>
<path d="M44 60 L48 70 L52 60 M66 58 L70 68 L74 58" fill="#C9D1DE" {O3}/>
<path d="M20 70 Q30 64 34 74 M86 44 Q96 40 100 50" {L3}/>''',
    'pic:glacier': frame(f'''<path d="M8 76 H112 V90 Q112 104 98 104 H22 Q8 104 8 90 Z" fill="{WATER}"/>
<path d="M14 80 L30 40 L46 56 L62 28 L80 52 L92 38 L108 80 Z" fill="#E6F6FF" {O}/>
<path d="M30 40 L36 62 M62 28 L58 56 M92 38 L88 62" fill="none" stroke="#9ED8FF" stroke-width="4"/>'''),
    '🏛️': f'''<path d="M10 40 L60 12 L110 40 Z" fill="#E9E2D0" {O}/>
<rect x="14" y="40" width="92" height="10" fill="#E9E2D0" {O3}/>
{''.join(f'<rect x="{x}" y="50" width="10" height="44" fill="#FFFFFF" {O3}/>' for x in (22, 42, 62, 82))}
<rect x="10" y="94" width="100" height="14" rx="3" fill="#E9E2D0" {O}/>''',
}
