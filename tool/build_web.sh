#!/bin/sh
# Builds the web app with the Supabase settings baked in.
#   ./tool/build_web.sh           build only (output: build/web)
#   ./tool/build_web.sh deploy    build and publish to Cloudflare
#                                 (https://little-learners.little-learners.workers.dev)
set -e
cd "$(dirname "$0")/.."
flutter build web --release --dart-define-from-file=supabase.env.json
if [ "$1" = "deploy" ]; then
  npx --yes wrangler@4 deploy
else
  echo "Ready to deploy: $(pwd)/build/web   (run with 'deploy' to publish)"
fi
