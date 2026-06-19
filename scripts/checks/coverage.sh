#!/usr/bin/env bash
# Factor `coverage` (OPT-IN): cobertura con gnatcov. Si no está instalado, omite.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
# shellcheck source=/dev/null
. "$ROOT/scripts/env.sh"

if ! alr -n exec -- sh -c 'command -v gnatcov' >/dev/null 2>&1; then
  echo "[coverage] gnatcov no instalado — omitido."
  exit 0
fi

echo "[coverage] gnatcov (instrumentación + ejecución del runner)"
echo "        (configuración detallada pendiente; ver STATUS.md)"
exit 0
