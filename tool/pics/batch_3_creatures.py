# Batch 3: more animals and creature-related things.
BATCH = {
    '🦄': f'''<path d="M64 28 L84 4 L76 34 Z" fill="#FFD93D" {O3}/>
<path d="M68 22 L78 14 M70 28 L80 20" fill="none" stroke="#E8B92A" stroke-width="2.5"/>
<path d="M44 34 L42 16 L56 28 Z" fill="#FFFFFF" {O3}/>
<path d="M36 30 Q62 18 80 36 Q94 56 92 74 Q90 96 70 104 Q50 108 40 92 Q30 76 34 56 Q28 44 36 30 Z" fill="#FFFFFF" {O}/>
<path d="M36 30 Q20 40 22 60 Q14 72 24 84 Q28 64 34 56 Q30 44 36 30 Z" fill="#B48CF0" {O3}/>
<path d="M30 40 Q22 54 26 62" fill="none" stroke="#FF8FC0" stroke-width="4" stroke-linecap="round"/>
<ellipse cx="74" cy="92" rx="16" ry="11" fill="#F9D6E4" {O3}/>
<circle cx="70" cy="92" r="2.2" {INK}/><circle cx="80" cy="90" r="2.2" {INK}/>
<circle cx="62" cy="56" r="4" {INK}/><circle cx="56" cy="70" r="4" {CK}/>''',

    '🦖': f'''<path d="M34 78 Q10 84 4 104 Q20 96 40 92 Z" fill="#6CC24A" {O}/>
<path d="M50 96 V112 H60 M72 94 V112 H82" fill="none" stroke="{INKC}" stroke-width="11" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M50 96 V112 H60 M72 94 V112 H82" fill="none" stroke="#6CC24A" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
<ellipse cx="62" cy="80" rx="28" ry="22" fill="#6CC24A" {O}/>
<path d="M70 66 Q66 46 70 30 Q76 12 98 14 Q116 18 114 34 Q112 44 96 44 Q86 46 84 56 Z" fill="#6CC24A" {O}/>
<path d="M96 40 L99 46 L102 40 L105 46 L108 40" fill="#FFFFFF" stroke="{INKC}" stroke-width="2" stroke-linejoin="round"/>
<path d="M80 70 L90 74 M80 78 L88 84" {L3}/>
<circle cx="94" cy="26" r="4" {INK}/>
<path d="M58 58 L62 50 L66 58 M44 64 L48 56 L52 64" fill="#4CAF50" stroke="{INKC}" stroke-width="2" stroke-linejoin="round"/>''',

    '🦕': f'''<path d="M28 80 Q8 84 4 98 Q20 94 34 92 Z" fill="#4FA8F0" {O}/>
<path d="M40 92 V110 M54 94 V110 M72 94 V110 M86 92 V110" fill="none" stroke="{INKC}" stroke-width="11" stroke-linecap="round"/>
<path d="M40 92 V110 M54 94 V110 M72 94 V110 M86 92 V110" fill="none" stroke="#4FA8F0" stroke-width="5" stroke-linecap="round"/>
<ellipse cx="62" cy="80" rx="34" ry="20" fill="#4FA8F0" {O}/>
<path d="M84 70 Q90 40 92 24" fill="none" stroke="{INKC}" stroke-width="20" stroke-linecap="round"/>
<path d="M84 70 Q90 40 92 24" fill="none" stroke="#4FA8F0" stroke-width="13" stroke-linecap="round"/>
<ellipse cx="98" cy="20" rx="14" ry="10" fill="#4FA8F0" {O}/>
<circle cx="102" cy="17" r="3.2" {INK}/>{smile(100, 110, 23, 3)}
<circle cx="50" cy="72" r="4" fill="#2E7FC4"/><circle cx="64" cy="68" r="5" fill="#2E7FC4"/><circle cx="74" cy="80" r="3.5" fill="#2E7FC4"/>''',

    '🦍': f'''<circle cx="22" cy="58" r="11" fill="#4A4475" {O}/><circle cx="98" cy="58" r="11" fill="#4A4475" {O}/>
<path d="M24 56 Q22 22 60 18 Q98 22 96 56 Q100 92 60 102 Q20 92 24 56 Z" fill="#4A4475" {O}/>
<path d="M36 50 Q60 36 84 50 Q90 70 80 88 Q60 98 40 88 Q30 70 36 50 Z" fill="#9C93B8" {O3}/>
<path d="M40 48 Q60 42 80 48" {L}/>
{eyes(48, 72, 56, 4)}
<ellipse cx="54" cy="70" rx="3" ry="2.5" {INK}/><ellipse cx="66" cy="70" rx="3" ry="2.5" {INK}/>
<path d="M48 82 Q60 88 72 82" {L3}/>''',

    '🦛': f'''<circle cx="34" cy="30" r="8" fill="#9C8FB8" {O}/><circle cx="86" cy="30" r="8" fill="#9C8FB8" {O}/>
<ellipse cx="60" cy="48" rx="32" ry="24" fill="#9C8FB8" {O}/>
<ellipse cx="60" cy="80" rx="44" ry="28" fill="#B3A8CC" {O}/>
<ellipse cx="44" cy="74" rx="5" ry="7" fill="#7A6E99"/><ellipse cx="76" cy="74" rx="5" ry="7" fill="#7A6E99"/>
<path d="M30 92 Q60 104 90 92" {L3}/>
<rect x="44" y="94" width="8" height="8" rx="2" fill="#FFFFFF" stroke="{INKC}" stroke-width="2"/><rect x="68" y="94" width="8" height="8" rx="2" fill="#FFFFFF" stroke="{INKC}" stroke-width="2"/>
{eyes(46, 74, 44, 4)}{cheeks(22, 98, 86, 4.5)}''',

    '🦐': f'''<path d="M30 30 Q18 14 8 16 M34 28 Q30 10 20 6" {L3}/>
<path d="M30 32 Q66 18 94 40 Q112 60 100 86 Q90 100 76 96 L84 108 L64 102 L70 92 Q86 86 86 70 Q84 50 60 46 Q40 44 30 32 Z" fill="#FF8C6B" {O}/>
<path d="M62 46 Q60 60 70 66 M80 52 Q74 64 84 74 M88 66 Q80 76 86 86" fill="none" stroke="#D9573A" stroke-width="3" stroke-linecap="round"/>
<path d="M50 50 L44 64 M60 52 L56 68 M72 58 L70 74" {L3}/>
<circle cx="36" cy="32" r="3.4" {INK}/>''',

    '🦑': f'''<path d="M42 66 Q34 92 22 104 M52 70 Q50 96 44 112 M60 70 V114 M68 70 Q70 96 76 112 M78 66 Q86 92 98 104" fill="none" stroke="{INKC}" stroke-width="10" stroke-linecap="round"/>
<path d="M42 66 Q34 92 22 104 M52 70 Q50 96 44 112 M60 70 V114 M68 70 Q70 96 76 112 M78 66 Q86 92 98 104" fill="none" stroke="#F2A0B6" stroke-width="4.5" stroke-linecap="round"/>
<path d="M60 6 Q34 30 36 52 Q36 72 60 74 Q84 72 84 52 Q86 30 60 6 Z" fill="#F2A0B6" {O}/>
<path d="M60 6 L40 24 L36 36 Q48 30 60 32 Q72 30 84 36 L80 24 Z" fill="#E5809C" {O3}/>
<circle cx="50" cy="54" r="6" fill="#FFFFFF" {O3}/><circle cx="70" cy="54" r="6" fill="#FFFFFF" {O3}/>
<circle cx="51" cy="55" r="3" {INK}/><circle cx="71" cy="55" r="3" {INK}/>''',

    '🦞': f'''<path d="M44 48 L26 26 M76 48 L94 26" {L}/>
<path d="M26 26 Q8 22 12 8 Q24 2 32 14 Q30 22 26 26 Z M94 26 Q112 22 108 8 Q96 2 88 14 Q90 22 94 26 Z" fill="#D7263D" {O3}/>
<path d="M42 64 L24 70 M42 74 L24 82 M78 64 L96 70 M78 74 L96 82" {L3}/>
<path d="M60 92 L44 112 H76 Z" fill="#D7263D" {O3}/>
<ellipse cx="60" cy="68" rx="20" ry="28" fill="#D7263D" {O}/>
<path d="M42 72 Q60 78 78 72 M44 84 Q60 90 76 84" fill="none" stroke="#A81B2E" stroke-width="3" stroke-linecap="round"/>
<path d="M52 42 Q46 28 40 24 M68 42 Q74 28 80 24" {L3}/>
<circle cx="52" cy="50" r="3.4" fill="#FFFFFF"/><circle cx="68" cy="50" r="3.4" fill="#FFFFFF"/><circle cx="52" cy="51" r="1.8" {INK}/><circle cx="68" cy="51" r="1.8" {INK}/>''',

    '🦟': f'''<path d="M50 64 L30 92 M58 66 L52 100 M66 66 L76 98 M54 60 L26 70 M68 60 L96 74" {L3}/>
<ellipse cx="38" cy="38" rx="20" ry="11" fill="#DFF3FF" {O3} transform="rotate(-30 38 38)"/>
<ellipse cx="82" cy="38" rx="20" ry="11" fill="#DFF3FF" {O3} transform="rotate(30 82 38)"/>
<ellipse cx="74" cy="66" rx="24" ry="9" fill="#7A6E99" {O} transform="rotate(20 74 66)"/>
<circle cx="50" cy="56" r="11" fill="#7A6E99" {O}/>
<path d="M42 60 L20 74" fill="none" stroke="{INKC}" stroke-width="3" stroke-linecap="round"/>
<circle cx="46" cy="53" r="3.4" fill="#F2545B"/>''',

    '🦂': f'''<path d="M56 80 Q74 98 92 88 Q108 76 100 52 Q96 40 86 42" fill="none" stroke="{INKC}" stroke-width="14" stroke-linecap="round"/>
<path d="M56 80 Q74 98 92 88 Q108 76 100 52 Q96 40 86 42" fill="none" stroke="#C98A3A" stroke-width="8" stroke-linecap="round"/>
<path d="M86 42 L78 32 L90 36 Z" fill="#5B3A22" {O3}/>
<path d="M36 70 L18 82 M40 76 L26 92 M60 70 L72 86" {L3}/>
<path d="M30 54 L16 40 M48 52 L56 36" {L}/>
<path d="M16 40 Q4 36 6 26 Q16 20 22 30 Z M56 36 Q58 22 68 24 Q72 34 62 38 Z" fill="#C98A3A" {O3}/>
<ellipse cx="44" cy="66" rx="20" ry="14" fill="#C98A3A" {O}/>
<circle cx="36" cy="60" r="2.8" {INK}/><circle cx="46" cy="58" r="2.8" {INK}/>''',

    '🦩': f'''<path d="M66 82 V112 M74 82 L84 98 L74 104" fill="none" stroke="{INKC}" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M66 82 V112 M74 82 L84 98 L74 104" fill="none" stroke="#FF8FB1" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M44 68 Q50 46 76 50 Q102 54 104 70 Q96 88 70 86 Q50 86 44 68 Z" fill="#FF8FB1" {O}/>
<path d="M62 62 Q78 54 94 66 Q78 76 62 62 Z" fill="#FF6F9E" {O3}/>
<path d="M50 66 Q30 50 36 28 Q42 12 56 18 Q62 24 56 30" fill="none" stroke="{INKC}" stroke-width="13" stroke-linecap="round"/>
<path d="M50 66 Q30 50 36 28 Q42 12 56 18 Q62 24 56 30" fill="none" stroke="#FF8FB1" stroke-width="7" stroke-linecap="round"/>
<path d="M58 20 Q70 22 68 36 Q62 30 56 30 Z" fill="#FFFFFF" {O3}/><path d="M64 30 Q68 34 68 36 Q64 34 62 33 Z" {INK}/>
<circle cx="50" cy="20" r="2.6" {INK}/>''',

    '🦚': f'''{''.join(f'<ellipse cx="60" cy="22" rx="11" ry="24" fill="#2BAE9A" {O3} transform="rotate({a} 60 70)"/><circle cx="60" cy="14" r="5" fill="#2E7FC4" transform="rotate({a} 60 70)"/>' for a in (-72, -48, -24, 0, 24, 48, 72))}
<ellipse cx="60" cy="80" rx="16" ry="22" fill="#2E7FC4" {O}/>
<circle cx="60" cy="52" r="12" fill="#2E7FC4" {O}/>
<path d="M56 40 L54 30 M60 40 V28 M64 40 L66 30" {L3}/>
<path d="M66 54 L74 56 L66 59 Z" fill="#FFB020" {O3}/><circle cx="58" cy="50" r="2.6" {INK}/>''',

    '🕊️': f'''<path d="M58 60 Q40 28 20 30 Q30 42 28 56 Q40 54 58 66 Z" fill="#FFFFFF" {O}/>
<path d="M30 74 Q50 58 76 60 Q96 62 104 50 Q110 60 100 72 Q90 84 64 86 L46 98 L48 86 Q34 84 30 74 Z" fill="#FFFFFF" {O}/>
<circle cx="96" cy="52" r="11" fill="#FFFFFF" {O}/>
<path d="M106 52 L116 54 L106 58 Z" fill="#FFB020" {O3}/><circle cx="98" cy="49" r="2.6" {INK}/>
<path d="M108 58 Q114 66 108 72 M110 62 L116 64" fill="none" stroke="#4CAF50" stroke-width="3" stroke-linecap="round"/>''',

    '🐨': f'''<circle cx="24" cy="44" r="20" fill="#A7B4C6" {O}/><circle cx="96" cy="44" r="20" fill="#A7B4C6" {O}/>
<circle cx="24" cy="46" r="11" fill="#F4D3DC"/><circle cx="96" cy="46" r="11" fill="#F4D3DC"/>
<circle cx="60" cy="64" r="36" fill="#A7B4C6" {O}/>
<ellipse cx="60" cy="72" rx="11" ry="15" fill="#4A4475" {O3}/>
{eyes(44, 76, 58, 4)}{cheeks(38, 82, 76, 4.5)}''',

    '🐺': f'''<path d="M28 50 L26 12 L54 34 Z M92 50 L94 12 L66 34 Z" fill="#8F9BB3" {O}/>
<path d="M32 40 L31 22 L45 33 Z M88 40 L89 22 L75 33 Z" fill="#4A4475"/>
<path d="M14 54 Q24 30 60 32 Q96 30 106 54 Q100 84 60 102 Q20 84 14 54 Z" fill="#8F9BB3" {O}/>
<path d="M40 70 Q50 64 60 70 Q70 64 80 70 Q78 92 60 100 Q42 92 40 70 Z" fill="#E8ECF2"/>
<ellipse cx="60" cy="74" rx="6" ry="4.5" {INK}/>
<ellipse cx="44" cy="56" rx="4" ry="5" {INK}/><ellipse cx="76" cy="56" rx="4" ry="5" {INK}/>
<path d="M60 78 V84 M52 88 Q60 92 68 88" {L3}/>''',

    '🐀': f'''<path d="M96 76 Q116 80 112 100 Q108 108 98 104" fill="none" stroke="#F7A1B0" stroke-width="4" stroke-linecap="round"/>
<path d="M20 78 Q24 50 56 48 Q92 48 98 78 Q92 92 60 92 Q24 92 20 78 Z" fill="#9AA3B5" {O}/>
<circle cx="40" cy="46" r="11" fill="#9AA3B5" {O}/><circle cx="40" cy="46" r="5" fill="#F7A1B0"/>
<path d="M22 70 L6 76 L22 82" fill="#9AA3B5" {O3}/>
<circle cx="6" cy="76" r="3" fill="#F27C8E"/><circle cx="24" cy="66" r="3.2" {INK}/>
<path d="M30 92 v8 M80 92 v8" {L3}/>''',

    '🐥': f'''<ellipse cx="62" cy="78" rx="34" ry="28" fill="#FFD93D" {O}/>
<circle cx="58" cy="44" r="24" fill="#FFD93D" {O}/>
<path d="M54 22 Q56 12 62 14 Q60 18 62 22" {L3}/>
<path d="M66 72 Q82 66 90 80 Q78 88 66 72 Z" fill="#F5C518" {O3}/>
<path d="M76 46 L90 50 L76 56 Z" fill="#FF9F2E" {O3}/>
<circle cx="64" cy="40" r="3.6" {INK}/><circle cx="70" cy="52" r="3.5" {CK}/>
<path d="M52 104 V114 M70 104 V114" fill="none" stroke="#FF9F2E" stroke-width="4" stroke-linecap="round"/>''',

    '🐚': f'''<path d="M60 104 L20 50 Q24 26 60 22 Q96 26 100 50 Z" fill="#FFC9B5" {O}/>
<path d="M60 104 L36 34 M60 104 L50 24 M60 104 L70 24 M60 104 L84 34" fill="none" stroke="#E8957A" stroke-width="3" stroke-linecap="round"/>
<path d="M48 96 Q60 112 72 96 L60 104 Z" fill="#FFC9B5" {O3}/>''',

    '🐾': f'''<ellipse cx="44" cy="74" rx="16" ry="14" fill="#8A5A3B" {O3}/>
<circle cx="28" cy="54" r="7" fill="#8A5A3B" {O3}/><circle cx="40" cy="46" r="7" fill="#8A5A3B" {O3}/><circle cx="54" cy="48" r="7" fill="#8A5A3B" {O3}/><circle cx="62" cy="58" r="6.5" fill="#8A5A3B" {O3}/>
<ellipse cx="82" cy="44" rx="13" ry="11" fill="#8A5A3B" {O3}/>
<circle cx="70" cy="28" r="5.5" fill="#8A5A3B" {O3}/><circle cx="80" cy="22" r="5.5" fill="#8A5A3B" {O3}/><circle cx="92" cy="24" r="5.5" fill="#8A5A3B" {O3}/><circle cx="99" cy="33" r="5" fill="#8A5A3B" {O3}/>''',

    '🦴': f'''<path d="M30 46 Q18 50 16 38 Q16 26 28 28 Q28 16 40 18 Q50 22 46 34 L74 62 Q86 58 90 70 Q92 82 80 80 Q82 94 70 92 Q60 88 64 76 Z" fill="#FFF6E5" {O} transform="rotate(10 60 60)"/>
<path d="M36 40 L70 72" fill="none" stroke="#E8DCC4" stroke-width="3" transform="rotate(10 60 60)"/>''',

    '🕸️': f'''<path d="M60 10 V110 M10 60 H110 M24 24 L96 96 M96 24 L24 96" fill="none" stroke="#7A7699" stroke-width="2.5"/>
<path d="M60 22 L87 33 L98 60 L87 87 L60 98 L33 87 L22 60 L33 33 Z M60 36 L77 43 L84 60 L77 77 L60 84 L43 77 L36 60 L43 43 Z M60 50 L67 53 L70 60 L67 67 L60 70 L53 67 L50 60 L53 53 Z" fill="none" stroke="#7A7699" stroke-width="2.5" stroke-linejoin="round"/>''',

    '🍯': f'''<path d="M30 40 H90 Q100 64 92 92 Q86 108 60 108 Q34 108 28 92 Q20 64 30 40 Z" fill="#FFB020" {O}/>
<rect x="28" y="26" width="64" height="16" rx="6" fill="#C9822A" {O}/>
<path d="M30 46 Q40 56 48 46 Q50 60 58 46 Q66 58 72 46 Q78 56 90 46" fill="#FFD25A" {O3}/>
<rect x="42" y="66" width="36" height="22" rx="5" fill="#FFF6E5" {O3}/>
<path d="M50 77 H70" fill="none" stroke="#C9822A" stroke-width="3" stroke-linecap="round"/>
<ellipse cx="40" cy="70" rx="4" ry="12" {SH}/>''',
}
ALIASES = {'🐤': '🐥'}
