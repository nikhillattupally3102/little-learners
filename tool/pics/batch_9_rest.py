# Batch 9: the last emoji — worksheet icons, praise faces, science extras and symbols.
SKIN9 = '#F6C7A0'


def face9(mouth, eye_art=None, extra=''):
    eye_art = eye_art if eye_art is not None else eyes(46, 74, 52, 4.5)
    return f'<circle cx="60" cy="60" r="46" fill="#FFD93D" {O}/>{eye_art}{mouth}{extra}'


def heart_eyes9():
    def h(cx):
        return (f'<path d="M{cx} 60 C{cx - 14} 50 {cx - 14} 38 {cx - 7} 38 C{cx - 3} 38 {cx} 41 {cx} 44 '
                f'C{cx} 41 {cx + 3} 38 {cx + 7} 38 C{cx + 14} 38 {cx + 14} 50 {cx} 60 Z" fill="#F2453F" {O3}/>')
    return h(44) + h(76)


def badge9(fill, inner):
    return f'<circle cx="60" cy="60" r="48" fill="{fill}" {O}/>{inner}'


def thick9(d, color, w=14):
    return (f'<path d="{d}" fill="none" stroke="{INKC}" stroke-width="{w + 8}" stroke-linecap="round" stroke-linejoin="round"/>'
            f'<path d="{d}" fill="none" stroke="{color}" stroke-width="{w}" stroke-linecap="round" stroke-linejoin="round"/>')


def tile9(fill, text, size=44, color='#FFFFFF'):
    return (f'<rect x="10" y="10" width="100" height="100" rx="22" fill="{fill}" {O}/>'
            f'<text x="60" y="{60 + size * .36:.0f}" text-anchor="middle" font-family="Arial Rounded MT Bold, Arial, sans-serif" '
            f'font-weight="bold" font-size="{size}" fill="{color}" stroke="{INKC}" stroke-width="2">{text}</text>')


def house9(wall, roof, x=0, y=0, s=1.0):
    return (f'<g transform="translate({x} {y}) scale({s})">'
            f'<rect x="22" y="56" width="76" height="52" fill="{wall}" {O}/>'
            f'<path d="M12 60 L60 18 L108 60 Z" fill="{roof}" {O}/>'
            f'<rect x="50" y="78" width="20" height="30" fill="#8A5A3B" {O3}/>'
            f'<rect x="30" y="66" width="14" height="14" fill="#CDEBFF" {O3}/><rect x="76" y="66" width="14" height="14" fill="#CDEBFF" {O3}/></g>')


CONFETTI9 = ''.join(
    f'<rect x="{x}" y="{y}" width="7" height="12" rx="2" fill="{c}" transform="rotate({r} {x} {y})"/>'
    for x, y, c, r in [(70, 14, '#F2453F', 20), (92, 26, '#4FA8F0', -30), (104, 50, '#7BD389', 40),
                       (84, 6, '#FFD93D', 70), (60, 30, '#B07CE8', -10), (100, 76, '#FF8FA3', 15)])

