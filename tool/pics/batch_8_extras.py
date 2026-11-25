# Batch 8: the last pictures used inside questions.
BATCH = {
    '⛺': f'''<path d="M60 14 L110 100 H10 Z" fill="#FF8C42" {O}/>
<path d="M60 14 L44 100 H76 Z" fill="#FFC93C" {O3}/><path d="M60 50 L50 100 H70 Z" fill="#5B3A22"/>
<path d="M60 14 V4" {L3}/><path d="M60 4 L72 8 L60 12" fill="#F2453F" stroke="{INKC}" stroke-width="2"/>''',
    '🧊': f'''<path d="M20 40 L60 22 L100 40 V84 L60 102 L20 84 Z" fill="#CDEBFF" {O}/>
<path d="M20 40 L60 58 L100 40 M60 58 V102" {L3}/>
<path d="M32 50 L42 54 M70 54 L82 48 M30 64 L36 66" fill="none" stroke="#FFFFFF" stroke-width="4" stroke-linecap="round"/>''',
    '🧱': f'''<rect x="10" y="22" width="100" height="76" rx="4" fill="#D9573A" {O}/>
<path d="M10 47 H110 M10 72 H110 M40 22 V47 M80 22 V47 M24 47 V72 M60 47 V72 M96 47 V72 M40 72 V98 M80 72 V98" fill="none" stroke="#F3D3A8" stroke-width="4"/>
<rect x="10" y="22" width="100" height="76" rx="4" {L}/>''',
    '🩺': f'''<path d="M30 14 V44 Q30 66 50 66 Q70 66 70 44 V14" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>
<path d="M50 66 V84 Q50 104 72 104 Q92 104 92 84 V70" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>
<circle cx="92" cy="60" r="12" fill="#B8C4D6" {O}/><circle cx="92" cy="60" r="5" fill="#4FA8F0"/>
<circle cx="30" cy="12" r="5" fill="#9AA3B5" {O3}/><circle cx="70" cy="12" r="5" fill="#9AA3B5" {O3}/>''',
    '🏢': f'''<rect x="28" y="8" width="64" height="104" rx="4" fill="#9AB8D9" {O}/>
{''.join(f'<rect x="{x}" y="{y}" width="12" height="10" rx="2" fill="#FFF6C4"/>' for y in range(18, 90, 16) for x in (38, 54, 70))}
<rect x="50" y="92" width="20" height="20" fill="#4A4475" {O3}/>''',
    '🗼': f'''<path d="M60 4 L64 26 L76 74 L94 112 H76 Q60 86 44 112 H26 L44 74 L56 26 Z" fill="#E8853A" {O}/>
<path d="M50 50 H70 M44 74 H76 M56 26 H64" {L3}/>''',
    '🔍': f'''<path d="M70 70 L104 104" fill="none" stroke="{INKC}" stroke-width="16" stroke-linecap="round"/>
<path d="M70 70 L104 104" fill="none" stroke="#8A5A3B" stroke-width="9" stroke-linecap="round"/>
<circle cx="48" cy="48" r="32" fill="#CDEBFF" {O}/><circle cx="48" cy="48" r="32" fill="none" stroke="{INKC}" stroke-width="7"/>
<path d="M32 38 Q36 30 46 28" fill="none" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round"/>''',
    '🕵️': f'''<circle cx="60" cy="66" r="34" fill="{"#F6C7A0"}" {O}/>
<path d="M20 50 Q20 26 60 24 Q100 26 100 50 Z" fill="#8A6A4A" {O}/><path d="M10 50 H110" {L}/>
<path d="M28 44 H92" fill="none" stroke="#5B3A22" stroke-width="5"/>
{eyes(48, 72, 64, 4)}{smile(50, 70, 80, 6)}
<circle cx="88" cy="88" r="12" fill="#CDEBFF" {O3}/><path d="M80 96 L68 110" fill="none" stroke="#8A5A3B" stroke-width="5" stroke-linecap="round"/>''',
    '🧮': f'''<rect x="12" y="14" width="96" height="92" rx="8" fill="none" stroke="#8A5A3B" stroke-width="8"/>
<path d="M16 38 H104 M16 62 H104 M16 86 H104" fill="none" stroke="{INKC}" stroke-width="2.5"/>
{''.join(f'<circle cx="{x}" cy="{y}" r="7" fill="{c}" {O3}/>' for y, c, xs in [(38, '#F2453F', (26, 40, 54, 92)), (62, '#FFD93D', (26, 40, 78, 92)), (86, '#4FA8F0', (26, 64, 78, 92))] for x in xs)}''',
    '🎯': f'''<circle cx="60" cy="60" r="46" fill="#FFFFFF" {O}/><circle cx="60" cy="60" r="34" fill="#F2453F"/>
<circle cx="60" cy="60" r="22" fill="#FFFFFF"/><circle cx="60" cy="60" r="10" fill="#F2453F"/>
<path d="M60 60 L100 20" fill="none" stroke="{INKC}" stroke-width="5" stroke-linecap="round"/><path d="M96 14 L108 12 L106 24" fill="#4FA8F0" {O3}/>''',
    '🙃': f'<g transform="rotate(180 60 60)"><circle cx="60" cy="60" r="46" fill="#FFD93D" {O}/>{eyes(46, 74, 52, 4.5)}<path d="M40 70 Q60 88 80 70" {L}/></g>',
    '❓': f'''<path d="M36 40 Q36 14 60 14 Q86 14 86 38 Q86 54 66 62 V78" fill="none" stroke="{INKC}" stroke-width="18" stroke-linecap="round"/>
<path d="M36 40 Q36 14 60 14 Q86 14 86 38 Q86 54 66 62 V78" fill="none" stroke="#F2453F" stroke-width="10" stroke-linecap="round"/>
<circle cx="66" cy="100" r="9" fill="#F2453F" {O}/>''',
}
ALIASES = {'🔎': '🔍'}
