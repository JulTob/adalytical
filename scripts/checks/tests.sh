#!/usr/bin/env bash
# Factor `tests`: compila el arnés y ejecuta la batería; falla si algún test falla.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
# shellcheck source=/dev/null
. "$ROOT/scripts/env.sh"

echo "[tests] gprbuild adalytical_tests.gpr"
log="$(mktemp)"
# shellcheck disable=SC2086
alr -n exec -- gprbuild -p -P adalytical_tests.gpr $ADALYTICAL_LINK_ARGS >"$log" 2>&1
code=$?
grep -vE "$ADALYTICAL_NOISE" "$log" || true
rm -f "$log"
if [ "$code" -ne 0 ]; then
  echo "[tests] fallo de compilación"
  exit "$code"
fi

echo "[tests] ejecutando bin/test_runner"
./bin/test_runner
exit $?
