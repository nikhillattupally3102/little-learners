#!/bin/sh
# Prints recent feedback (default: last 30 days). Usage: ./tool/feedback.sh [days]
# Needs FEEDBACK_READER_TOKEN in supabase.env.json (see supabase/migrations/004).
cd "$(dirname "$0")/.."
DAYS="${1:-30}"
python3 -I - "$DAYS" <<'PY'
import json, sys, urllib.request, datetime
cfg = json.load(open('supabase.env.json'))
since = (datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=int(sys.argv[1]))).isoformat()
req = urllib.request.Request(
    cfg['SUPABASE_URL'] + '/rest/v1/rpc/read_feedback',
    data=json.dumps({'reader_token': cfg['FEEDBACK_READER_TOKEN'], 'since': since}).encode(),
    headers={'apikey': cfg['SUPABASE_ANON_KEY'], 'Content-Type': 'application/json'})
rows = json.load(urllib.request.urlopen(req))
print(f'{len(rows)} feedback item(s) in the last {sys.argv[1]} days\n')
for r in rows:
    c = r.get('context') or {}
    bits = [r['created_at'][:16].replace('T', ' '), r['kind'], f"{r['rating']}★" if r.get('rating') else '',
            c.get('worksheet_kind', ''), c.get('level') or c.get('child_level', ''), c.get('platform', ''), r['status']]
    print(' · '.join(b for b in bits if b))
    if r.get('message'): print('   ', r['message'].replace('\n', '\n    '))
    if r.get('contact'): print('    reply to:', r['contact'])
PY
