#!/usr/bin/env bash
# Entorno común para los scripts de build y revisión de Adalytical.
#  - Pone `alr` (y por tanto el toolchain GNAT) en el PATH.
#  - En macOS calcula el flag de enlazado al SDK: GNAT/FSF no detecta el SDK en
#    macOS reciente y falla con `ld: library not found for -lSystem`. La raíz del
#    SDK se pasa con -Wl,-syslibroot. En Linux/CI la variable queda vacía.
#  - Define un patrón para filtrar ruido de gprbuild/alr en la salida.

export PATH="$HOME/.local/bin:$PATH"

ADALYTICAL_LINK_ARGS=""
if [ "$(uname)" = "Darwin" ] && command -v xcrun >/dev/null 2>&1; then
  _sdk="$(xcrun --show-sdk-path 2>/dev/null)"
  if [ -n "$_sdk" ]; then
    ADALYTICAL_LINK_ARGS="-largs -Wl,-syslibroot,$_sdk"
  fi
fi
export ADALYTICAL_LINK_ARGS

export ADALYTICAL_NOISE='overriding deployment version|^Note:|Synchronizing workspace|Nothing to update|^$'
