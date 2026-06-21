# Tablero operativo — Adalytical

Última actualización: 2026-06-19 (claude)
Fuente narrativa y plan: `docs/Design.md`
Regla: no editar archivos de un `scope` sin ticket en `Processing` con reserva
(`owner` + `scope`). Puerta de cierre: `scripts/review.sh` → `GATE: PASS`.

## Board rápido

| Agente | Ticket | Archivo en uso | Próxima |
|---|---|---|---|
| claude | ninguno | - | — |

### Reglas de reserva
- Mover ticket a `Processing` antes de editar; un agente = un ticket = un archivo.
- Reserva: `owner`, `scope`, `started_at`, `handoff_notes`.
- Solape de scope → abrir `CONFLICT-*`, no editar.
- Conflictos activos: ninguno.

---

## Done — cimientos v0.1.0 (rebanada vertical)

| Ticket | Descripción | Evidencia |
|---|---|---|
| T-001 | Toolchain Alire 2.1.1 + GNAT 15.1.2 + gprbuild | `alr --version` |
| T-002 | Scaffolding del crate (manifiesto, 3 GPR, .gitignore, .editorconfig) | repo |
| T-003 | Capa 1 — firmas `Field`/`Ordered_Field`/`Analytic_Field` | `src/algebra/` |
| T-004 | Capa 2 — instancia `Reals` | `src/algebra/adalytical-algebra-reals.ads` |
| T-005 | Capa 3 — motor `Variable` (híbrido, composición perezosa) | `src/variables/` |
| T-006 | `Signals`, `Systems`, `Statistics`, `Linear_Algebra` | `src/{signals,systems,stats,linalg}/` |
| T-007 | Fachada `Easy.Reals` (sin genéricos visibles) + `Sinusoid` | `src/easy/` |
| T-008 | Arnés de tests propio + 23 comprobaciones | `tests/`, 23/23 PASS |
| T-009 | Maquinaria de revisión por factores + CI | `review/`, `scripts/`, `.github/` |
| T-010 | Documentación de proceso y README | `README.md`, `docs/`, `AUDITORIA_CRUZADA.md` |
| T-011 | Ejemplos ejecutables (técnico, dominio, tipo propio) | `examples/` |
| T-012 | Build + verificación + commit inicial | `scripts/review.sh` GATE PASS |

## Done — visualización v0.2 (rama `claude/visualizacion-svg`)

| Ticket | Descripción | Evidencia |
|---|---|---|
| T-201 | Núcleo SVG sin dependencias (`Adalytical.SVG`) | `src/svg/` |
| T-202 | Capa de plots híbrida: `Plottable` + `Series_Line` (line plot type-driven) | `src/plots/` |
| T-203 | Integración en fachada (`Plot`/`Save`/`Figure`) + tests + ejemplo | `Easy.Reals`, 28/28 PASS, `examples/visualizacion.adb` |
| T-204 | Histograma type-driven (vector indexado por enum) | `src/plots/...-histogram`, 35/35 PASS |
| T-205 | Grafo type-driven (matriz de adyacencia) | `src/plots/...-graph`, `Plot_Graph` en fachada |
| T-207 | Animación SVG nativa (SMIL `<animate>`) | `Animated_Circle`, `examples/viz_animacion.adb` |
| T-206 | Scatter, stem y ejes con ticks | `Series_Line` (Series_Kind), `Stem`/`Scatter` en fachada |

---

## Backlog — hoja de ruta (no reclamado)

| Ticket | Descripción | Notas |
|---|---|---|
| T-101 | Sabor `Generalized`/Dirac (sifting) y perezoso completo | la interfaz `Variable` ya lo admite |
| T-102 | FFT radix-2 y análisis espectral (PSD, ventanas) | `Adalytical.Transforms` |
| T-103 | Filtros IIR / biquad como sistemas LTI | `Adalytical.Systems.Filters` |
| T-104 | Distribuciones de probabilidad (PDF/CDF/quantile) | sobre `Analytic_Field` |
| T-105 | Inferencia: tests de hipótesis, estimadores | |
| T-106 | Optimización (mínimos cuadrados, descenso) | usa `Linear_Algebra` |
| T-107 | E/S de datos: CSV y WAV | |
| T-108 | Cablear factor `coverage` (gnatcov) | `scripts/checks/coverage.sh` |
| T-109 | Demostrar con `gnatprove` los módulos puros (factor `proof`) | Variables/Statistics |
| T-110 | Migrar arnés de tests a AUnit (opcional) | |
| T-111 | Más álgebras: cuerpos finitos, intervalos/fuzzy, complejos | `Adalytical.Algebra.*` |
| T-112 | Covarianza/correlación, cuantiles, momentos | ampliar `Statistics.Descriptive` |
| T-208 | Cablear todos los diagramas vía dispatch `Plottable` | coherencia híbrida |
| T-209 | Leyenda multi-serie y superposición de series | `Adalytical.Plots.*` |

---

## Plantillas de comunicación
- `CLAIM <id> | owner=<x> | scope=<ruta>`
- `DONE-CHECK <id> | review=GATE_PASS | commit=<sha>`
- `CONFLICT <id> | scope=<ruta> | requiere=<decisión>`
