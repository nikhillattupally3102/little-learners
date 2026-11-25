# Batch 7: clothes, sports, music, people, faces, symbols, colours, arrows and flags.
SKIN = '#F6C7A0'


def face(mouth, eye_art=None, extra='', fill='#FFD93D'):
    eye_art = eye_art if eye_art is not None else eyes(46, 74, 52, 4.5)
    return f'<circle cx="60" cy="60" r="46" fill="{fill}" {O}/>{eye_art}{mouth}{extra}'


def dot(fill):
    return f'<circle cx="60" cy="60" r="42" fill="{fill}" {O}/><ellipse cx="44" cy="42" rx="11" ry="7" fill="#FFFFFF" fill-opacity="0.45" transform="rotate(-30 44 42)"/>'


def heart(fill):
    return (f'<path d="M60 104 C24 80 8 60 12 38 C16 18 44 12 60 34 C76 12 104 18 108 38 C112 60 96 80 60 104 Z" fill="{fill}" {O}/>'
            '<ellipse cx="34" cy="38" rx="9" ry="6" fill="#FFFFFF" fill-opacity="0.45" transform="rotate(-30 34 38)"/>')


def arrow(rot):
    return f'<path d="M60 12 L100 52 H74 V108 H46 V52 H20 Z" fill="#4FA8F0" {O} transform="rotate({rot} 60 60)"/>'


def flag(inner):
    return f'<path d="M12 22 V108" fill="none" stroke="#8A5A3B" stroke-width="5" stroke-linecap="round"/>{inner}<rect x="16" y="24" width="96" height="64" rx="3" fill="none" {O}/>'


def stripes_h(colors):
    h = 64 / len(colors)
    return ''.join(f'<rect x="16" y="{24 + i * h:.1f}" width="96" height="{h + 0.5:.1f}" fill="{c}"/>' for i, c in enumerate(colors))


def stripes_v(colors):
    w = 96 / len(colors)
    return ''.join(f'<rect x="{16 + i * w:.1f}" y="24" width="{w + 0.5:.1f}" height="64" fill="{c}"/>' for i, c in enumerate(colors))


def ball(fill, seams):
    return f'<circle cx="60" cy="60" r="44" fill="{fill}" {O}/><path d="{seams}" fill="none" stroke="{INKC}" stroke-width="3.5" stroke-linecap="round"/>'


def kid(hair, extra=''):
    return f'''<circle cx="60" cy="62" r="40" fill="{SKIN}" {O}/>{hair}
{eyes(46, 74, 62, 4)}{smile(50, 70, 76, 7)}{cheeks(38, 82, 74)}{extra}'''


