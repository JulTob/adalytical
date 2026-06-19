#!/usr/bin/env bash
# Factor `build`: la librería compila limpiamente con warnings-as-errors.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
# shellcheck source=/dev/null
. "$ROOT/scripts/env.sh"

echo "[build] gprbuild adalytical.gpr  (-gnat2022 -gnatwa -gnatwe)"
log="$(mktemp)"
alr -n exec -- gprbuild -f -p -P adalytical.gpr -cargs -gnatwe >"$log" 2>&1
code=$?
grep -vE "$ADALYTICAL_NOISE" "$log" || true
rm -f "$log"
exit "$code"
