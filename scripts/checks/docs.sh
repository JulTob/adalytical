#!/usr/bin/env bash
# Factor `docs` (OPT-IN): genera documentación de API con gnatdoc si está
# disponible. Si no, se omite.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
# shellcheck source=/dev/null
. "$ROOT/scripts/env.sh"

if ! alr -n exec -- sh -c 'command -v gnatdoc' >/dev/null 2>&1; then
  echo "[docs] gnatdoc no instalado — omitido."
  exit 0
fi

echo "[docs] gnatdoc -P adalytical.gpr"
alr -n exec -- gnatdoc -P adalytical.gpr
exit $?
