# Batch 2: animals. Uses helpers from make_pics.py (O, O3, L, L3, INK, SH, CK, eyes, smile, cheeks, ...).
BATCH = {
    '🐯': f'''<circle cx="32" cy="32" r="12" fill="#FF9F2E" {O}/><circle cx="88" cy="32" r="12" fill="#FF9F2E" {O}/>
<circle cx="32" cy="32" r="5.5" fill="#FFFFFF"/><circle cx="88" cy="32" r="5.5" fill="#FFFFFF"/>
<circle cx="60" cy="62" r="38" fill="#FF9F2E" {O}/>
<path d="M60 26 V38 M48 28 L51 38 M72 28 L69 38 M24 56 H36 M24 66 H34 M96 56 H84 M96 66 H86" fill="none" stroke="{INKC}" stroke-width="4" stroke-linecap="round"/>
<ellipse cx="60" cy="78" rx="18" ry="13" fill="#FFFFFF" {O3}/><path d="M54 70 H66 L60 76 Z" fill="#F27C8E" {O3}/>
<path d="M60 76 V80 Q55 85 50 81 M60 80 Q65 85 70 81" {L3}/>{eyes(47, 73, 56, 4)}''',

    '🦓': f'''<path d="M40 30 L42 12 L54 26 Z M80 30 L78 12 L66 26 Z" fill="#FFFFFF" {O}/>
<path d="M50 24 Q60 8 70 24" fill="#2D2A4A" {O3}/>
<path d="M38 30 Q60 18 82 30 Q86 70 78 98 Q60 112 42 98 Q34 70 38 30 Z" fill="#FFFFFF" {O}/>
<path d="M40 44 Q50 46 56 40 M80 44 Q70 46 64 40 M38 62 Q48 62 52 56 M82 62 Q72 62 68 56 M40 78 Q46 76 50 72 M80 78 Q74 76 70 72" fill="none" stroke="{INKC}" stroke-width="5" stroke-linecap="round"/>
<ellipse cx="60" cy="94" rx="18" ry="12" fill="#5B5878" {O3}/><circle cx="53" cy="94" r="2.5" fill="#FFFFFF"/><circle cx="67" cy="94" r="2.5" fill="#FFFFFF"/>
{eyes(47, 73, 54, 4)}''',

    '🐑': f'''{blob([(36, 46, 16), (60, 36, 18), (84, 46, 16), (30, 70, 15), (90, 70, 15), (44, 90, 15), (76, 90, 15), (60, 96, 14)], '#FFFFFF')}
<ellipse cx="60" cy="66" rx="34" ry="30" fill="#FFFFFF"/>
<ellipse cx="22" cy="56" rx="10" ry="6" fill="#5B5878" {O3} transform="rotate(-25 22 56)"/><ellipse cx="98" cy="56" rx="10" ry="6" fill="#5B5878" {O3} transform="rotate(25 98 56)"/>
<ellipse cx="60" cy="66" rx="20" ry="24" fill="#5B5878" {O}/>
<circle cx="52" cy="60" r="3.6" fill="#FFFFFF"/><circle cx="68" cy="60" r="3.6" fill="#FFFFFF"/>
<path d="M54 76 Q60 81 66 76" fill="none" stroke="#FFFFFF" stroke-width="3" stroke-linecap="round"/>''',

    '🐍': f'''<path d="M18 96 C40 110 70 104 72 88 C74 72 40 76 40 58 C40 40 72 40 78 30" fill="none" stroke="{INKC}" stroke-width="20" stroke-linecap="round"/>
<path d="M18 96 C40 110 70 104 72 88 C74 72 40 76 40 58 C40 40 72 40 78 30" fill="none" stroke="#6CC24A" stroke-width="13" stroke-linecap="round"/>
<path d="M30 102 l4 -6 M52 101 l2 -7 M62 82 l-6 -4 M46 62 l7 -2 M58 46 l2 7" fill="none" stroke="#FFD93D" stroke-width="3" stroke-linecap="round"/>
<ellipse cx="86" cy="26" rx="17" ry="13" fill="#6CC24A" {O}/>
<path d="M102 28 L112 30 M112 30 L116 26 M112 30 L116 34" fill="none" stroke="#F2545B" stroke-width="2.5" stroke-linecap="round"/>
<circle cx="84" cy="21" r="3.4" {INK}/><circle cx="94" cy="21" r="3.4" {INK}/>''',

    '🐛': f'''{blob([(22, 72, 14), (40, 78, 14), (58, 80, 14), (76, 76, 14)], '#8BD346')}
<circle cx="94" cy="60" r="18" fill="#8BD346" {O}/>
<path d="M88 44 Q84 30 78 28 M100 44 Q104 30 110 28" {L3}/><circle cx="78" cy="28" r="3.5" fill="#F2545B" {O3}/><circle cx="110" cy="28" r="3.5" fill="#F2545B" {O3}/>
{eyes(88, 100, 58, 3.4)}{smile(88, 100, 66, 5)}
<path d="M22 86 v8 M40 92 v8 M58 94 v8 M76 90 v8" {L3}/>''',

    '🐠': f'''<path d="M84 60 L110 40 L106 60 L110 80 Z" fill="#FF8C42" {O}/>
<path d="M44 34 Q60 16 74 36 Z M48 86 Q60 102 70 84 Z" fill="#FF8C42" {O3}/>
<ellipse cx="54" cy="60" rx="36" ry="27" fill="#FF8C42" {O}/>
<path d="M44 35 Q36 60 44 85 L56 86 Q48 60 56 34 Z M70 37 Q64 60 70 83 L78 80 Q72 60 78 40 Z" fill="#FFFFFF" {O3}/>
<circle cx="30" cy="54" r="7" fill="#FFFFFF" {O3}/><circle cx="31" cy="55" r="3.5" {INK}/>
<path d="M20 68 Q25 72 30 68" {L3}/>''',

    '🐔': f'''<path d="M84 46 Q104 30 108 54 Q100 50 96 60 Z" fill="#FFFFFF" {O3}/>
<ellipse cx="64" cy="76" rx="36" ry="28" fill="#FFFFFF" {O}/>
<path d="M30 30 Q34 16 42 24 Q46 12 54 22 Q60 14 62 28 Z" fill="#F2545B" {O3}/>
<circle cx="44" cy="48" r="20" fill="#FFFFFF" {O}/>
<path d="M24 48 L12 52 L24 56 Z" fill="#FFB020" {O3}/>
<path d="M28 58 Q26 70 34 70 Q38 64 34 58 Z" fill="#F2545B" {O3}/>
<circle cx="40" cy="44" r="3.6" {INK}/>
<path d="M60 76 Q72 64 84 76 Q74 88 60 76 Z" fill="#EDEDF2" {O3}/>
<path d="M52 104 V114 M72 104 V114" fill="none" stroke="#FFB020" stroke-width="4" stroke-linecap="round"/>''',

    '🐓': f'''<path d="M84 64 Q104 20 116 50 Q108 44 104 58 Q112 56 108 74 Z" fill="#4CAF50" {O3}/>
<path d="M88 62 Q104 40 110 66 Z" fill="#2E7FC4" {O3}/>
<ellipse cx="62" cy="76" rx="34" ry="27" fill="#C9512A" {O}/>
<path d="M28 26 Q32 10 40 18 Q44 6 52 16 Q58 8 60 24 Z" fill="#F2545B" {O3}/>
<circle cx="44" cy="44" r="19" fill="#E8892B" {O}/>
<path d="M25 44 L12 48 L25 53 Z" fill="#FFD93D" {O3}/>
<path d="M30 56 Q27 68 35 68 Q40 62 35 56 Z" fill="#F2545B" {O3}/>
<circle cx="40" cy="40" r="3.6" {INK}/>
<path d="M52 101 V114 M70 101 V114" fill="none" stroke="#FFB020" stroke-width="4" stroke-linecap="round"/>''',

    '🐐': f'''<path d="M42 30 Q30 12 20 22 Q30 22 36 36 Z M78 30 Q90 12 100 22 Q90 22 84 36 Z" fill="#C9B79C" {O3}/>
<ellipse cx="22" cy="50" rx="13" ry="6" fill="#EDE7DD" {O} transform="rotate(-20 22 50)"/><ellipse cx="98" cy="50" rx="13" ry="6" fill="#EDE7DD" {O} transform="rotate(20 98 50)"/>
<path d="M38 34 Q60 22 82 34 Q86 66 74 86 Q60 96 46 86 Q34 66 38 34 Z" fill="#EDE7DD" {O}/>
<path d="M52 90 Q60 112 68 90 Z" fill="#C9B79C" {O3}/>
<ellipse cx="60" cy="78" rx="12" ry="8" fill="#F9B8C6" {O3}/>
{eyes(48, 72, 54, 4)}''',

    '🐦': f'''<path d="M88 58 L112 46 L108 66 Z" fill="#2E7FC4" {O}/>
<ellipse cx="60" cy="64" rx="34" ry="30" fill="#4FA8F0" {O}/>
<ellipse cx="54" cy="76" rx="20" ry="14" fill="#CDEBFF"/>
<path d="M62 62 Q82 52 92 70 Q76 82 62 62 Z" fill="#2E7FC4" {O3}/>
<path d="M28 52 L14 58 L28 62 Z" fill="#FFB020" {O3}/>
<circle cx="40" cy="50" r="3.6" {INK}/><circle cx="44" cy="60" r="3.5" {CK}/>
<path d="M54 94 V104 M66 94 V104" fill="none" stroke="#FFB020" stroke-width="4" stroke-linecap="round"/>''',

    '🐋': f'''<path d="M96 52 Q104 30 116 34 Q108 44 112 56 Q100 54 96 62 Z" fill="#4A78C9" {O}/>
<path d="M10 66 Q12 36 52 34 Q92 34 100 62 Q96 92 54 94 Q14 94 10 66 Z" fill="#4A78C9" {O}/>
<path d="M14 70 Q50 84 96 70 Q90 90 54 92 Q20 92 14 70 Z" fill="#CDE3FF"/>
<path d="M40 22 Q36 12 30 12 M40 22 Q44 10 50 10 M40 22 V30" {L3}/>
<circle cx="30" cy="58" r="3.8" {INK}/>{smile(22, 36, 70, 5)}
<path d="M50 70 Q60 80 72 70" fill="#3B66B0" {O3}/>''',

    '🐊': f'''<path d="M40 74 L32 92 M64 76 L60 94 M88 72 L92 90" fill="none" stroke="{INKC}" stroke-width="9" stroke-linecap="round"/>
<path d="M40 74 L32 92 M64 76 L60 94 M88 72 L92 90" fill="none" stroke="#5FAE3B" stroke-width="4" stroke-linecap="round"/>
<path d="M8 64 Q10 48 30 46 L40 38 Q48 34 54 42 L92 46 Q114 48 116 64 Q110 76 92 74 L30 76 Q10 76 8 64 Z" fill="#5FAE3B" {O}/>
<path d="M10 64 H50" {L3}/><path d="M14 64 L17 69 L20 64 L23 69 L26 64 L29 69 L32 64 L35 69 L38 64" fill="#FFFFFF" stroke="{INKC}" stroke-width="2" stroke-linejoin="round"/>
<circle cx="46" cy="42" r="6" fill="#FFFFFF" {O3}/><circle cx="47" cy="42" r="3" {INK}/>
<path d="M60 50 l4 -6 l4 6 M74 50 l4 -6 l4 6 M88 52 l4 -6 l4 6" fill="#4C9530" stroke="{INKC}" stroke-width="2" stroke-linejoin="round"/>''',

    '🦀': f'''<path d="M30 72 L14 82 M32 82 L18 94 M90 72 L106 82 M88 82 L102 94" {L}/>
<path d="M36 50 L24 30 M84 50 L96 30" {L}/>
<path d="M24 30 Q10 26 12 14 Q22 8 30 18 Q28 24 24 30 Z M96 30 Q110 26 108 14 Q98 8 90 18 Q92 24 96 30 Z" fill="#F2545B" {O3}/>
<ellipse cx="60" cy="70" rx="34" ry="24" fill="#F2545B" {O}/>
<path d="M52 46 V36 M68 46 V36" {L3}/><circle cx="52" cy="34" r="5" fill="#FFFFFF" {O3}/><circle cx="68" cy="34" r="5" fill="#FFFFFF" {O3}/>
<circle cx="52" cy="35" r="2.4" {INK}/><circle cx="68" cy="35" r="2.4" {INK}/>
{smile(52, 68, 74, 7)}{cheeks(40, 80, 72)}''',

    '🦇': f'''<path d="M60 52 Q40 30 8 40 Q18 50 14 62 Q26 56 30 68 Q40 60 50 70 Z" fill="#5B5878" {O}/>
<path d="M60 52 Q80 30 112 40 Q102 50 106 62 Q94 56 90 68 Q80 60 70 70 Z" fill="#5B5878" {O}/>
<path d="M48 40 L46 24 L56 34 Z M72 40 L74 24 L64 34 Z" fill="#5B5878" {O3}/>
<ellipse cx="60" cy="56" rx="16" ry="20" fill="#7A7699" {O}/>
<circle cx="54" cy="50" r="3" fill="#FFFFFF"/><circle cx="66" cy="50" r="3" fill="#FFFFFF"/>
<path d="M55 62 L57 66 L59 62 M61 62 L63 66 L65 62" fill="#FFFFFF" stroke="{INKC}" stroke-width="1.5"/>''',

    '🦅': f'''<path d="M60 60 Q30 40 6 52 Q22 58 18 70 Q34 64 40 76 Z M60 60 Q90 40 114 52 Q98 58 102 70 Q86 64 80 76 Z" fill="#7A4A2A" {O}/>
<ellipse cx="60" cy="76" rx="20" ry="26" fill="#8A5A3B" {O}/>
<path d="M50 100 L46 112 L56 104 L60 114 L64 104 L74 112 L70 100 Z" fill="#8A5A3B" {O3}/>
<circle cx="60" cy="40" r="17" fill="#FFFFFF" {O}/>
<path d="M60 44 Q74 42 76 52 Q70 50 64 54 Z" fill="#FFB020" {O3}/>
<circle cx="56" cy="38" r="3.4" {INK}/>''',

    '🦜': f'''<path d="M54 92 L44 116 L58 104 L62 118 L68 96 Z" fill="#4FA8F0" {O3}/>
<ellipse cx="60" cy="72" rx="26" ry="32" fill="#4CAF50" {O}/>
<path d="M46 62 Q36 84 52 98 Q62 84 58 64 Z" fill="#FFD93D" {O3}/>
<circle cx="60" cy="38" r="22" fill="#F2545B" {O}/>
<path d="M74 34 Q92 34 88 52 Q82 46 74 48 Z" fill="#FFF6E5" {O3}/>
<circle cx="66" cy="32" r="6" fill="#FFFFFF" {O3}/><circle cx="67" cy="32" r="3" {INK}/>''',

    '🦈': f'''<path d="M92 60 L114 38 L108 60 L114 82 Z" fill="#7F8FA6" {O}/>
<path d="M50 38 L62 12 L72 40 Z" fill="#7F8FA6" {O}/>
<path d="M6 62 Q20 38 56 36 Q90 36 100 60 Q90 84 56 86 Q20 86 6 62 Z" fill="#7F8FA6" {O}/>
<path d="M10 64 Q40 74 96 64 Q88 84 56 84 Q24 84 10 64 Z" fill="#FFFFFF"/>
<path d="M14 66 L18 72 L22 67 L26 73 L30 67 L34 72 L38 67" fill="none" stroke="{INKC}" stroke-width="2.5" stroke-linejoin="round"/>
<circle cx="30" cy="54" r="3.8" {INK}/><path d="M58 52 v14 M66 52 v14" fill="none" stroke="#5B6B82" stroke-width="2.5" stroke-linecap="round"/>''',

    '🐼': f'''<circle cx="32" cy="32" r="14" {INK} {O}/><circle cx="88" cy="32" r="14" {INK} {O}/>
<circle cx="60" cy="64" r="38" fill="#FFFFFF" {O}/>
<ellipse cx="45" cy="60" rx="10" ry="13" {INK} transform="rotate(20 45 60)"/><ellipse cx="75" cy="60" rx="10" ry="13" {INK} transform="rotate(-20 75 60)"/>
<circle cx="46" cy="58" r="3.4" fill="#FFFFFF"/><circle cx="74" cy="58" r="3.4" fill="#FFFFFF"/>
<ellipse cx="60" cy="76" rx="6" ry="4.5" {INK}/><path d="M60 80 V84 Q55 89 51 85 M60 84 Q65 89 69 85" {L3}/>
{cheeks(38, 82, 78)}''',

    '🐬': f'''<path d="M94 64 Q108 50 116 56 Q108 64 112 76 Q100 72 92 76 Z" fill="#5BA8E8" {O}/>
<path d="M52 36 L60 18 L70 38 Z" fill="#5BA8E8" {O}/>
<path d="M8 60 Q4 54 14 52 L26 50 Q50 32 80 42 Q98 50 98 66 Q94 86 66 88 Q40 90 26 74 Q12 70 8 60 Z" fill="#5BA8E8" {O}/>
<path d="M14 62 Q40 76 92 72 Q84 86 66 86 Q42 88 28 74 Z" fill="#DDF0FF"/>
<path d="M58 72 Q64 84 74 80 Q68 72 58 72 Z" fill="#4A92D0" {O3}/>
<circle cx="38" cy="54" r="3.8" {INK}/>{smile(14, 30, 60, 5)}''',

    '🐌': f'''<path d="M12 96 Q10 84 28 84 H88 Q100 84 104 72 L110 74 Q108 96 90 98 H24 Q12 98 12 96 Z" fill="#B5D34A" {O}/>
<path d="M98 76 L94 56 M106 74 L108 54" {L3}/><circle cx="94" cy="54" r="4" {INK}/><circle cx="108" cy="52" r="4" {INK}/>
<circle cx="54" cy="58" r="32" fill="#E8892B" {O}/>
<path d="M54 58 m0 -6 a6 6 0 1 1 -6 6 a12 12 0 1 1 12 12 a18 18 0 1 1 -18 -18 a24 24 0 1 1 24 24" fill="none" stroke="#B5621A" stroke-width="4" stroke-linecap="round"/>
<circle cx="102" cy="82" r="3" {CK}/>''',

    '🐪': f'''<path d="M30 76 V108 M44 80 V108 M78 80 V108 M92 76 V108" fill="none" stroke="{INKC}" stroke-width="11" stroke-linecap="round"/>
<path d="M30 76 V108 M44 80 V108 M78 80 V108 M92 76 V108" fill="none" stroke="#D9A066" stroke-width="5" stroke-linecap="round"/>
<path d="M20 78 Q20 56 34 52 Q42 30 54 50 Q62 32 76 52 Q96 54 98 78 Q60 90 20 78 Z" fill="#D9A066" {O}/>
<path d="M96 66 Q104 46 100 30 L110 26 Q120 30 116 40 L110 42 Q112 60 104 74 Z" fill="#D9A066" {O}/>
<circle cx="108" cy="32" r="2.6" {INK}/>''',

    '🦢': f'''<path d="M40 86 Q20 80 18 64 Q40 70 52 60 Q70 50 96 64 Q110 74 104 88 Q90 100 60 98 Q46 96 40 86 Z" fill="#FFFFFF" {O}/>
<path d="M54 64 Q70 56 88 70 Q74 80 54 64 Z" fill="#EDEDF2" {O3}/>
<path d="M44 70 Q30 50 34 30 Q38 14 52 18 Q60 22 56 32 Q46 40 50 62" fill="none" stroke="{INKC}" stroke-width="14" stroke-linecap="round"/>
<path d="M44 70 Q30 50 34 30 Q38 14 52 18 Q60 22 56 32 Q46 40 50 62" fill="none" stroke="#FFFFFF" stroke-width="7" stroke-linecap="round"/>
<path d="M56 22 L68 26 L56 30 Z" fill="#FF8C42" {O3}/><circle cx="50" cy="22" r="2.6" {INK}/>
<path d="M10 96 Q30 104 60 102 Q90 104 112 96" fill="none" stroke="#4FA8F0" stroke-width="4" stroke-linecap="round"/>''',

    '🦎': f'''<path d="M30 46 L18 36 M30 74 L18 86 M76 50 L88 38 M76 72 L88 84" fill="none" stroke="{INKC}" stroke-width="10" stroke-linecap="round"/>
<path d="M30 46 L18 36 M30 74 L18 86 M76 50 L88 38 M76 72 L88 84" fill="none" stroke="#6CC24A" stroke-width="4.5" stroke-linecap="round"/>
<path d="M76 60 Q100 60 108 74 Q112 88 100 94 Q104 82 96 74 Q88 68 76 68 Z" fill="#6CC24A" {O}/>
<ellipse cx="52" cy="60" rx="30" ry="14" fill="#6CC24A" {O}/>
<ellipse cx="18" cy="60" rx="14" ry="11" fill="#6CC24A" {O}/>
<circle cx="14" cy="55" r="3.4" {INK}/>
<circle cx="44" cy="56" r="3" fill="#FFD93D"/><circle cx="56" cy="62" r="3" fill="#FFD93D"/><circle cx="66" cy="56" r="3" fill="#FFD93D"/>''',

    '🕷️': f'''<path d="M46 56 Q28 36 14 44 M44 64 Q26 56 10 66 M46 72 Q28 76 14 90 M50 78 Q38 92 30 106 M74 56 Q92 36 106 44 M76 64 Q94 56 110 66 M74 72 Q92 76 106 90 M70 78 Q82 92 90 106" {L}/>
<path d="M60 4 V36" fill="none" stroke="{INKC}" stroke-width="2"/>
<ellipse cx="60" cy="72" rx="20" ry="22" fill="#4A4475" {O}/>
<circle cx="60" cy="44" r="14" fill="#4A4475" {O}/>
<circle cx="55" cy="42" r="4" fill="#FFFFFF"/><circle cx="65" cy="42" r="4" fill="#FFFFFF"/>
<circle cx="55" cy="43" r="2" {INK}/><circle cx="65" cy="43" r="2" {INK}/>''',

    '🦃': f'''{''.join(f'<ellipse cx="60" cy="30" rx="11" ry="26" fill="{c}" {O3} transform="rotate({a} 60 64)"/>' for a, c in [(-60, '#F2545B'), (-30, '#FF9F2E'), (0, '#FFD93D'), (30, '#FF9F2E'), (60, '#F2545B')])}
<ellipse cx="60" cy="74" rx="26" ry="28" fill="#8A5A3B" {O}/>
<circle cx="60" cy="46" r="14" fill="#A0704D" {O}/>
<path d="M57 50 L60 58 L63 50 Z" fill="#FFB020" {O3}/>
<path d="M62 54 Q66 66 60 68 Q56 62 60 56 Z" fill="#F2545B" {O3}/>
{eyes(55, 65, 44, 3)}
<path d="M50 100 V112 M70 100 V112" fill="none" stroke="#FFB020" stroke-width="4" stroke-linecap="round"/>''',

    '🦏': f'''<path d="M30 34 L26 18 L40 28 Z M84 34 L88 18 L76 28 Z" fill="#9EADC2" {O3}/>
<path d="M22 50 Q30 26 60 26 Q90 26 98 50 Q104 76 92 92 Q60 108 28 92 Q16 76 22 50 Z" fill="#B8C4D6" {O}/>
<path d="M56 74 L60 38 L70 72 Z" fill="#F3E6C8" {O3}/>
<path d="M66 62 L70 48 L76 62 Z" fill="#F3E6C8" {O3}/>
<ellipse cx="60" cy="90" rx="20" ry="9" fill="#9EADC2" {O3}/>
<circle cx="52" cy="90" r="2.5" {INK}/><circle cx="68" cy="90" r="2.5" {INK}/>
{eyes(38, 86, 58, 4)}''',

    '🐳': f'''<path d="M96 54 Q104 32 116 36 Q108 46 112 58 Q100 56 96 64 Z" fill="#4FA8F0" {O}/>
<path d="M10 66 Q12 38 52 36 Q92 36 100 64 Q96 92 54 94 Q14 94 10 66 Z" fill="#4FA8F0" {O}/>
<path d="M14 70 Q50 84 96 70 Q90 90 54 92 Q20 92 14 70 Z" fill="#DDF0FF"/>
<path d="M44 26 Q36 10 28 14 M44 26 Q46 8 56 10 M44 26 Q52 16 62 22" fill="none" stroke="#4FA8F0" stroke-width="4" stroke-linecap="round"/>
<circle cx="30" cy="58" r="3.8" {INK}/>{smile(20, 38, 70, 6)}{cheeks(42, 42, 66, 3.5)}''',

    '🦗': f'''<path d="M44 72 L30 98 M60 74 L56 100 M82 66 L104 50 L110 92" fill="none" stroke="{INKC}" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M34 50 Q24 30 10 24 M40 46 Q36 26 30 12" {L3}/>
<path d="M40 58 Q70 34 104 54 Q90 70 50 72 Z" fill="#7FB83A" {O}/>
<ellipse cx="62" cy="64" rx="34" ry="12" fill="#8BD346" {O}/>
<circle cx="36" cy="56" r="13" fill="#8BD346" {O}/>
<circle cx="32" cy="52" r="3.4" {INK}/>''',

    '🦘': f'''<path d="M84 84 Q112 96 116 72" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>
<path d="M84 84 Q112 96 116 72" fill="none" stroke="#C98A5A" stroke-width="6" stroke-linecap="round"/>
<path d="M52 110 H76 L78 100 Z M40 110 H56" fill="#C98A5A" {O3}/>
<ellipse cx="64" cy="78" rx="24" ry="30" fill="#C98A5A" {O}/>
<path d="M54 82 Q64 96 74 82 Q64 76 54 82 Z" fill="#E8B98E" {O3}/>
<path d="M44 28 L42 8 L52 22 Z M58 26 L62 8 L66 24 Z" fill="#C98A5A" {O3}/>
<ellipse cx="52" cy="38" rx="16" ry="14" fill="#C98A5A" {O}/>
<path d="M38 42 Q28 44 30 50 Q36 52 42 48 Z" fill="#C98A5A" {O3}/>
<circle cx="31" cy="46" r="2.5" {INK}/><circle cx="52" cy="34" r="3.4" {INK}/>''',

    '🐙': f'''<path d="M28 70 Q20 96 30 104 Q34 90 40 80 M44 76 Q40 102 50 110 Q54 94 54 80 M66 80 Q66 94 70 110 Q80 102 76 76 M80 80 Q86 90 90 104 Q100 96 92 70" fill="#F27C8E" {O}/>
<path d="M22 64 Q18 18 60 16 Q102 18 98 64 Q96 82 60 84 Q24 82 22 64 Z" fill="#F27C8E" {O}/>
<circle cx="46" cy="54" r="7" fill="#FFFFFF" {O3}/><circle cx="74" cy="54" r="7" fill="#FFFFFF" {O3}/>
<circle cx="47" cy="55" r="3.4" {INK}/><circle cx="75" cy="55" r="3.4" {INK}/>
{smile(52, 68, 68, 6)}{cheeks(36, 84, 66)}
<circle cx="44" cy="30" r="4" fill="#FFFFFF" fill-opacity="0.5"/><circle cx="56" cy="26" r="2.5" fill="#FFFFFF" fill-opacity="0.5"/>''',
}
