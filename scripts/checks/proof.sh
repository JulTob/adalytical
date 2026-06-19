#!/usr/bin/env bash
# Factor `proof` (OPT-IN): demostración SPARK con gnatprove sobre los módulos
# puros. Si gnatprove no está instalado, se omite (la librería está escrita en
# estilo SPARK-ready para que el usuario final pueda activarlo en sus dominios).
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
# shellcheck source=/dev/null
. "$ROOT/scripts/env.sh"

if ! command -v gnatprove >/dev/null 2>&1 \
   && ! alr -n exec -- sh -c 'command -v gnatprove' >/dev/null 2>&1; then
  echo "[proof] gnatprove no instalado — omitido."
  echo "        Instálalo (p. ej. 'alr -n install gnatprove') y reactiva el factor."
  exit 0
fi

echo "[proof] gnatprove sobre adalytical.gpr (flow + pruebas)"
alr -n exec -- gnatprove -P adalytical.gpr --level=1 --checks-as-errors=on
exit $?
