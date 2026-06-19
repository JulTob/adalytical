#!/usr/bin/env bash
# Factor `contracts`: build con aserciones/contratos activos (-gnata -gnatVa) y
# ejecución. Una violación de Pre/Post/Type_Invariant aborta el runner -> FAIL.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
# shellcheck source=/dev/null
. "$ROOT/scripts/env.sh"

echo "[contracts] gprbuild con -gnata -gnatVa (contratos en runtime)"
log="$(mktemp)"
# shellcheck disable=SC2086
alr -n exec -- gprbuild -f -p -P adalytical_tests.gpr -cargs -gnata -gnatVa $ADALYTICAL_LINK_ARGS >"$log" 2>&1
code=$?
grep -vE "$ADALYTICAL_NOISE" "$log" || true
rm -f "$log"
if [ "$code" -ne 0 ]; then
  echo "[contracts] fallo de compilación"
  exit "$code"
fi

echo "[contracts] ejecutando con contratos activos"
./bin/test_runner
exit $?
