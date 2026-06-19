#!/usr/bin/env bash
# Agregador de revisión por factores independientes.
#
#   scripts/review.sh            -> ejecuta todos los factores activos
#   scripts/review.sh build      -> ejecuta solo el factor indicado
#
# Lee review/factors.toml (control del usuario: enabled/blocking por factor),
# ejecuta cada factor activo de forma aislada, y calcula GATE únicamente sobre
# los factores BLOQUEANTES. Código de salida != 0 solo si falla un bloqueante.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
FACTORS="$ROOT/review/factors.toml"
ONLY="${1:-}"

parse() {
  awk '
    function val(l){ sub(/^[^=]*=[ \t]*/,"",l); gsub(/^[ \t]+|[ \t]+$/,"",l);
                     gsub(/^"|"$/,"",l); return l }
    /^\[factor\./ { name=$0; sub(/^\[factor\./,"",name); sub(/\][ \t]*$/,"",name);
                    en="";bl="";de="";c=""; next }
    /^[ \t]*enabled[ \t]*=/     { en=val($0); next }
    /^[ \t]*blocking[ \t]*=/    { bl=val($0); next }
    /^[ \t]*description[ \t]*=/ { de=val($0); next }
    /^[ \t]*cmd[ \t]*=/         { c=val($0); print name "|" en "|" bl "|" c "|" de; next }
  ' "$FACTORS"
}

declare -a R_NAME R_EN R_BL R_RES
gate=0

while IFS='|' read -r name en bl cmd desc; do
  [ -n "$ONLY" ] && [ "$ONLY" != "$name" ] && continue
  if [ "$en" != "true" ]; then
    R_NAME+=("$name"); R_EN+=("$en"); R_BL+=("-"); R_RES+=("SKIP")
    continue
  fi
  echo "=================================================================="
  echo ">>> factor: $name  [blocking=$bl]  — $desc"
  echo "------------------------------------------------------------------"
  if bash "$ROOT/$cmd"; then res="PASS"; else res="FAIL"; fi
  if [ "$res" = "FAIL" ] && [ "$bl" = "true" ]; then gate=1; fi
  R_NAME+=("$name"); R_EN+=("$en"); R_BL+=("$bl"); R_RES+=("$res")
done < <(parse)

echo
echo "================= RESUMEN DE FACTORES ============================="
printf "%-12s %-8s %-9s %-6s\n" "FACTOR" "ENABLED" "BLOCKING" "RESULT"
for i in "${!R_NAME[@]}"; do
  printf "%-12s %-8s %-9s %-6s\n" \
    "${R_NAME[$i]}" "${R_EN[$i]}" "${R_BL[$i]}" "${R_RES[$i]}"
done
echo "------------------------------------------------------------------"
if [ "$gate" -eq 0 ]; then
  echo "GATE: PASS  (sobre factores bloqueantes)"
else
  echo "GATE: FAIL  (falló al menos un factor bloqueante)"
fi
exit "$gate"
