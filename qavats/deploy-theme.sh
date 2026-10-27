#!/usr/bin/env bash
# Deploys themes/qavats to id (over the tailnet; public SSH is closed), clears the gzip cache and
# restarts the identity manager, which caches themes in production mode. Sign-in is unavailable
# for every app for the minute the restart takes. From the repo root or anywhere:
#   qavats/deploy-theme.sh
set -euo pipefail
cd "$(dirname "$0")"
COPYFILE_DISABLE=1 rsync -a --delete --exclude .DS_Store themes/qavats/ ash@id:/opt/keycloak/current/themes/qavats/
ssh ash@id '
  rm -rf /opt/keycloak/current/data/tmp/kc-gzip-cache/*/{login,admin,account,email}/qavats
  sudo systemctl restart keycloak
  for _ in $(seq 1 60); do
    curl -sf -o /dev/null https://id.qavatsit.com/realms/main/.well-known/openid-configuration && break
    sleep 2
  done
  echo "identity manager: $(systemctl is-active keycloak)"'