BATCH = {
    # ---- answers & feedback
    '✅': f'<rect x="12" y="12" width="96" height="96" rx="24" fill="#5CC56E" {O}/>' + thick9('M34 62 L52 80 L86 40', '#FFFFFF', 12),
    '❌': f'<rect x="12" y="12" width="96" height="96" rx="24" fill="#F2453F" {O}/>' + thick9('M38 38 L82 82 M82 38 L38 82', '#FFFFFF', 12),
    '🔊': f'''<path d="M18 46 H38 L62 24 V96 L38 74 H18 Z" fill="#4FA8F0" {O}/>
<path d="M76 46 Q84 60 76 74 M88 36 Q102 60 88 84" fill="none" stroke="{INKC}" stroke-width="7" stroke-linecap="round"/>''',
    '🎉': f'''<path d="M14 108 L40 34 L88 82 Z" fill="#FFD93D" {O}/>
<path d="M30 80 L60 94 M36 62 L74 82" fill="none" stroke="#F2453F" stroke-width="6"/><path d="M14 108 L40 34 L88 82 Z" {L}/>{CONFETTI9}''',
    '🥳': face9(f'<path d="M44 74 Q60 90 76 74 Z" fill="#7A2E3A" {O3}/>',
                extra=f'<path d="M38 24 L56 -2 L70 22 Z" fill="#B07CE8" {O3} transform="rotate(-20 56 20)"/>'
                      f'<path d="M78 78 L106 70 L100 84 Z" fill="#FF8FA3" {O3}/>{cheeks(38, 82, 66)}') ,
    '🤩': face9(f'<path d="M40 70 Q60 92 80 70 Z" fill="#7A2E3A" {O3}/>',
                eye_art=f'<polygon points="{star_points(44, 50, 12, 5)}" fill="#F2453F" {O3}/><polygon points="{star_points(76, 50, 12, 5)}" fill="#F2453F" {O3}/>'),
    '😁': face9(f'<path d="M36 66 Q60 96 84 66 Z" fill="#FFFFFF" {O3}/><path d="M42 72 H78 M50 68 V84 M60 68 V88 M70 68 V84" {L3}/>',
                eye_art=f'<path d="M38 52 Q46 42 54 52 M66 52 Q74 42 82 52" {L}/>'),
    '🏆': f'''<path d="M34 16 H86 V46 Q86 74 60 76 Q34 74 34 46 Z" fill="#FFC93C" {O}/>
<path d="M34 26 Q14 26 16 44 Q18 58 36 58 M86 26 Q106 26 104 44 Q102 58 84 58" {L}/>
<path d="M52 76 H68 V90 H52 Z" fill="#E8A92C" {O3}/><rect x="36" y="90" width="48" height="18" rx="4" fill="#8A5A3B" {O}/>
<polygon points="{star_points(60, 42, 12, 5)}" fill="#FFF3B0" {O3}/><path d="M42 24 V44" fill="none" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round" stroke-opacity=".6"/>''',
    '🎓': f'''<path d="M30 58 V82 Q60 98 90 82 V58" fill="#4A4475" {O}/>
<path d="M60 22 L112 46 L60 70 L8 46 Z" fill="#5B5494" {O}/><path d="M60 46 L96 58 V84" fill="none" stroke="#FFC93C" stroke-width="4"/>
<circle cx="96" cy="88" r="6" fill="#FFC93C" {O3}/>''',
    '💯': f'''<text x="60" y="72" text-anchor="middle" font-family="Arial Rounded MT Bold, Arial, sans-serif" font-weight="bold" font-size="52" fill="#F2453F" stroke="{INKC}" stroke-width="2.5" font-style="italic">100</text>
<path d="M16 86 H104 M24 98 H96" fill="none" stroke="#F2453F" stroke-width="6" stroke-linecap="round"/>''',

    # ---- maths and letter symbols
    '➕': badge9('#7BD389', thick9('M60 32 V88 M32 60 H88', '#FFFFFF', 12)),
    '➖': badge9('#4FA8F0', thick9('M32 60 H88', '#FFFFFF', 12)),
    '✖️': badge9('#FF8C42', thick9('M40 40 L80 80 M80 40 L40 80', '#FFFFFF', 12)),
    '➗': badge9('#B07CE8', thick9('M32 60 H88', '#FFFFFF', 10) + f'<circle cx="60" cy="38" r="8" fill="#FFFFFF" {O3}/><circle cx="60" cy="82" r="8" fill="#FFFFFF" {O3}/>'),
    '🟰': badge9('#FFC93C', thick9('M34 48 H86 M34 72 H86', '#FFFFFF', 10)),
    '🔢': tile9('#4FA8F0', '123', 40),
    '🔤': tile9('#FF8C42', 'abc', 40),
    '🔠': tile9('#F2453F', 'ABC', 38),
    '↔️': f'<path d="M8 60 L36 32 V48 H84 V32 L112 60 L84 88 V72 H36 V88 Z" fill="#4FA8F0" {O}/>',
    '↘️': f'<path d="M60 12 L100 52 H74 V108 H46 V52 H20 Z" fill="#4FA8F0" {O} transform="rotate(135 60 60)"/>',
    '⏪': f'<path d="M58 24 L14 60 L58 96 Z" fill="#4FA8F0" {O}/><path d="M104 24 L60 60 L104 96 Z" fill="#4FA8F0" {O}/>',
    '🔁': f'''<path d="M24 64 V52 Q24 34 44 34 H84" fill="none" stroke="{INKC}" stroke-width="18" stroke-linecap="round"/>
<path d="M24 64 V52 Q24 34 44 34 H84" fill="none" stroke="#7BD389" stroke-width="10" stroke-linecap="round"/>
<path d="M96 56 V68 Q96 86 76 86 H36" fill="none" stroke="{INKC}" stroke-width="18" stroke-linecap="round"/>
<path d="M96 56 V68 Q96 86 76 86 H36" fill="none" stroke="#7BD389" stroke-width="10" stroke-linecap="round"/>
<path d="M80 18 L104 34 L80 50 Z" fill="#7BD389" {O3}/><path d="M40 70 L16 86 L40 102 Z" fill="#7BD389" {O3}/>''',
    '🔗': f'''<rect x="10" y="40" width="60" height="38" rx="19" fill="none" stroke="{INKC}" stroke-width="16" transform="rotate(-35 40 59)"/>
<rect x="10" y="40" width="60" height="38" rx="19" fill="none" stroke="#9AA3B5" stroke-width="9" transform="rotate(-35 40 59)"/>
<rect x="50" y="42" width="60" height="38" rx="19" fill="none" stroke="{INKC}" stroke-width="16" transform="rotate(-35 80 61)"/>
<rect x="50" y="42" width="60" height="38" rx="19" fill="none" stroke="#C9D1DE" stroke-width="9" transform="rotate(-35 80 61)"/>''',
    '🏷️': f'''<path d="M14 30 Q14 16 28 16 H64 L108 60 L60 108 L16 64 Z" fill="#FFC93C" {O}/>
<circle cx="36" cy="38" r="8" fill="#FFFFFF" {O3}/><path d="M50 62 L66 46 M58 74 L80 52" {L3}/>''',
    '🕐': f'''<circle cx="60" cy="60" r="48" fill="#FFFFFF" {O}/><circle cx="60" cy="60" r="40" fill="none" stroke="#4FA8F0" stroke-width="4"/>
{''.join(f'<circle cx="{60 + 32 * __import__("math").sin(i * 0.5236):.1f}" cy="{60 - 32 * __import__("math").cos(i * 0.5236):.1f}" r="3" fill="{INKC}"/>' for i in range(12))}
<path d="M60 60 V30 M60 60 L74 52" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/><circle cx="60" cy="60" r="5" fill="#F2453F"/>''',
    '🪙': f'''<circle cx="60" cy="60" r="46" fill="#FFC93C" {O}/><circle cx="60" cy="60" r="34" fill="none" stroke="#E8A92C" stroke-width="5"/>
<polygon points="{star_points(60, 60, 18, 8)}" fill="#FFE27A" {O3}/><path d="M34 40 Q40 28 54 24" fill="none" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round" stroke-opacity=".7"/>''',

    # ---- people and talking
    '✌️': f'''<path d="M42 40 L32 8 Q30 2 37 2 Q42 2 44 8 L56 40 Z" fill="{SKIN9}" {O}/>
<path d="M62 40 L72 8 Q74 2 81 4 Q86 6 84 12 L76 42 Z" fill="{SKIN9}" {O}/>
<path d="M30 52 Q30 38 44 38 H80 Q94 38 94 54 V82 Q94 112 62 112 Q30 112 30 84 Z" fill="{SKIN9}" {O}/>
<path d="M44 56 Q60 50 78 58 M42 72 Q58 66 76 74" {L3}/>''',
    '👯': f'''<g><circle cx="38" cy="40" r="20" fill="{SKIN9}" {O}/><path d="M16 38 Q16 14 38 14 Q60 14 60 38 Q50 28 38 30 Q26 28 16 38 Z" fill="#5B3A22" {O3}/>
<path d="M18 112 L26 66 H50 L58 112 Z" fill="#FF8FA3" {O}/>{eyes(32, 44, 42, 3)}{smile(32, 44, 50, 4)}</g>
<g><circle cx="82" cy="40" r="20" fill="{SKIN9}" {O}/><path d="M60 38 Q60 14 82 14 Q104 14 104 38 Q94 28 82 30 Q70 28 60 38 Z" fill="#5B3A22" {O3}/>
<path d="M62 112 L70 66 H94 L102 112 Z" fill="#B07CE8" {O}/>{eyes(76, 88, 42, 3)}{smile(76, 88, 50, 4)}</g>''',
    '👪': f'''<circle cx="32" cy="34" r="16" fill="{SKIN9}" {O}/><path d="M12 108 Q12 56 32 56 Q52 56 52 108 Z" fill="#4FA8F0" {O}/>
<circle cx="88" cy="34" r="16" fill="{SKIN9}" {O}/><path d="M68 108 Q68 56 88 56 Q108 56 108 108 Z" fill="#FF8FA3" {O}/>
<path d="M72 30 Q72 14 88 14 Q104 14 104 34 Q96 22 88 24 Q80 22 72 30 Z" fill="#8A5A3B" {O3}/>
<circle cx="60" cy="66" r="12" fill="{SKIN9}" {O}/><path d="M46 108 Q46 80 60 80 Q74 80 74 108 Z" fill="#7BD389" {O}/>
{eyes(27, 37, 34, 2.5)}{eyes(83, 93, 34, 2.5)}{eyes(56, 64, 66, 2)}''',
    '🗣️': f'''<path d="M20 108 Q20 82 46 80 L40 64 Q16 60 18 36 Q22 10 50 12 Q78 14 78 42 Q78 60 66 66 V80 Q82 84 84 108 Z" fill="#4A4475" {O}/>
<path d="M90 36 Q98 46 90 56 M100 28 Q114 46 100 64" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>''',
    '💬': f'''<path d="M20 18 H100 Q110 18 110 28 V72 Q110 82 100 82 H52 L28 104 V82 H20 Q10 82 10 72 V28 Q10 18 20 18 Z" fill="#FFFFFF" {O}/>
<circle cx="38" cy="50" r="6" fill="#4FA8F0"/><circle cx="60" cy="50" r="6" fill="#4FA8F0"/><circle cx="82" cy="50" r="6" fill="#4FA8F0"/>''',

    # ---- science & everyday
    '🔭': f'''<path d="M18 62 L84 22 L96 42 L30 82 Z" fill="#4FA8F0" {O}/><path d="M80 18 L100 8 L112 30 L92 40 Z" fill="#B07CE8" {O}/>
<path d="M26 66 L34 80" {L3}/><path d="M56 60 L40 110 M56 60 L72 110 M56 60 V110" fill="none" stroke="#8A5A3B" stroke-width="5" stroke-linecap="round"/>
<circle cx="56" cy="58" r="6" fill="#9AA3B5" {O3}/>''',
    '🌦️': f'''{rays(40, 40, 24, 34, 8, "#FFB627")}<circle cx="40" cy="40" r="20" fill="#FFD93D" {O}/>
{blob([(58, 64, 20), (80, 58, 24), (98, 70, 16), (72, 76, 18)], "#FFFFFF")}
<path d="M62 94 L58 106 M78 94 L74 106 M94 94 L90 106" fill="none" stroke="#4FA8F0" stroke-width="6" stroke-linecap="round"/>''',
    '🍭': f'''<path d="M60 64 V114" fill="none" stroke="{INKC}" stroke-width="10" stroke-linecap="round"/><path d="M60 64 V114" fill="none" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round"/>
<circle cx="60" cy="40" r="32" fill="#FF8FA3" {O}/>
<path d="M60 40 Q60 30 68 32 Q78 36 74 48 Q68 60 54 56 Q40 50 42 36 Q46 18 64 16 Q86 16 90 38" fill="none" stroke="#FFFFFF" stroke-width="6" stroke-linecap="round"/>''',
    '🎮': f'''<path d="M30 36 H90 Q112 36 114 66 Q116 96 98 96 Q88 96 82 82 H38 Q32 96 22 96 Q4 96 6 66 Q8 36 30 36 Z" fill="#4A4475" {O}/>
<path d="M30 54 V74 M20 64 H40" fill="none" stroke="#FFFFFF" stroke-width="7" stroke-linecap="round"/>
<circle cx="84" cy="56" r="6" fill="#F2453F"/><circle cx="96" cy="68" r="6" fill="#4FA8F0"/><circle cx="72" cy="68" r="6" fill="#7BD389"/><circle cx="84" cy="78" r="6" fill="#FFD93D"/>''',
    '🥤': f'''<path d="M64 4 L70 30" fill="none" stroke="{INKC}" stroke-width="9" stroke-linecap="round"/><path d="M64 4 L70 30" fill="none" stroke="#F2453F" stroke-width="4" stroke-linecap="round"/>
<path d="M26 28 H94 L84 112 H36 Z" fill="#FF8C42" {O}/><rect x="22" y="22" width="76" height="12" rx="4" fill="#FFFFFF" {O}/>
<path d="M32 58 H88 L86 78 H34 Z" fill="#FFFFFF"/><path d="M26 28 H94 L84 112 H36 Z" {L}/>''',
    '🕶️': f'''<path d="M10 40 H110" {L}/><path d="M14 40 H54 V56 Q54 76 34 76 Q14 76 14 56 Z" fill="#2D2A4A" {O}/>
<path d="M66 40 H106 V56 Q106 76 86 76 Q66 76 66 56 Z" fill="#2D2A4A" {O}/><path d="M54 46 Q60 40 66 46" {L}/>
<path d="M22 48 L32 48 M74 48 L84 48" fill="none" stroke="#FFFFFF" stroke-width="4" stroke-linecap="round" stroke-opacity=".7"/>''',
    '🩳': f'''<path d="M22 18 H98 L108 98 H70 L60 54 L50 98 H12 Z" fill="#4FA8F0" {O}/><rect x="22" y="18" width="76" height="14" fill="#2F7FC1" {O3}/>
<path d="M60 32 V54" {L3}/>''',
    '🍂': f'''<path d="M20 60 Q30 20 70 18 Q72 56 40 74 Z" fill="#E8853A" {O} transform="rotate(-10 40 50)"/>
<path d="M58 96 Q60 50 104 40 Q110 84 66 100 Z" fill="#D9573A" {O}/>
<path d="M24 76 Q44 50 62 26 M54 108 Q74 76 98 48" {L3}/>''',
    '🏖️': f'''<rect x="6" y="6" width="108" height="108" rx="20" fill="#9ED8FF"/>
<path d="M6 76 Q60 62 114 76 V94 Q114 114 94 114 H26 Q6 114 6 94 Z" fill="#F3D3A8"/>
<circle cx="88" cy="28" r="12" fill="#FFD93D" {O3}/><path d="M40 98 L54 40" fill="none" stroke="{INKC}" stroke-width="4"/>
<path d="M20 50 Q50 20 86 44 Z" fill="#F2453F" {O}/><path d="M42 36 L48 48 M64 34 L60 46" {L3}/>
<rect x="6" y="6" width="108" height="108" rx="20" {L}/>''',
    '🗓️': f'''<rect x="12" y="20" width="96" height="88" rx="10" fill="#FFFFFF" {O}/><path d="M12 30 Q12 20 22 20 H98 Q108 20 108 30 V44 H12 Z" fill="#F2453F" {O}/>
<path d="M36 12 V28 M84 12 V28" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>
{''.join(f'<rect x="{x}" y="{y}" width="14" height="12" rx="3" fill="{"#4FA8F0" if (x, y) == (53, 74) else "#E3E7EF"}"/>' for y in (56, 74, 92) for x in (24, 53, 82))}''',
    '🌰': f'''<path d="M60 108 Q20 100 22 62 H98 Q100 100 60 108 Z" fill="#B5793F" {O}/>
<path d="M18 62 Q16 36 60 34 Q104 36 102 62 Z" fill="#7A5232" {O}/><path d="M60 34 V18" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>
<path d="M36 48 H84 M42 56 H78" fill="none" stroke="#5B3A22" stroke-width="3"/><path d="M38 72 Q42 92 56 98" fill="none" stroke="#FFFFFF" stroke-width="4" stroke-linecap="round" stroke-opacity=".5"/>''',
    '♨️': f'''<ellipse cx="60" cy="96" rx="44" ry="14" fill="#F2453F" {O}/>
<path d="M36 82 Q26 66 36 52 Q46 38 36 22 M60 82 Q50 66 60 52 Q70 38 60 22 M84 82 Q74 66 84 52 Q94 38 84 22" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>
<path d="M36 82 Q26 66 36 52 Q46 38 36 22 M60 82 Q50 66 60 52 Q70 38 60 22 M84 82 Q74 66 84 52 Q94 38 84 22" fill="none" stroke="#FF8FA3" stroke-width="6" stroke-linecap="round"/>''',
    '🏚️': f'''<rect x="22" y="56" width="76" height="52" fill="#B5A28A" {O} transform="rotate(4 60 82)"/>
<path d="M12 62 L58 18 L108 56 Z" fill="#7A6A5A" {O} transform="rotate(6 60 40)"/>
<path d="M30 70 L44 84 L38 94 M80 64 L72 78 L84 90" {L3}/><rect x="50" y="80" width="20" height="28" fill="#5B3A22" {O3}/>
<path d="M8 110 L22 104 L30 112 L44 104 L56 112 L70 104 L82 112 L96 104 L112 110" {L3}/>''',
    '♻️': ''.join(
        f'<g transform="rotate({r} 60 62)"><path d="M46 24 Q60 10 74 24 L86 44 L96 38 L92 64 L68 58 L78 52 L66 32 Q60 26 54 32 L44 48 L32 42 Z" fill="#5CC56E" {O}/></g>'
        for r in (0, 120, 240)),
    '🗄️': f'''<rect x="22" y="10" width="76" height="102" rx="6" fill="#9AA3B5" {O}/>
{''.join(f'<rect x="30" y="{y}" width="60" height="28" rx="4" fill="#C9D1DE" {O3}/><rect x="50" y="{y + 10}" width="20" height="7" rx="3" fill="{INKC}"/>' for y in (18, 50, 82) if y != 82)}
<rect x="30" y="82" width="60" height="22" rx="4" fill="#C9D1DE" {O3}/><rect x="50" y="89" width="20" height="7" rx="3" fill="{INKC}"/>''',
    '🔌': f'''<path d="M60 84 V96 Q60 112 80 112 H110" fill="none" stroke="{INKC}" stroke-width="8" stroke-linecap="round"/>
<path d="M44 14 V36 M76 14 V36" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/><path d="M44 14 V36 M76 14 V36" fill="none" stroke="#C9D1DE" stroke-width="6" stroke-linecap="round"/>
<path d="M28 34 H92 V54 Q92 84 60 86 Q28 84 28 54 Z" fill="#4A4475" {O}/><path d="M38 44 V60" fill="none" stroke="#FFFFFF" stroke-width="4" stroke-linecap="round" stroke-opacity=".5"/>''',
    '🎺': f'''<path d="M8 54 H70 L104 30 V90 L70 66 H8 Z" fill="#FFC93C" {O}/>
<ellipse cx="104" cy="60" rx="8" ry="30" fill="#E8A92C" {O}/><rect x="4" y="50" width="10" height="20" rx="3" fill="#E8A92C" {O3}/>
<path d="M28 54 V36 M40 54 V36 M52 54 V36" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>
<path d="M24 82 Q40 96 64 82" {L}/>''',
    '🐣': f'''<path d="M30 60 Q30 22 60 22 Q90 22 90 60 Z" fill="#FFD93D" {O}/>{eyes(50, 70, 44, 3.5)}<path d="M54 52 L66 52 L60 60 Z" fill="#FF8C42" {O3}/>
<path d="M22 60 L34 52 L44 62 L54 52 L66 62 L76 52 L86 62 L98 52 Q102 108 60 108 Q18 108 22 60 Z" fill="#FFF6E5" {O}/>''',
    '🏡': house9('#FFE27A', '#F2453F') + f'<path d="M4 112 H116" {L}/><circle cx="104" cy="94" r="12" fill="#7BD389" {O3}/><circle cx="14" cy="98" r="9" fill="#7BD389" {O3}/>',
    '🏘️': house9('#FFE27A', '#F2453F', -2, 30, .62) + house9('#CDEBFF', '#4FA8F0', 44, 30, .62) + house9('#FFD6E0', '#B07CE8', 22, 0, .62),
    '📊': f'''<rect x="10" y="10" width="100" height="100" rx="18" fill="#FFFFFF" {O}/>
<rect x="24" y="62" width="16" height="34" rx="3" fill="#4FA8F0" {O3}/><rect x="46" y="40" width="16" height="56" rx="3" fill="#7BD389" {O3}/>
<rect x="68" y="52" width="16" height="44" rx="3" fill="#FFC93C" {O3}/><rect x="90" y="26" width="0" height="0"/>
<path d="M20 96 H100" {L3}/><path d="M28 50 L54 30 L76 42 L98 20" fill="none" stroke="#F2453F" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>''',
    '😍': face9(f'<path d="M40 70 Q60 92 80 70 Z" fill="#7A2E3A" {O3}/>',
                eye_art=heart_eyes9(),
                extra=cheeks(36, 84, 66)),
    '🙂': face9(f'<path d="M42 70 Q60 84 78 70" {L}/>', extra=cheeks(36, 84, 66)),
    '😕': face9(f'<path d="M44 78 Q58 70 78 74" {L}/>'),
    '🎬': f'''<rect x="14" y="44" width="92" height="62" rx="8" fill="#4A4475" {O}/>
<path d="M12 26 L104 12 L108 34 L16 48 Z" fill="#FFFFFF" {O}/>
<path d="M30 24 L42 44 M54 20 L66 40 M78 17 L90 37" fill="none" stroke="{INKC}" stroke-width="8"/>
<path d="M26 64 H94 M26 80 H76" fill="none" stroke="#FFFFFF" stroke-width="5" stroke-linecap="round" stroke-opacity=".6"/>''',
    '🙋': f'''<path d="M84 58 L92 14 Q94 6 100 8 Q106 10 104 18 L98 60 Z" fill="{SKIN9}" {O}/>
<circle cx="54" cy="46" r="24" fill="{SKIN9}" {O}/>
<path d="M28 44 Q28 18 54 18 Q80 18 80 44 Q70 32 54 34 Q38 32 28 44 Z" fill="#5B3A22" {O3}/>
{eyes(46, 62, 48, 3)}{smile(46, 62, 56, 5)}
<path d="M16 116 Q16 76 54 74 Q78 74 90 60 L100 64 Q94 92 84 100 L90 116 Z" fill="#7BD389" {O}/>''',
}
ALIASES = {'✖': '✖️'}