BATCH = {
    # ---------------------------------------------------------------- clothes
    '🧦': f'''<path d="M44 10 H78 V66 L96 82 Q106 94 94 104 Q86 110 76 102 L46 78 Q40 72 44 64 Z" fill="#FFFFFF" {O}/>
<path d="M44 10 H78 V26 H44 Z" fill="#F2453F" {O3}/><path d="M44 40 H78 M44 52 H78" fill="none" stroke="#4FA8F0" stroke-width="5"/>''',
    '👟': f'''<path d="M10 82 Q10 60 26 58 L48 40 Q56 36 62 44 Q74 58 96 62 Q112 66 110 84 Z" fill="#4FA8F0" {O}/>
<path d="M8 82 H112 Q112 96 98 96 H18 Q8 96 8 82 Z" fill="#FFFFFF" {O}/>
<path d="M48 48 L56 54 M44 54 L52 60 M40 60 L48 66" {L3}/>''',
    '👖': f'''<path d="M30 12 H90 L96 108 H68 L60 52 L52 108 H24 Z" fill="#3B6CF6" {O}/>
<path d="M30 26 H90 M60 26 V48" {L3}/><path d="M38 34 Q44 40 50 34 M70 34 Q76 40 82 34" fill="none" stroke="#9AB8FF" stroke-width="2.5"/>''',
    '🧥': f'''<path d="M42 14 L60 26 L78 14 L102 26 L110 96 H90 V108 H30 V96 H10 L18 26 Z" fill="#E8892B" {O}/>
<path d="M60 26 V108 M42 14 L52 44 L60 26 M78 14 L68 44 L60 26" {L3}/>
<g {INK}><circle cx="66" cy="60" r="3"/><circle cx="66" cy="78" r="3"/></g>''',
    '🧤': f'''<path d="M34 108 V96 L28 60 Q26 50 34 50 Q40 50 40 58 L42 66 V30 Q42 22 50 22 Q56 22 56 30 V20 Q56 12 64 12 Q72 12 72 20 V28 Q74 22 80 22 Q88 24 86 34 L84 72 Q84 92 76 96 V108 Z" fill="#F2453F" {O}/>
<path d="M34 96 H76" {L3}/><path d="M34 102 H76" fill="none" stroke="#FFFFFF" stroke-width="3"/>''',
    '👕': f'''<path d="M42 14 Q60 26 78 14 L106 30 L96 52 L84 46 V108 H36 V46 L24 52 L14 30 Z" fill="#6CC24A" {O}/>
<path d="M42 14 Q60 34 78 14" {L3}/><polygon points="{star_points(60, 72, 12, 5.5)}" fill="#FFD93D" stroke="{INKC}" stroke-width="2.5" stroke-linejoin="round"/>''',
    '👗': f'''<path d="M46 12 L50 30 L40 50 L18 106 H102 L80 50 L70 30 L74 12 Q60 20 46 12 Z" fill="#FF6F9E" {O}/>
<path d="M40 50 H80" {L3}/><g fill="#FFFFFF"><circle cx="40" cy="80" r="3.5"/><circle cx="60" cy="72" r="3.5"/><circle cx="80" cy="84" r="3.5"/><circle cx="56" cy="94" r="3.5"/></g>''',
    '🧢': f'''<path d="M18 74 Q16 30 60 28 Q104 30 102 74 Z" fill="#4FA8F0" {O}/>
<path d="M60 28 V74 M36 34 Q44 52 40 74 M84 34 Q76 52 80 74" {L3}/>
<path d="M60 74 Q100 70 116 84 Q100 90 60 84 Z" fill="#2E7FC4" {O}/><circle cx="60" cy="26" r="5" fill="#2E7FC4" {O3}/>''',

    # ----------------------------------------------------------------- sports
    '🏀': ball('#FF8C42', 'M60 16 V104 M16 60 H104 M28 28 Q48 60 28 92 M92 28 Q72 60 92 92'),
    '⚾': ball('#FFFFFF', 'M34 24 Q48 60 34 96 M86 24 Q72 60 86 96') + '<path d="M38 34 l7 -2 M42 48 l7 -1 M42 62 l7 0 M42 76 l7 1 M38 88 l7 2 M82 34 l-7 -2 M78 48 l-7 -1 M78 62 l-7 0 M78 76 l-7 1 M82 88 l-7 2" fill="none" stroke="#F2453F" stroke-width="2.5" stroke-linecap="round"/>',
    '🎾': ball('#C8E64A', 'M22 36 Q60 52 98 36 M22 84 Q60 68 98 84'),
    '🏐': ball('#FFFFFF', 'M60 16 Q48 52 62 64 Q86 82 100 76 M62 64 Q36 70 22 88 M28 32 Q56 40 62 64'),
    '🏈': f'''<path d="M10 60 Q60 4 110 60 Q60 116 10 60 Z" fill="#9A5A2E" {O}/>
<path d="M40 60 H80 M48 54 V66 M56 54 V66 M64 54 V66 M72 54 V66" fill="none" stroke="#FFFFFF" stroke-width="3.5" stroke-linecap="round"/>
<path d="M24 46 Q30 40 36 40 M24 74 Q30 80 36 80" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>''',
    '🏓': f'''<path d="M70 70 L104 104" fill="none" stroke="{INKC}" stroke-width="14" stroke-linecap="round"/><path d="M70 70 L104 104" fill="none" stroke="#C98A4A" stroke-width="8" stroke-linecap="round"/>
<circle cx="52" cy="52" r="34" fill="#F2453F" {O}/><circle cx="96" cy="26" r="9" fill="#FFFFFF" {O3}/>''',
    '🏸': f'''<path d="M58 66 L44 108" {L}/>
<path d="M40 50 L76 50 L60 66 Z" fill="#FFFFFF" {O3}/>
<path d="M30 14 L40 50 M48 10 L52 50 M66 10 L64 50 M84 14 L76 50" fill="none" stroke="{INKC}" stroke-width="3"/>
<path d="M30 14 Q58 4 84 14" {L3}/><circle cx="60" cy="72" r="9" fill="#F2453F" {O3}/>''',
    '🏏': f'''<path d="M86 10 L74 34" fill="none" stroke="{INKC}" stroke-width="10" stroke-linecap="round"/>
<path d="M66 30 L82 38 L42 106 Q36 114 28 110 Q22 106 26 98 Z" fill="#E8C38A" {O}/>
<circle cx="88" cy="88" r="12" fill="#D7263D" {O3}/><path d="M80 82 Q88 88 96 94" fill="none" stroke="#FFFFFF" stroke-width="2"/>''',
    '🏒': f'''<path d="M84 8 L46 92 Q42 100 34 100 H14 Q8 100 10 92 Q12 86 20 86 H38 L74 6" fill="#C98A4A" {O}/>
<rect x="68" y="98" width="30" height="10" rx="5" {INK}/>''',
    '⛳': f'''<path d="M40 104 V14" {L}/><path d="M42 14 L90 30 L42 46 Z" fill="#F2453F" {O}/>
<ellipse cx="60" cy="104" rx="50" ry="10" fill="#6CC24A" {O3}/><ellipse cx="40" cy="104" rx="8" ry="3" {INK}/>
<circle cx="78" cy="96" r="6" fill="#FFFFFF" {O3}/>''',
    '🎳': f'''<path d="M76 16 Q66 16 66 30 Q66 40 70 46 Q60 66 64 92 Q66 108 82 108 Q98 108 100 92 Q104 66 94 46 Q98 40 98 30 Q98 16 88 16 Z" fill="#FFFFFF" {O}/>
<path d="M68 44 H96 M68 50 H96" fill="none" stroke="#F2453F" stroke-width="3.5"/>
<circle cx="40" cy="82" r="26" fill="#3B6CF6" {O}/><g {INK}><circle cx="34" cy="72" r="4"/><circle cx="46" cy="70" r="4"/><circle cx="40" cy="82" r="4"/></g>''',

    # ------------------------------------------------------------------ music
    '🥁': f'''<path d="M18 46 V86 Q60 104 102 86 V46" fill="#F2453F" {O}/>
<path d="M18 52 L36 90 L54 54 L72 92 L90 54 L102 80" fill="none" stroke="#FFD93D" stroke-width="3.5" stroke-linejoin="round"/>
<ellipse cx="60" cy="46" rx="42" ry="14" fill="#FFF6E5" {O}/>
<path d="M34 8 L56 40 M90 8 L66 40" fill="none" stroke="#C98A4A" stroke-width="5" stroke-linecap="round"/><circle cx="34" cy="8" r="5" fill="#C98A4A" {O3}/><circle cx="90" cy="8" r="5" fill="#C98A4A" {O3}/>''',
    '🎻': f'''<path d="M90 8 L74 40" fill="none" stroke="{INKC}" stroke-width="9" stroke-linecap="round"/>
<path d="M66 32 Q86 40 82 58 Q78 66 84 74 Q92 92 72 106 Q50 118 28 102 Q14 90 22 72 Q28 64 22 56 Q18 36 40 30 Q54 26 66 32 Z" fill="#B5621A" {O} transform="rotate(25 54 70)"/>
<path d="M36 82 L78 40" fill="none" stroke="{INKC}" stroke-width="2"/><path d="M44 64 Q40 68 44 72 M58 78 Q54 82 58 86" {L3}/>
<path d="M14 40 L104 104" fill="none" stroke="#8A5A3B" stroke-width="3.5" stroke-linecap="round"/>''',
    '🎸': f'''<path d="M70 50 L102 14" fill="none" stroke="{INKC}" stroke-width="11" stroke-linecap="round"/>
<path d="M70 50 L102 14" fill="none" stroke="#8A5A3B" stroke-width="5" stroke-linecap="round"/>
<path d="M60 50 Q74 54 70 70 Q86 82 74 98 Q60 114 38 106 Q18 98 18 80 Q20 66 34 62 Q38 46 60 50 Z" fill="#FF8C42" {O}/>
<circle cx="50" cy="78" r="8" {INK}/><path d="M36 92 L46 102" {L}/>''',
    '🎹': f'''<rect x="8" y="34" width="104" height="56" rx="6" fill="#FFFFFF" {O}/>
<path d="M21 34 V90 M34 34 V90 M47 34 V90 M60 34 V90 M73 34 V90 M86 34 V90 M99 34 V90" fill="none" stroke="{INKC}" stroke-width="2.5"/>
<g {INK}><rect x="17" y="34" width="8" height="32"/><rect x="30" y="34" width="8" height="32"/><rect x="56" y="34" width="8" height="32"/><rect x="69" y="34" width="8" height="32"/><rect x="82" y="34" width="8" height="32"/></g>''',
    '🎨': f'''<path d="M60 10 Q108 10 110 54 Q112 82 88 82 Q74 82 76 94 Q78 110 58 110 Q12 108 10 60 Q10 12 60 10 Z" fill="#F3D3A8" {O}/>
<circle cx="38" cy="38" r="8" fill="#F2453F" {O3}/><circle cx="64" cy="28" r="8" fill="#FFD93D" {O3}/><circle cx="88" cy="42" r="8" fill="#4FA8F0" {O3}/><circle cx="30" cy="66" r="8" fill="#6CC24A" {O3}/>
<circle cx="56" cy="80" r="9" fill="#FFF8EC" {O3}/>''',
    '🎵': f'''<path d="M44 92 V24 L96 12 V78" {L}/><path d="M44 36 L96 24" fill="none" stroke="{INKC}" stroke-width="8"/>
<ellipse cx="32" cy="92" rx="14" ry="11" {INK}/><ellipse cx="84" cy="80" rx="14" ry="11" {INK}/>''',

    # ----------------------------------------------------------------- people
    '👶': kid(f'<path d="M58 22 Q66 18 66 28 Q62 26 60 30" {L3}/>', f'<ellipse cx="60" cy="90" rx="8" ry="5" fill="#FF8FC0" {O3}/>'),
    '🧒': kid(f'<path d="M20 58 Q18 18 60 16 Q102 18 100 58 Q90 36 70 34 Q56 44 36 40 Q26 46 20 58 Z" fill="#8A5A3B" {O3}/>'),
    '👸': kid(f'<path d="M18 70 Q14 30 60 24 Q106 30 102 70 Q100 100 92 110 Q92 70 80 46 Q60 50 40 46 Q28 70 28 110 Q20 100 18 70 Z" fill="#FFD25A" {O3}/>', f'<path d="M38 26 L44 8 L52 20 L60 4 L68 20 L76 8 L82 26 Z" fill="#FFC93C" {O3}/>'),
    '👴': f'''<circle cx="60" cy="62" r="40" fill="{SKIN}" {O}/>
<path d="M22 56 Q22 34 32 30 Q30 46 36 50 M98 56 Q98 34 88 30 Q90 46 84 50" fill="#E3EAF4" {O3}/>
<circle cx="46" cy="60" r="9" fill="#FFFFFF" fill-opacity="0.6" {O3}/><circle cx="74" cy="60" r="9" fill="#FFFFFF" fill-opacity="0.6" {O3}/><path d="M55 60 H65" {L3}/>
{eyes(46, 74, 60, 3)}<path d="M40 78 Q60 72 80 78 Q76 100 60 102 Q44 100 40 78 Z" fill="#E3EAF4" {O3}/>''',
    '👮': kid('', f'<path d="M20 50 Q20 20 60 18 Q100 20 100 50 Z" fill="#3B4FA0" {O}/><path d="M16 50 H104" {L}/><polygon points="{star_points(60, 34, 9, 4)}" fill="#FFD93D" stroke="{INKC}" stroke-width="2"/>'),
    '🏃': f'''<circle cx="70" cy="20" r="12" fill="{SKIN}" {O}/>
<path d="M66 36 L56 66 M62 44 L82 56 L94 48 M62 44 L40 50 L30 40 M56 66 L76 84 L72 108 M56 66 L40 86 L18 84" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M66 36 L56 66 M62 44 L82 56 L94 48 M62 44 L40 50 L30 40 M56 66 L76 84 L72 108 M56 66 L40 86 L18 84" fill="none" stroke="#4FA8F0" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>''',
    '🚶': f'''<circle cx="60" cy="18" r="12" fill="{SKIN}" {O}/>
<path d="M60 34 V70 M60 44 L44 64 M60 44 L74 66 M60 70 L46 108 M60 70 L72 108" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M60 34 V70 M60 44 L44 64 M60 44 L74 66 M60 70 L46 108 M60 70 L72 108" fill="none" stroke="#6CC24A" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>''',
    '🦵': f'''<path d="M44 8 H76 L74 60 Q74 72 70 80 L72 96 Q74 104 96 104 Q108 104 108 112 H50 Q44 112 44 104 L48 80 Q42 70 44 58 Z" fill="{SKIN}" {O}/>
<path d="M50 64 Q60 70 70 64" fill="none" stroke="#D9967A" stroke-width="3" stroke-linecap="round"/>''',
    '💪': f'''<path d="M14 100 Q10 78 30 72 L54 66 Q50 54 48 40 Q46 22 64 22 Q80 24 86 40 Q92 26 104 34 Q112 44 104 64 Q96 88 74 96 Q44 108 14 100 Z" fill="{SKIN}" {O}/>
<path d="M64 52 Q78 46 88 56" fill="none" stroke="#D9967A" stroke-width="3" stroke-linecap="round"/>''',
    '👅': f'''<path d="M28 34 H92 V66 Q92 104 60 104 Q28 104 28 66 Z" fill="#F27C8E" {O}/>
<path d="M60 44 V80" fill="none" stroke="#D9566E" stroke-width="4" stroke-linecap="round"/>
<path d="M18 34 Q60 22 102 34" {L}/>''',
    '👍': f'''<path d="M30 54 H44 V104 H30 Z" fill="#4FA8F0" {O}/>
<path d="M44 56 L58 26 Q62 14 70 18 Q78 22 74 36 L70 50 H96 Q106 50 104 60 Q102 64 98 66 Q104 70 100 76 Q98 80 94 80 Q100 86 94 92 Q90 94 88 94 Q92 100 86 104 H44 Z" fill="{SKIN}" {O}/>''',
    '👎': f'''<g transform="rotate(180 60 60)"><path d="M30 54 H44 V104 H30 Z" fill="#4FA8F0" {O}/>
<path d="M44 56 L58 26 Q62 14 70 18 Q78 22 74 36 L70 50 H96 Q106 50 104 60 Q102 64 98 66 Q104 70 100 76 Q98 80 94 80 Q100 86 94 92 Q90 94 88 94 Q92 100 86 104 H44 Z" fill="{SKIN}" {O}/></g>''',
    '☝️': f'''<path d="M50 60 V18 Q50 8 60 8 Q70 8 70 18 V56 Q80 50 88 58 Q96 66 92 80 Q86 104 62 108 Q36 108 34 86 V64 Q34 56 42 56 Q50 56 50 64" fill="{SKIN}" {O}/>
<path d="M50 64 V76 M70 62 V74" fill="none" stroke="#D9967A" stroke-width="3" stroke-linecap="round"/>''',
    '🤏': f'''<path d="M30 96 Q14 80 24 62 L40 40 Q46 32 54 38 Q56 30 64 30 L92 32 Q100 34 98 42 Q96 48 88 48 L68 48 L72 60 L92 66 Q100 70 96 78 Q90 82 82 78 L60 74 Q58 92 44 100 Q36 104 30 96 Z" fill="{SKIN}" {O}/>''',
    '✍️': f'''<path d="M76 14 L96 34 L58 78 L38 82 L42 62 Z" fill="#FFD93D" {O3}/>
<path d="M22 110 Q14 86 30 72 Q42 64 54 72 Q66 80 62 96 Q56 112 40 112 Z" fill="{SKIN}" {O}/>
<path d="M10 110 H110" fill="none" stroke="#B8C4D6" stroke-width="4" stroke-linecap="round"/>''',
    '👏': f'''<path d="M30 104 Q14 88 22 66 L34 30 Q38 20 46 24 Q52 28 48 40 L44 54 L66 20 Q72 12 78 18 Q82 24 76 32 L62 54 L84 32 Q90 26 96 32 Q100 38 94 44 L72 66 L88 58 Q96 56 98 62 Q100 68 92 74 L64 96 Q48 108 30 104 Z" fill="{SKIN}" {O}/>
<path d="M98 14 L104 6 M108 26 L116 22 M88 8 L88 2" fill="none" stroke="#FFB020" stroke-width="4" stroke-linecap="round"/>''',

    # ------------------------------------------------------------------ faces
    '😀': face(f'<path d="M36 70 Q60 96 84 70 Z" fill="#FFFFFF" {O3}/>'),
    '😃': face(f'<path d="M36 68 Q60 98 84 68 Z" fill="#7A1F2E" {O3}/><path d="M44 72 Q60 80 76 72" fill="none" stroke="#FFFFFF" stroke-width="4"/>', eyes(46, 74, 48, 6)),
    '😢': face(f'<path d="M44 84 Q60 70 76 84" {L3}/>', extra=f'<path d="M74 62 Q66 76 70 84 Q78 88 80 80 Q80 72 74 62 Z" fill="#4FA8F0" {O3}/>'),
    '😴': face(f'<ellipse cx="60" cy="80" rx="8" ry="6" fill="#7A1F2E" {O3}/>', f'<path d="M38 54 Q46 60 54 54 M66 54 Q74 60 82 54" {L3}/>', '<text x="84" y="34" font-size="22" font-weight="bold" fill="#4FA8F0">z</text><text x="96" y="20" font-size="16" font-weight="bold" fill="#4FA8F0">z</text>'),
    '🤗': face(f'<path d="M44 66 Q60 80 76 66" {L3}/>', f'<path d="M38 50 Q46 44 54 50 M66 50 Q74 44 82 50" {L3}/>', f'<path d="M10 92 Q24 74 40 84 L34 104 Q20 108 10 92 Z M110 92 Q96 74 80 84 L86 104 Q100 108 110 92 Z" fill="#FFC93C" {O3}/>'),
    '🤫': face(f'<path d="M48 76 Q60 70 72 76" {L3}/>', extra=f'<rect x="54" y="62" width="12" height="40" rx="6" fill="#FFC93C" {O3}/>'),
    '🤔': face(f'<path d="M50 80 Q60 76 72 82" {L3}/>', f'<path d="M38 42 L54 38 M66 40 L82 46" {L3}/>' + eyes(46, 74, 54, 4), f'<path d="M30 96 Q36 82 48 88 Q56 92 52 100 Q44 110 30 96 Z" fill="#FFC93C" {O3}/>'),
    '🙈': f'''<circle cx="22" cy="58" r="13" fill="#A0704D" {O}/><circle cx="98" cy="58" r="13" fill="#A0704D" {O}/>
<circle cx="60" cy="58" r="37" fill="#A0704D" {O}/><path d="M34 64 Q34 92 60 94 Q86 92 86 64 Z" fill="#F3D3A8" {O3}/>
<path d="M26 50 Q24 30 46 34 Q56 38 54 54 Q50 64 36 62 Q28 60 26 50 Z M94 50 Q96 30 74 34 Q64 38 66 54 Q70 64 84 62 Q92 60 94 50 Z" fill="#C98A5A" {O3}/>
{smile(50, 70, 80, 6)}''',
    '🎃': f'''<path d="M60 26 Q58 14 66 8" fill="none" stroke="#4CAF50" stroke-width="6" stroke-linecap="round"/>
<path d="M60 28 Q96 22 106 60 Q110 100 60 104 Q10 100 14 60 Q24 22 60 28 Z" fill="#FF8C42" {O}/>
<path d="M60 30 V102 M40 32 Q30 66 42 100 M80 32 Q90 66 78 100" fill="none" stroke="#D9661F" stroke-width="3"/>
<path d="M36 56 L46 46 L56 56 Z M64 56 L74 46 L84 56 Z M36 74 Q60 92 84 74 L76 80 L68 74 L60 82 L52 74 L44 80 Z" {INK}/>''',
    '🤖': f'''<path d="M60 22 V10" {L}/><circle cx="60" cy="8" r="5" fill="#F2453F" {O3}/>
<rect x="20" y="22" width="80" height="68" rx="14" fill="#B8C4D6" {O}/>
<rect x="10" y="44" width="10" height="24" rx="4" fill="#9AA3B5" {O3}/><rect x="100" y="44" width="10" height="24" rx="4" fill="#9AA3B5" {O3}/>
<circle cx="44" cy="50" r="10" fill="#FFFFFF" {O3}/><circle cx="76" cy="50" r="10" fill="#FFFFFF" {O3}/><circle cx="44" cy="50" r="4.5" fill="#4FA8F0"/><circle cx="76" cy="50" r="4.5" fill="#4FA8F0"/>
<rect x="38" y="70" width="44" height="10" rx="4" fill="#FFFFFF" {O3}/><path d="M49 70 V80 M60 70 V80 M71 70 V80" fill="none" stroke="{INKC}" stroke-width="2"/>''',
    '💭': f'''{blob([(40, 50, 20), (64, 40, 24), (86, 52, 18), (62, 62, 18)], '#FFFFFF')}
<circle cx="30" cy="88" r="8" fill="#FFFFFF" {O3}/><circle cx="18" cy="104" r="5" fill="#FFFFFF" {O3}/>''',
    '📢': f'''<path d="M18 48 H36 L84 22 V98 L36 72 H18 Z" fill="#F2453F" {O}/>
<path d="M30 72 L36 104 H48 L44 72" fill="#B8C4D6" {O3}/>
<path d="M94 46 Q102 60 94 74 M102 36 Q116 60 102 84" {L3}/>''',

    # ---------------------------------------------------------------- symbols
    '🃏': f'''<rect x="26" y="10" width="68" height="100" rx="10" fill="#FFFFFF" {O}/>
<path d="M44 70 Q38 40 60 34 Q82 40 76 70 Z" fill="#8E5CF7" {O3}/><circle cx="60" cy="52" r="10" fill="{SKIN}" {O3}/>
<path d="M44 70 L36 52 M76 70 L84 52" {L3}/><circle cx="36" cy="50" r="4" fill="#FFD93D" {O3}/><circle cx="84" cy="50" r="4" fill="#FFD93D" {O3}/>
<text x="34" y="30" font-size="14" font-weight="bold" fill="#F2453F">J</text>''',
    '💰': f'''<path d="M42 30 Q34 14 46 12 Q60 20 74 12 Q86 14 78 30 Z" fill="#C98A4A" {O3}/>
<path d="M42 30 Q12 52 16 80 Q20 108 60 108 Q100 108 104 80 Q108 52 78 30 Z" fill="#D9A066" {O}/>
<path d="M42 32 H78" fill="none" stroke="#8A5A3B" stroke-width="5"/>
<text x="46" y="88" font-size="36" font-weight="bold" fill="#FFD93D" stroke="{INKC}" stroke-width="1.5">$</text>''',
    '🔟': f'''<rect x="12" y="12" width="96" height="96" rx="18" fill="#4FA8F0" {O}/>
<text x="24" y="80" font-size="52" font-weight="bold" fill="#FFFFFF">10</text>''',
    '🧩': f'''<path d="M20 30 H46 Q42 16 56 14 Q70 16 66 30 H92 V56 Q106 52 106 66 Q106 80 92 76 V102 H20 V76 Q34 80 34 66 Q34 52 20 56 Z" fill="#8E5CF7" {O}/>''',
    '📥': f'''<path d="M14 62 H38 L48 78 H72 L82 62 H106 V100 Q106 108 98 108 H22 Q14 108 14 100 Z" fill="#B8C4D6" {O}/>
<path d="M60 10 V56 M42 40 L60 58 L78 40" fill="none" stroke="#4FA8F0" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>''',
    '📤': f'''<path d="M14 62 H38 L48 78 H72 L82 62 H106 V100 Q106 108 98 108 H22 Q14 108 14 100 Z" fill="#B8C4D6" {O}/>
<path d="M60 58 V12 M42 28 L60 10 L78 28" fill="none" stroke="#6CC24A" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>''',
    '⚛️': f'''<ellipse cx="60" cy="60" rx="48" ry="18" fill="none" stroke="#4FA8F0" stroke-width="5"/>
<ellipse cx="60" cy="60" rx="48" ry="18" fill="none" stroke="#8E5CF7" stroke-width="5" transform="rotate(60 60 60)"/>
<ellipse cx="60" cy="60" rx="48" ry="18" fill="none" stroke="#F2453F" stroke-width="5" transform="rotate(-60 60 60)"/>
<circle cx="60" cy="60" r="9" fill="#FFD93D" {O3}/>''',
    '⚙️': f'''<path d="M52 10 H68 L70 24 L82 30 L94 22 L104 34 L96 46 L100 58 L112 60 V76 L100 78 L94 90 L102 102 L90 112 L80 104 L68 108 L66 118 H52 L50 108 L38 104 L28 112 L16 102 L24 90 L18 78 L8 76 V60 L20 58 L24 46 L16 34 L26 22 L38 30 L50 24 Z" fill="#9AA3B5" {O} transform="translate(0 -4) scale(1 0.97)"/>
<circle cx="60" cy="62" r="16" fill="#FFFFFF" {O}/>''',
    '🔀': f'''<path d="M10 34 H36 Q52 34 60 60 Q68 86 84 86 H98 M10 86 H36 Q52 86 60 60 Q68 34 84 34 H98" fill="none" stroke="#4FA8F0" stroke-width="9" stroke-linecap="round"/>
<path d="M92 22 L108 34 L92 46 Z M92 74 L108 86 L92 98 Z" fill="#4FA8F0" {O3}/>''',
    '📝': f'''<path d="M20 10 H76 L92 26 V110 H20 Z" fill="#FFFFFF" {O}/>
<path d="M32 40 H74 M32 54 H74 M32 68 H60" fill="none" stroke="#B8C4D6" stroke-width="4" stroke-linecap="round"/>
<path d="M100 40 L112 52 L74 92 L60 96 L64 82 Z" fill="#FFD93D" {O3}/>''',

    # ------------------------------------------------------- colours & arrows
    '🔴': dot('#F2453F'), '🟠': dot('#FF8C42'), '🟡': dot('#FFD93D'), '🟢': dot('#4CAF50'),
    '🔵': dot('#3B8BEB'), '🟣': dot('#8E5CF7'), '🟤': dot('#8A5A3B'), '⚫': dot('#2D2A4A'), '⚪': dot('#FFFFFF'),
    '🟦': f'<rect x="16" y="16" width="88" height="88" rx="12" fill="#3B8BEB" {O}/>',
    '🔺': f'<path d="M60 14 L106 98 H14 Z" fill="#F2453F" {O}/>',
    '🔷': f'<path d="M60 8 L104 60 L60 112 L16 60 Z" fill="#3B8BEB" {O}/>',
    '🔲': f'<rect x="14" y="14" width="92" height="92" rx="8" fill="#2D2A4A" {O}/><rect x="30" y="30" width="60" height="60" rx="4" fill="#FFFFFF"/>',
    '❤️': heart('#F2453F'), '💙': heart('#3B8BEB'), '💛': heart('#FFD93D'), '💚': heart('#4CAF50'), '💜': heart('#8E5CF7'), '🧡': heart('#FF8C42'),
    '⬆️': arrow(0), '➡️': arrow(90), '⬇️': arrow(180), '⬅️': arrow(270),

    # ------------------------------------------------------------------ flags
    '🇮🇳': flag(stripes_h(['#FF9933', '#FFFFFF', '#138808']) + f'<circle cx="64" cy="56" r="8" fill="none" stroke="#000080" stroke-width="2.5"/>'),
    '🇺🇸': flag(stripes_h(['#D7263D', '#FFFFFF', '#D7263D', '#FFFFFF', '#D7263D', '#FFFFFF', '#D7263D']) + '<rect x="16" y="24" width="42" height="36" fill="#3B4FA0"/>'
                + ''.join(f'<circle cx="{24 + c * 9}" cy="{31 + r * 8}" r="2" fill="#FFFFFF"/>' for r in range(4) for c in range(4))),
    '🇬🇧': flag('<rect x="16" y="24" width="96" height="64" fill="#2A3F8F"/><path d="M16 24 L112 88 M112 24 L16 88" stroke="#FFFFFF" stroke-width="12"/>'
                '<path d="M16 24 L112 88 M112 24 L16 88" stroke="#D7263D" stroke-width="4"/><path d="M64 24 V88 M16 56 H112" stroke="#FFFFFF" stroke-width="18"/>'
                '<path d="M64 24 V88 M16 56 H112" stroke="#D7263D" stroke-width="10"/>'),
    '🇯🇵': flag('<rect x="16" y="24" width="96" height="64" fill="#FFFFFF"/><circle cx="64" cy="56" r="18" fill="#D7263D"/>'),
    '🇨🇳': flag('<rect x="16" y="24" width="96" height="64" fill="#DE2910"/>' + f'<polygon points="{star_points(34, 42, 10, 4)}" fill="#FFDE00"/>'
                + ''.join(f'<polygon points="{star_points(x, y, 3.5, 1.5)}" fill="#FFDE00"/>' for x, y in [(50, 30), (56, 38), (56, 48), (50, 56)])),
    '🇧🇷': flag('<rect x="16" y="24" width="96" height="64" fill="#169B3E"/><path d="M64 30 L104 56 L64 82 L24 56 Z" fill="#FEDD00"/><circle cx="64" cy="56" r="15" fill="#012169"/>'
                '<path d="M50 52 Q64 48 78 58" fill="none" stroke="#FFFFFF" stroke-width="3"/>'),
    '🇪🇬': flag(stripes_h(['#CE1126', '#FFFFFF', '#000000']) + '<path d="M60 50 L64 46 L68 50 L66 62 H62 Z" fill="#C09300"/>'),
    '🇦🇺': flag('<rect x="16" y="24" width="96" height="64" fill="#012169"/><path d="M16 24 L64 56 M64 24 L16 56" stroke="#FFFFFF" stroke-width="6"/><path d="M40 24 V56 M16 40 H64" stroke="#FFFFFF" stroke-width="9"/>'
                '<path d="M40 24 V56 M16 40 H64" stroke="#E4002B" stroke-width="5"/>' + ''.join(f'<polygon points="{star_points(x, y, r, r * 0.45)}" fill="#FFFFFF"/>' for x, y, r in [(40, 74, 7), (88, 38, 4), (98, 52, 4), (86, 66, 4), (78, 50, 3)])),
    '🇨🇦': flag(stripes_v(['#D7263D', '#FFFFFF', '#FFFFFF', '#D7263D']) + '<path d="M64 36 L68 46 L74 42 L72 54 L82 52 L76 60 L80 64 L66 66 L66 76 H62 L62 66 L48 64 L52 60 L46 52 L56 54 L54 42 L60 46 Z" fill="#D7263D"/>'),
    '🇲🇽': flag(stripes_v(['#006847', '#FFFFFF', '#CE1126']) + '<circle cx="64" cy="56" r="8" fill="#8A5A3B"/><path d="M56 64 Q64 70 72 64" fill="none" stroke="#006847" stroke-width="2.5"/>'),
    '🇫🇷': flag(stripes_v(['#0055A4', '#FFFFFF', '#EF4135'])),
    '🇰🇪': flag(stripes_h(['#000000', '#FFFFFF', '#BB0000', '#BB0000', '#FFFFFF', '#006600']) + '<ellipse cx="64" cy="56" rx="9" ry="18" fill="#BB0000" stroke="#000000" stroke-width="2.5"/><path d="M64 40 V72" stroke="#FFFFFF" stroke-width="2"/>'),
}
ALIASES = {'🖐️': '✋'}
