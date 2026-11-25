# Batch 6: vehicles and everyday objects.
def van(body, extra=''):
    return f'''<path d="M10 80 V44 Q10 30 24 30 H76 Q86 30 92 40 L106 58 Q110 62 110 70 V80 Q110 86 104 86 H16 Q10 86 10 80 Z" fill="{body}" {O}/>
<path d="M80 38 H86 Q88 38 90 42 L100 58 H80 Z" fill="#CDEBFF" {O3}/>{extra}{wheel(32, 88)}{wheel(88, 88)}'''


def book(cover, pages='#FFFFFF'):
    return f'''<path d="M24 16 H88 Q96 16 96 24 V104 H32 Q24 104 24 96 Z" fill="{cover}" {O}/>
<path d="M32 96 H96 V108 H32 Q24 108 24 102 Q24 96 32 96 Z" fill="{pages}" {O3}/>'''


BATCH = {
    '✈️': f'''<path d="M58 52 L20 34 L14 40 L46 64 Z M64 74 L84 104 L92 100 L80 70 Z" fill="#B8C4D6" {O3}/>
<path d="M14 72 Q10 64 20 62 L96 40 Q112 36 112 46 Q112 54 100 58 L26 80 Q16 82 14 72 Z" fill="#FFFFFF" {O}/>
<path d="M20 64 L12 46 L20 44 L30 60 Z" fill="#4FA8F0" {O3}/>
<g fill="#4FA8F0"><circle cx="50" cy="60" r="3"/><circle cx="62" cy="56" r="3"/><circle cx="74" cy="52" r="3"/></g>''',

    '🚲': f'''<circle cx="28" cy="78" r="20" fill="none" stroke="{INKC}" stroke-width="5"/><circle cx="92" cy="78" r="20" fill="none" stroke="{INKC}" stroke-width="5"/>
<path d="M28 78 L48 46 H82 L92 78 M48 46 L60 78 L82 46 M60 78 H28 M44 38 H58 M82 46 L78 32 H90" fill="none" stroke="#F2453F" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
<circle cx="60" cy="78" r="5" {INK}/>''',

    '🚀': f'''<path d="M42 72 L24 92 L30 70 Z M78 72 L96 92 L90 70 Z" fill="#F2453F" {O3}/>
<path d="M60 6 Q88 30 82 82 H38 Q32 30 60 6 Z" fill="#FFFFFF" {O}/>
<path d="M60 6 Q72 16 78 30 H42 Q48 16 60 6 Z" fill="#F2453F" {O3}/>
<circle cx="60" cy="50" r="11" fill="#4FA8F0" {O3}/>
<path d="M46 84 Q52 104 60 114 Q68 104 74 84 Z" fill="#FFB020" {O3}/>''',

    '🚜': f'''<path d="M10 66 V50 Q10 44 16 44 H58 V30 Q58 24 64 24 H86 Q92 24 92 30 V66 Z" fill="#6CC24A" {O}/>
<rect x="64" y="30" width="22" height="20" rx="2" fill="#CDEBFF" {O3}/>
<path d="M30 44 V30" fill="none" stroke="{INKC}" stroke-width="5" stroke-linecap="round"/>
<circle cx="80" cy="82" r="22" {INK}/><circle cx="80" cy="82" r="10" fill="#FFC93C"/>{wheel(28, 90, 14)}''',

    '🚐': van('#FFFFFF', f'<rect x="22" y="40" width="20" height="16" rx="3" fill="#CDEBFF" {O3}/><rect x="48" y="40" width="20" height="16" rx="3" fill="#CDEBFF" {O3}/><path d="M10 66 H110" fill="none" stroke="#4FA8F0" stroke-width="5"/>'),

    '🚑': van('#FFFFFF', f'<path d="M36 46 H44 V38 H52 V46 H60 V54 H52 V62 H44 V54 H36 Z" fill="#F2453F" {O3}/><rect x="48" y="20" width="14" height="10" rx="3" fill="#4FA8F0" {O3}/>'),

    '🚚': f'''<rect x="8" y="24" width="68" height="56" rx="6" fill="#4FA8F0" {O}/>
<path d="M76 40 H96 L110 58 V80 H76 Z" fill="#F2453F" {O}/>
<path d="M82 46 H94 L102 58 H82 Z" fill="#CDEBFF" {O3}/>{wheel(28, 84)}{wheel(92, 84)}''',

    '🚒': f'''<path d="M8 80 V50 Q8 44 14 44 H72 V34 Q72 28 78 28 H92 Q98 28 102 36 L112 56 V80 Q112 86 106 86 H14 Q8 86 8 80 Z" fill="#F2453F" {O}/>
<path d="M80 34 H92 L100 52 H80 Z" fill="#CDEBFF" {O3}/>
<path d="M14 36 L66 22 M14 44 L66 30 M24 34 L22 42 M36 31 L34 39 M48 28 L46 36 M60 24 L58 32" fill="none" stroke="#B8C4D6" stroke-width="4" stroke-linecap="round"/>
<path d="M14 64 H106" fill="none" stroke="#FFFFFF" stroke-width="4"/><rect x="82" y="20" width="10" height="8" rx="2" fill="#4FA8F0" {O3}/>
{wheel(30, 88)}{wheel(90, 88)}''',

    '🚓': f'''<path d="M10 74 V62 Q12 52 24 50 H34 L44 34 Q47 30 53 30 H78 Q84 30 88 36 L98 50 Q110 52 110 62 V74 Q110 80 104 80 H16 Q10 80 10 74 Z" fill="#FFFFFF" {O}/>
<path d="M10 60 H110 V70 H10 Z" fill="#2D2A4A"/><path d="M48 36 H62 V50 H40 Z M68 36 H80 Q83 36 85 40 L90 50 H68 Z" fill="#CDEBFF" {O3}/>
<rect x="52" y="20" width="8" height="10" rx="2" fill="#F2453F" {O3}/><rect x="60" y="20" width="8" height="10" rx="2" fill="#4FA8F0" {O3}/>
<path d="M10 74 V62 Q12 52 24 50 H34 L44 34 Q47 30 53 30 H78 Q84 30 88 36 L98 50 Q110 52 110 62 V74 Q110 80 104 80 H16 Q10 80 10 74 Z" {L}/>
{wheel(34, 82)}{wheel(86, 82)}''',

    '🚕': f'''<path d="M10 74 V62 Q12 52 24 50 H34 L44 34 Q47 30 53 30 H78 Q84 30 88 36 L98 50 Q110 52 110 62 V74 Q110 80 104 80 H16 Q10 80 10 74 Z" fill="#FFD93D" {O}/>
<path d="M48 36 H62 V50 H40 Z M68 36 H80 Q83 36 85 40 L90 50 H68 Z" fill="#CDEBFF" {O3}/>
<rect x="50" y="18" width="20" height="10" rx="3" fill="#FFFFFF" {O3}/>
<path d="M16 62 h6 v6 h6 v-6 h6 v6 h6 v-6 h6" fill="none" stroke="{INKC}" stroke-width="3"/>{wheel(34, 82)}{wheel(86, 82)}''',

    '🚂': f'''<rect x="64" y="22" width="40" height="52" rx="6" fill="#F2453F" {O}/>
<rect x="72" y="30" width="24" height="18" rx="3" fill="#CDEBFF" {O3}/>
<path d="M14 74 V48 Q14 42 20 42 H64 V74 Z" fill="#4FA8F0" {O}/>
<path d="M22 42 V24 H36 V42" fill="#2D2A4A" {O3}/>
<path d="M28 18 Q20 8 30 4 Q40 0 44 8" fill="#E3EAF4" {O3}/>
<path d="M8 76 L14 66" {L}/>{wheel(28, 84, 10)}{wheel(56, 84, 10)}{wheel(88, 82, 14)}''',

    '🚆': f'''<rect x="24" y="10" width="72" height="88" rx="18" fill="#4FA8F0" {O}/>
<rect x="34" y="22" width="52" height="30" rx="6" fill="#CDEBFF" {O3}/>
<circle cx="40" cy="72" r="6" fill="#FFD93D" {O3}/><circle cx="80" cy="72" r="6" fill="#FFD93D" {O3}/>
<path d="M36 98 L24 114 M84 98 L96 114 M30 108 H90" {L}/>''',

    '🚁': f'''<path d="M14 18 H106 M60 18 V30" {L}/>
<path d="M90 60 H112 M108 50 V70" {L}/>
<path d="M20 64 Q20 32 56 32 Q90 32 94 60 Q94 84 60 86 Q20 86 20 64 Z" fill="#FFC93C" {O}/>
<path d="M28 60 Q30 40 54 40 V60 Z" fill="#CDEBFF" {O3}/>
<path d="M34 86 V100 M78 86 V100 M24 100 H90" {L}/>''',

    '🚢': f'''<path d="M10 70 H110 L96 98 H22 Z" fill="#F2453F" {O}/>
<path d="M10 70 H110 L106 80 H14 Z" fill="#FFFFFF"/>
<rect x="28" y="44" width="62" height="26" rx="4" fill="#FFFFFF" {O}/>
<g fill="#4FA8F0"><circle cx="40" cy="57" r="4"/><circle cx="56" cy="57" r="4"/><circle cx="72" cy="57" r="4"/></g>
<rect x="42" y="24" width="14" height="20" fill="#2D2A4A" {O3}/><rect x="64" y="24" width="14" height="20" fill="#2D2A4A" {O3}/>
<path d="M4 104 Q20 96 36 104 Q52 112 68 104 Q84 96 100 104 Q110 110 116 104" fill="none" stroke="#4FA8F0" stroke-width="4" stroke-linecap="round"/>''',

    '⛵': f'''<path d="M58 12 V80" {L}/>
<path d="M62 16 L100 74 H62 Z" fill="#FFFFFF" {O}/><path d="M54 26 L22 74 H54 Z" fill="#FFD93D" {O}/>
<path d="M14 80 H106 L94 102 H26 Z" fill="#8A5A3B" {O}/>
<path d="M4 108 Q20 100 36 108 Q52 116 68 108 Q84 100 100 108 Q110 114 116 108" fill="none" stroke="#4FA8F0" stroke-width="4" stroke-linecap="round"/>''',

    '🛷': f'''<path d="M10 82 H96 Q112 82 112 70" {L}/>
<path d="M30 62 V82 M76 62 V82" {L}/>
<rect x="18" y="46" width="76" height="18" rx="6" fill="#F2453F" {O}/>
<path d="M30 46 Q20 30 40 26" fill="none" stroke="#8A5A3B" stroke-width="4" stroke-linecap="round"/>''',

    '🛹': f'''<path d="M8 56 Q8 46 20 48 H100 Q112 46 112 56 Q112 64 100 64 H20 Q8 64 8 56 Z" fill="#8E5CF7" {O}/>
<path d="M30 52 L40 60 M56 52 L66 60 M82 52 L92 60" fill="none" stroke="#FFD93D" stroke-width="3" stroke-linecap="round"/>
{wheel(32, 76, 9)}{wheel(88, 76, 9)}''',

    '⛽': f'''<rect x="22" y="20" width="56" height="88" rx="8" fill="#F2453F" {O}/>
<rect x="32" y="32" width="36" height="26" rx="4" fill="#FFFFFF" {O3}/>
<path d="M78 40 Q100 40 98 60 V90 Q98 98 92 98 Q86 98 86 90 V74" {L}/>
<path d="M16 108 H84" {L}/>''',

    '🚩': f'''<path d="M30 112 V12" {L}/>
<path d="M32 14 Q60 6 70 18 Q82 28 102 22 V60 Q82 66 70 56 Q60 46 32 54 Z" fill="#F2453F" {O}/>''',

    '⚓': f'''<circle cx="60" cy="22" r="10" fill="none" stroke="{INKC}" stroke-width="5"/>
<path d="M60 32 V104 M40 48 H80 M18 70 Q22 104 60 104 Q98 104 102 70" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>
<path d="M10 76 L18 62 L28 74 M110 76 L102 62 L92 74" fill="none" stroke="{INKC}" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>''',

    '🔨': f'''<path d="M64 52 L28 104" fill="none" stroke="{INKC}" stroke-width="16" stroke-linecap="round"/>
<path d="M64 52 L28 104" fill="none" stroke="#C98A4A" stroke-width="9" stroke-linecap="round"/>
<path d="M44 34 L78 16 L104 44 L90 56 L78 44 L64 58 Z" fill="#9AA3B5" {O}/>''',

    '🛠️': f'''<path d="M30 92 L82 40" fill="none" stroke="{INKC}" stroke-width="15" stroke-linecap="round"/>
<path d="M30 92 L82 40" fill="none" stroke="#C98A4A" stroke-width="8" stroke-linecap="round"/>
<path d="M70 24 L94 12 L108 30 L96 40 L88 30 L78 42 Z" fill="#9AA3B5" {O3}/>
<path d="M28 28 L92 92" fill="none" stroke="{INKC}" stroke-width="13" stroke-linecap="round"/>
<path d="M28 28 L92 92" fill="none" stroke="#B8C4D6" stroke-width="6" stroke-linecap="round"/>
<path d="M18 16 Q8 28 18 38 Q28 44 36 36 L26 26 L30 16 Q24 10 18 16 Z" fill="#B8C4D6" {O3}/>''',

    '🔩': f'''<path d="M48 44 V104 Q48 110 60 110 Q72 110 72 104 V44 Z" fill="#B8C4D6" {O}/>
<path d="M48 56 L72 50 M48 68 L72 62 M48 80 L72 74 M48 92 L72 86" fill="none" stroke="{INKC}" stroke-width="2.5"/>
<path d="M30 20 L44 10 H76 L90 20 V36 L76 46 H44 L30 36 Z" fill="#9AA3B5" {O}/>''',

    '🔦': f'''<path d="M24 82 L64 42 L84 62 L44 102 Q36 110 28 102 L24 98 Q16 90 24 82 Z" fill="#4A4475" {O}/>
<path d="M64 42 L80 18 L108 46 L84 62 Z" fill="#9AA3B5" {O}/>
<path d="M80 18 L108 46" fill="none" stroke="#FFD93D" stroke-width="6" stroke-linecap="round"/>
<path d="M96 14 L108 4 M104 28 L118 22 M86 10 L90 2" fill="none" stroke="#FFB020" stroke-width="4" stroke-linecap="round"/>''',

    '🧲': f'''<path d="M20 20 H48 V62 Q48 76 60 76 Q72 76 72 62 V20 H100 V62 Q100 104 60 104 Q20 104 20 62 Z" fill="#F2453F" {O}/>
<path d="M20 20 H48 V38 H20 Z M72 20 H100 V38 H72 Z" fill="#E3EAF4" {O3}/>''',

    '🔋': f'''<rect x="16" y="34" width="80" height="52" rx="8" fill="#FFFFFF" {O}/>
<rect x="96" y="48" width="10" height="24" rx="3" fill="#B8C4D6" {O3}/>
<rect x="24" y="42" width="44" height="36" rx="4" fill="#6CC24A"/>
<path d="M40 52 H52 M46 46 V58 M74 60 H86" fill="none" stroke="{INKC}" stroke-width="3" stroke-linecap="round"/>''',

    '🔬': f'''<path d="M20 108 H100" {L}/>
<path d="M40 108 Q30 80 56 70" {L}/>
<path d="M44 20 L66 12 L86 66 L64 74 Z" fill="#4FA8F0" {O}/>
<rect x="56" y="74" width="22" height="10" rx="3" fill="#9AA3B5" {O3}/>
<path d="M70 84 V96 M54 96 H96" {L}/>''',

    '🌡️': f'''<path d="M50 74 V22 Q50 12 60 12 Q70 12 70 22 V74 Q84 82 82 96 Q78 110 60 110 Q42 110 38 96 Q36 82 50 74 Z" fill="#FFFFFF" {O}/>
<path d="M60 40 V82" fill="none" stroke="#F2453F" stroke-width="8" stroke-linecap="round"/>
<circle cx="60" cy="94" r="11" fill="#F2453F"/>
<path d="M74 30 H82 M74 44 H82 M74 58 H82" fill="none" stroke="{INKC}" stroke-width="3" stroke-linecap="round"/>''',

    '⏳': f'''<path d="M30 10 H90 M30 110 H90" fill="none" stroke="#8A5A3B" stroke-width="8" stroke-linecap="round"/>
<path d="M36 14 Q36 46 60 60 Q84 46 84 14 Z M36 106 Q36 74 60 60 Q84 74 84 106 Z" fill="#E3F2FF" {O}/>
<path d="M46 30 Q60 40 74 30 Q70 46 60 54 Q50 46 46 30 Z M44 104 Q50 84 60 80 Q70 84 76 104 Z" fill="#FFC93C"/>''',

    '⌚': f'''<rect x="44" y="6" width="32" height="26" rx="6" fill="#4A4475" {O3}/><rect x="44" y="88" width="32" height="26" rx="6" fill="#4A4475" {O3}/>
<circle cx="60" cy="60" r="32" fill="#FFFFFF" {O}/>
<path d="M60 40 V60 L74 68" {L}/><circle cx="60" cy="60" r="3.5" {INK}/>''',

    '🧭': f'''<circle cx="60" cy="60" r="46" fill="#FFC93C" {O}/><circle cx="60" cy="60" r="36" fill="#FFFFFF" {O3}/>
<path d="M60 28 L68 60 L60 92 L52 60 Z" fill="#FFFFFF" {O3}/><path d="M60 28 L68 60 H52 Z" fill="#F2453F" {O3}/>
<circle cx="60" cy="60" r="4" {INK}/>''',

    '📏': f'''<rect x="8" y="44" width="104" height="32" rx="4" fill="#FFD93D" {O}/>
<path d="M20 44 V58 M32 44 V54 M44 44 V58 M56 44 V54 M68 44 V58 M80 44 V54 M92 44 V58 M104 44 V54" fill="none" stroke="{INKC}" stroke-width="2.5"/>''',

    '📐': f'''<path d="M14 106 V14 L106 106 Z" fill="#FFC93C" {O}/>
<path d="M30 90 V52 L68 90 Z" fill="#FFF6E5" {O3}/>
<path d="M14 30 H22 M14 46 H26 M14 62 H22 M14 78 H26" fill="none" stroke="{INKC}" stroke-width="2.5"/>''',

    '✂️': f'''<circle cx="34" cy="86" r="16" fill="#F2453F" {O}/><circle cx="34" cy="86" r="7" fill="#FFFFFF" {O3}/>
<circle cx="86" cy="86" r="16" fill="#F2453F" {O}/><circle cx="86" cy="86" r="7" fill="#FFFFFF" {O3}/>
<path d="M44 74 L84 10 L66 62 Z M76 74 L36 10 L54 62 Z" fill="#D0D6E2" {O3}/>
<circle cx="60" cy="54" r="4" {INK}/>''',

    '🖍️': f'''<path d="M30 94 L82 30 L96 42 L44 106 Z" fill="#F2453F" {O}/>
<path d="M82 30 L94 12 L104 22 L96 42 Z" fill="#F7A1A1" {O3}/>
<path d="M44 76 L60 90 M56 62 L72 76" fill="none" stroke="#FFFFFF" stroke-width="4"/>
<path d="M30 94 L22 112 L44 106" fill="none" stroke="{INKC}" stroke-width="3" stroke-linejoin="round"/>''',

    '✏️': f'''<path d="M26 82 L80 28 L96 44 L42 98 Z" fill="#FFD93D" {O}/>
<path d="M80 28 L88 20 Q94 14 100 20 L104 24 Q110 30 104 36 L96 44 Z" fill="#F7A1B0" {O3}/>
<path d="M76 32 L92 48" fill="none" stroke="#B8C4D6" stroke-width="6"/>
<path d="M26 82 L16 106 L42 98 Z" fill="#F3D3A8" {O3}/><path d="M20 96 L16 106 L26 102 Z" {INK}/>''',

    '📖': f'''<path d="M60 30 Q36 18 10 24 V96 Q36 90 60 102 Z" fill="#FFFFFF" {O}/>
<path d="M60 30 Q84 18 110 24 V96 Q84 90 60 102 Z" fill="#FFFFFF" {O}/>
<path d="M20 42 Q36 38 50 44 M20 56 Q36 52 50 58 M20 70 Q36 66 50 72 M70 44 Q84 38 100 42 M70 58 Q84 52 100 56 M70 72 Q84 66 100 70" fill="none" stroke="#B8C4D6" stroke-width="3" stroke-linecap="round"/>
<path d="M10 96 Q36 90 60 102 Q84 90 110 96 V104 Q84 98 60 110 Q36 98 10 104 Z" fill="#4FA8F0" {O3}/>''',

    '📚': f'''<rect x="14" y="84" width="92" height="20" rx="4" fill="#F2453F" {O3}/>
<rect x="22" y="62" width="80" height="22" rx="4" fill="#4FA8F0" {O3}/>
<rect x="18" y="40" width="84" height="22" rx="4" fill="#6CC24A" {O3}/>
<rect x="28" y="18" width="68" height="22" rx="4" fill="#FFC93C" {O3}/>
<path d="M90 88 V100 M84 66 V80 M86 44 V58 M80 22 V36" fill="none" stroke="#FFFFFF" stroke-width="4" stroke-linecap="round"/>''',

    '📕': book('#F2453F'),
    '📓': book('#4A4475') + '<rect x="44" y="34" width="36" height="14" rx="3" fill="#FFFFFF" stroke="#2D2A4A" stroke-width="3"/>',
    '📘': book('#4FA8F0'),
    '📗': book('#6CC24A'),
    '📙': book('#FF9F2E'),

    '📄': f'''<path d="M26 10 H74 L96 32 V110 H26 Z" fill="#FFFFFF" {O}/>
<path d="M74 10 V32 H96" fill="#E3EAF4" {O3}/>
<path d="M38 50 H84 M38 64 H84 M38 78 H84 M38 92 H68" fill="none" stroke="#B8C4D6" stroke-width="4" stroke-linecap="round"/>''',

    '📬': f'''<path d="M60 112 V70" fill="none" stroke="{INKC}" stroke-width="12" stroke-linecap="round"/>
<path d="M60 112 V70" fill="none" stroke="#8A5A3B" stroke-width="6" stroke-linecap="round"/>
<path d="M20 74 V42 Q20 22 40 22 H86 Q100 22 100 40 V74 Z" fill="#4FA8F0" {O}/>
<path d="M40 22 Q56 22 56 42 V74" {L3}/>
<path d="M84 42 V14 H100 V24 H86" fill="#F2453F" {O3}/>
<rect x="32" y="8" width="28" height="18" rx="2" fill="#FFFFFF" {O3} transform="rotate(-10 46 17)"/>''',

    '📦': f'''<path d="M14 40 L60 22 L106 40 V92 L60 110 L14 92 Z" fill="#D9A066" {O}/>
<path d="M14 40 L60 58 L106 40 M60 58 V110" {L3}/>
<path d="M37 31 L83 49 V64 L91 60 V46" fill="none" stroke="#B57A44" stroke-width="5" stroke-linejoin="round"/>''',

    '🔒': f'''<path d="M38 52 V36 Q38 14 60 14 Q82 14 82 36 V52" fill="none" stroke="{INKC}" stroke-width="12"/>
<path d="M38 52 V36 Q38 14 60 14 Q82 14 82 36 V52" fill="none" stroke="#B8C4D6" stroke-width="6"/>
<rect x="24" y="50" width="72" height="58" rx="10" fill="#FFC93C" {O}/>
<circle cx="60" cy="74" r="7" {INK}/><path d="M60 78 V92" fill="none" stroke="{INKC}" stroke-width="6" stroke-linecap="round"/>''',

    '💡': f'''<path d="M42 78 Q26 64 28 44 Q32 14 60 12 Q88 14 92 44 Q94 64 78 78 V88 H42 Z" fill="#FFE14D" {O}/>
<rect x="42" y="88" width="36" height="20" rx="4" fill="#B8C4D6" {O3}/>
<path d="M42 96 H78" {L3}/><path d="M52 62 L56 40 L60 54 L64 40 L68 62" fill="none" stroke="#E0A020" stroke-width="3" stroke-linejoin="round"/>
<ellipse cx="44" cy="40" rx="5" ry="10" {SH}/>''',

    '🕯️': f'''<rect x="40" y="46" width="40" height="64" rx="5" fill="#FFF6E5" {O}/>
<path d="M60 46 V36" {L3}/>
<path d="M60 8 Q72 24 60 36 Q48 24 60 8 Z" fill="#FFB020" {O3}/>
<path d="M44 58 Q52 62 52 72" fill="none" stroke="#E8DCC4" stroke-width="4" stroke-linecap="round"/>''',

    '📱': f'''<rect x="32" y="8" width="56" height="104" rx="12" fill="#4A4475" {O}/>
<rect x="38" y="20" width="44" height="76" rx="4" fill="#CDEBFF"/>
<circle cx="60" cy="104" r="4" fill="#FFFFFF"/>
<g fill="#4FA8F0"><rect x="44" y="28" width="12" height="12" rx="3"/><rect x="64" y="28" width="12" height="12" rx="3"/><rect x="44" y="48" width="12" height="12" rx="3"/><rect x="64" y="48" width="12" height="12" rx="3"/></g>''',

    '📺': f'''<path d="M44 18 L60 30 L76 14" {L3}/>
<rect x="10" y="30" width="100" height="70" rx="12" fill="#8E5CF7" {O}/>
<rect x="20" y="40" width="68" height="50" rx="6" fill="#CDEBFF" {O3}/>
<circle cx="99" cy="50" r="4" {INK}/><circle cx="99" cy="66" r="4" {INK}/>
<path d="M30 100 L26 110 M90 100 L94 110" {L}/>''',

    '🗺️': f'''<path d="M8 26 L40 14 L80 26 L112 14 V94 L80 106 L40 94 L8 106 Z" fill="#FFF0C4" {O}/>
<path d="M40 14 V94 M80 26 V106" {L3}/>
<path d="M18 40 Q28 34 34 44 Q30 56 20 52 Z M50 50 Q66 40 72 56 Q62 70 52 62 Z M88 36 Q100 32 104 44 Q96 52 88 46 Z" fill="#8BD346" {O3}/>
<path d="M22 84 Q44 70 60 82 Q78 94 98 76" fill="none" stroke="#F2453F" stroke-width="3" stroke-dasharray="5 5" stroke-linecap="round"/>''',

    '🎁': f'''<rect x="14" y="48" width="92" height="22" rx="4" fill="#F2453F" {O}/>
<rect x="22" y="70" width="76" height="40" rx="4" fill="#F2453F" {O}/>
<path d="M52 48 V110 M68 48 V110" fill="none" stroke="#FFD93D" stroke-width="8"/>
<path d="M60 48 Q40 18 30 32 Q26 46 60 48 Q94 46 90 32 Q80 18 60 48 Z" fill="#FFD93D" {O3}/>''',

    '🧸': f'''<circle cx="34" cy="28" r="12" fill="#C98A5A" {O}/><circle cx="86" cy="28" r="12" fill="#C98A5A" {O}/>
<ellipse cx="60" cy="88" rx="30" ry="26" fill="#C98A5A" {O}/>
<ellipse cx="60" cy="90" rx="16" ry="14" fill="#F3D3A8"/>
<circle cx="24" cy="80" r="10" fill="#C98A5A" {O}/><circle cx="96" cy="80" r="10" fill="#C98A5A" {O}/>
<circle cx="60" cy="44" r="27" fill="#C98A5A" {O}/>
<ellipse cx="60" cy="54" rx="11" ry="8" fill="#F3D3A8" {O3}/><ellipse cx="60" cy="50" rx="4" ry="3" {INK}/>
{eyes(50, 70, 40, 3.4)}
<path d="M48 70 L60 64 L72 70 L60 76 Z" fill="#F2453F" {O3}/>''',

    '🪑': f'''<path d="M30 10 V62 M90 10 V62" {L}/>
<rect x="30" y="12" width="60" height="30" rx="6" fill="#C98A4A" {O}/>
<rect x="22" y="58" width="76" height="14" rx="5" fill="#C98A4A" {O}/>
<path d="M30 72 V112 M90 72 V112" fill="none" stroke="{INKC}" stroke-width="8" stroke-linecap="round"/>''',

    '🛏️': f'''<path d="M10 40 V104 M110 70 V104 M10 92 H110" fill="none" stroke="{INKC}" stroke-width="7" stroke-linecap="round"/>
<rect x="14" y="66" width="94" height="22" rx="6" fill="#4FA8F0" {O}/>
<rect x="18" y="52" width="30" height="16" rx="8" fill="#FFFFFF" {O3}/>
<path d="M50 66 Q60 54 104 60 V70 H50 Z" fill="#8E5CF7" {O3}/>''',

    '🛁': f'''<path d="M22 54 V30 Q22 16 36 16 Q46 16 46 26" {L}/>
<path d="M10 56 H110 V70 Q110 98 82 98 H38 Q10 98 10 70 Z" fill="#FFFFFF" {O}/>
{blob([(30, 52, 9), (46, 46, 11), (64, 48, 10), (82, 46, 11), (96, 52, 9)], '#E3F2FF')}
<path d="M30 98 L26 110 M90 98 L94 110" {L}/>''',

    '🧼': f'''<rect x="16" y="54" width="88" height="46" rx="18" fill="#FF8FC0" {O}/>
<path d="M30 66 Q60 58 90 66" fill="none" stroke="#FFFFFF" stroke-width="4" stroke-linecap="round" stroke-opacity="0.7"/>
<circle cx="44" cy="34" r="12" fill="#E3F2FF" {O3}/><circle cx="74" cy="24" r="9" fill="#E3F2FF" {O3}/><circle cx="92" cy="40" r="6" fill="#E3F2FF" {O3}/>''',

    '🧽': f'''<rect x="16" y="34" width="88" height="56" rx="10" fill="#FFD93D" {O}/>
<path d="M16 72 H104 V80 Q104 90 94 90 H26 Q16 90 16 80 Z" fill="#6CC24A" {O3}/>
<g fill="#E8B92A"><circle cx="34" cy="48" r="4"/><circle cx="56" cy="56" r="5"/><circle cx="80" cy="46" r="4"/><circle cx="90" cy="60" r="3"/></g>''',

    '🧺': f'''<path d="M30 52 Q30 14 60 14 Q90 14 90 52" fill="none" stroke="{INKC}" stroke-width="11"/>
<path d="M30 52 Q30 14 60 14 Q90 14 90 52" fill="none" stroke="#C98A4A" stroke-width="5"/>
<path d="M12 50 H108 L98 106 H22 Z" fill="#E0A060" {O}/>
<path d="M22 66 H98 M24 82 H96 M40 50 L44 106 M60 50 V106 M80 50 L76 106" fill="none" stroke="#B5762A" stroke-width="3"/>''',

    '☂️': f'''<path d="M60 56 V100 Q60 110 50 110 Q42 110 42 102" {L}/>
<path d="M10 58 Q12 18 60 16 Q108 18 110 58 Q100 50 90 58 Q80 50 70 58 Q60 50 50 58 Q40 50 30 58 Q20 50 10 58 Z" fill="#8E5CF7" {O}/>
<path d="M60 16 Q46 34 50 58 M60 16 Q74 34 70 58" {L3}/>
<path d="M60 16 V8" {L}/>''',

    '🎒': f'''<path d="M44 30 Q44 12 60 12 Q76 12 76 30" fill="none" stroke="{INKC}" stroke-width="7"/>
<rect x="20" y="28" width="80" height="84" rx="20" fill="#F2453F" {O}/>
<rect x="34" y="70" width="52" height="32" rx="8" fill="#FF8C7A" {O3}/>
<path d="M34 82 H86" {L3}/><path d="M20 56 Q60 66 100 56" {L3}/>''',

    '💍': f'''<circle cx="60" cy="74" r="34" fill="none" stroke="{INKC}" stroke-width="14"/>
<circle cx="60" cy="74" r="34" fill="none" stroke="#FFC93C" stroke-width="7"/>
<path d="M44 26 L52 14 H68 L76 26 L60 42 Z" fill="#9AD0FF" {O3}/>
<path d="M44 26 H76" {L3}/>''',

    '👑': f'''<path d="M14 40 L36 66 L60 26 L84 66 L106 40 L96 96 H24 Z" fill="#FFC93C" {O}/>
<path d="M24 82 H96" {L3}/>
<circle cx="14" cy="38" r="6" fill="#FFC93C" {O3}/><circle cx="60" cy="22" r="6" fill="#FFC93C" {O3}/><circle cx="106" cy="38" r="6" fill="#FFC93C" {O3}/>
<circle cx="40" cy="89" r="4" fill="#F2453F"/><circle cx="60" cy="89" r="4" fill="#4FA8F0"/><circle cx="80" cy="89" r="4" fill="#6CC24A"/>''',

    '🧶': f'''<path d="M88 90 Q106 104 114 92" {L3}/>
<circle cx="58" cy="60" r="42" fill="#FF6F9E" {O}/>
<path d="M22 46 Q58 30 94 50 M18 64 Q56 50 98 72 M28 86 Q60 70 88 92 M40 22 Q30 60 50 100 M66 18 Q50 60 74 100" fill="none" stroke="#D94A7E" stroke-width="3" stroke-linecap="round"/>''',

    '⚖️': f'''<path d="M60 14 V100 M32 108 H88 M20 32 H100" {L}/>
<path d="M20 32 L8 66 M20 32 L32 66 M100 32 L88 66 M100 32 L112 66" fill="none" stroke="{INKC}" stroke-width="2.5"/>
<path d="M4 66 H36 Q34 80 20 80 Q6 80 4 66 Z M84 66 H116 Q114 80 100 80 Q86 80 84 66 Z" fill="#FFC93C" {O3}/>
<circle cx="60" cy="14" r="6" fill="#FFC93C" {O3}/>''',

    '🥅': f'''<path d="M10 100 V30 H110 V100" {L}/>
<path d="M10 30 L24 44 H96 L110 30 M24 44 V100 M96 44 V100" fill="none" stroke="{INKC}" stroke-width="3"/>
<path d="M36 44 V100 M48 44 V100 M60 44 V100 M72 44 V100 M84 44 V100 M24 58 H96 M24 72 H96 M24 86 H96" fill="none" stroke="#B8C4D6" stroke-width="2"/>''',
}
