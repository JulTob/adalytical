# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.1.0/);
versionado [SemVer](https://semver.org/lang/es/).

## [0.2.0] — sin publicar

### Añadido
- **Visualización SVG** (`Adalytical.SVG`): constructor de documentos vectoriales
  sin dependencias (primitivas, `viewBox`, serialización a fichero).
- **Capa de plots tipados** (`Adalytical.Plots`): interfaz `Plottable` (backbone
  híbrido) y `Adalytical.Plots.Series_Line` — el diagrama base de una serie es un
  line plot, genérico sobre el motor + una función `To_Float`.
- Fachada `Easy.Reals`: `Plot`, `Save`, `To_SVG_String`, subtipos `Figure`/`Plot_Style`.
- Suite de tests SVG (28/28) y ejemplo `examples/visualizacion.adb`.
- **Diagramas type-driven**: `Adalytical.Plots.Histogram` (vector indexado por
  enum -> barras) y `Adalytical.Plots.Graph` (matriz de adyacencia -> grafo de
  nodos/aristas); `Plot_Graph` en la fachada. Tests 35/35; ejemplo
  `examples/viz_diagramas.adb`.

## [0.1.0] — sin publicar

Primera rebanada vertical: cimientos + arquitectura de tres capas demostrada
de extremo a extremo, con la maquinaria de revisión por factores.

### Añadido
- **Capa 1 — Álgebra** (`Adalytical.Algebra`): firmas genéricas `Field`,
  `Ordered_Field`, `Analytic_Field` (las "reglas del juego").
- **Capa 2 — Instancia de referencia** (`Adalytical.Algebra.Reals`): los reales
  de doble precisión como cuerpo ordenado y analítico.
- **Capa 3 — Motor** (`Adalytical.Variables`): el operando abstracto `Variable`
  (interfaz con dispatch) con sabores `Constant`, `Analytic`, `Discrete` y
  composición algebraica perezosa (`+`, `-`, `*`, escalado, negación).
- `Adalytical.Statistics.Descriptive`: suma, media, varianza (solo cuerpo).
- `Adalytical.Signals`: impulso, escalón, convolución discreta (Signals & Systems).
- `Adalytical.Systems`: interfaz `System` con dispatch; FIR y ganancia.
- `Adalytical.Linear_Algebra`: vectores/matrices y `Solve`/`Determinant`
  sobre `Generic_Real_Arrays` (frontera documentada no-SPARK).
- **Fachada** `Adalytical.Easy.Reals`: todo preinstanciado, sin genéricos a la
  vista; sabor `Sinusoid` y `Std_Dev` (vía `Analytic_Field`).
- Arnés de tests propio + 23 comprobaciones; 3 ejemplos ejecutables.
- **Revisión por factores**: `review/factors.toml`, `scripts/review.sh`,
  `scripts/checks/*.sh` y workflow CI (un job por factor).
- Documentación: `README`, `docs/Design.md`, `docs/coding_standard.md`,
  `docs/cookbook.md`, `AUDITORIA_CRUZADA.md`, `STATUS.md`, `CONTRIBUTING.md`.
