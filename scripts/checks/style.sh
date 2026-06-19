#!/usr/bin/env bash
# Factor `style`: comprobaciones de estilo portables y sin dependencias
# (tabuladores, espacios al final de línea, longitud de línea). Pensado como
# no-bloqueante; ampliable a gnatcheck/gnatformat. Ver docs/coding_standard.md.
set -u
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

TAB="$(printf '\t')"
fail=0
dirs=(src tests examples)

echo "[style] tabuladores"
if grep -rn "$TAB" --include='*.ads' --include='*.adb' "${dirs[@]}" 2>/dev/null; then
  echo "  -> hay tabuladores (usa 3 espacios)"; fail=1
fi

echo "[style] espacios al final de línea"
if grep -rnE ' +$' --include='*.ads' --include='*.adb' "${dirs[@]}" 2>/dev/null; then
  echo "  -> hay espacios sobrantes"; fail=1
fi

echo "[style] líneas de más de 100 columnas"
if grep -rnE '.{101,}' --include='*.ads' --include='*.adb' "${dirs[@]}" 2>/dev/null; then
  echo "  -> líneas demasiado largas"; fail=1
fi

[ "$fail" -eq 0 ] && echo "[style] OK"
exit "$fail"
