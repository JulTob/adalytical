# Adalytical

Librería de **análisis matemático y estadístico en Ada**, construida sobre la
idea que distingue a Ada: que un experto de dominio —ingeniero, economista,
analista— escriba **la matemática de su campo** con corrección garantizada por
el tipado, sin tener que saber informática ni cruzar niveles de abstracción.

> Estado: **v0.1.0 (cimientos)**. Esta entrega es una rebanada vertical que
> demuestra la arquitectura completa de extremo a extremo (compila, pasa tests,
> ejemplos ejecutables) y la maquinaria de revisión. El alcance funcional crece
> por tickets en [`STATUS.md`](STATUS.md).

## Idea central

El objeto fundamental es la **`Variable`**: *cualquier cosa que respeta las
reglas del juego (el álgebra)* — el papel que el vector juega en R o la matriz
en Matlab, pero más abstracto. Una `Variable` puede encarnarse como datos
discretos, una función analítica, una entidad estocástica o (en el futuro) una
función generalizada como la delta de Dirac. Una **`Signal`** es su
especialización sobre un dominio ordenado/temporal (marco *Signals & Systems*).

## Arquitectura en tres capas

| Capa | Qué es | Quién la toca |
|---|---|---|
| **1 — Álgebra** (`Adalytical.Algebra.*`) | Firmas genéricas `Field`, `Ordered_Field`, `Analytic_Field`: los axiomas que un tipo debe cumplir. | Diseñador de la librería |
| **2 — Tu tipo** | Declaras tu tipo e instancias un álgebra (o usas una ya hecha). | El experto de dominio |
| **3 — Motor** (`Adalytical.Variables`, `.Signals`, `.Systems`, `.Statistics`, `.Linear_Algebra`) | `Variable`/`Signal`, sistemas LTI, estadística, álgebra lineal. Genérico sobre el álgebra. | Oculto |
| **Fachada** (`Adalytical.Easy.Reals`) | Todo preinstanciado para los reales; sin genéricos a la vista. | El usuario, vía `use` |

Detalle de diseño y decisiones en [`docs/Design.md`](docs/Design.md).

## Instalación

Requiere [Alire](https://alire.ada.dev) (`alr`) con un toolchain GNAT + gprbuild.

```sh
# macOS (Apple Silicon): binario oficial (no está en Homebrew)
curl -sSL -o /tmp/alr.zip \
  https://github.com/alire-project/alire/releases/download/v2.1.1/alr-2.1.1-bin-aarch64-macos.zip
unzip -o /tmp/alr.zip -d /tmp/alr-dl && cp /tmp/alr-dl/bin/alr ~/.local/bin/

# Toolchain
alr toolchain --select gnat_native gprbuild
```

> **macOS reciente**: GNAT/FSF no detecta el SDK y el enlazado falla con
> `ld: library not found for -lSystem`. Los scripts del repo lo resuelven
> automáticamente (`-Wl,-syslibroot,$(xcrun --show-sdk-path)` vía
> [`scripts/env.sh`](scripts/env.sh)). En Linux/CI no hace falta nada.

## Uso rápido

```ada
with Ada.Text_IO;            use Ada.Text_IO;
with Adalytical.Easy.Reals;  use Adalytical.Easy.Reals;

procedure Demo is
   S : constant Quantity := 2.0 * Sine (Frequency => 1.0) + Value (0.5);
   D : constant Series   := Sample_On_Grid (S, T0 => 0.0, Dt => 0.01, N => 100);
begin
   Put_Line ("Media: " & Mean (D)'Image);
   Put_Line ("Std:   " & Std_Dev (D)'Image);
end Demo;
```

Ver [`examples/`](examples/): `analisis_basico` (técnico),
`modelo_produccion` (experto de dominio, sin genéricos) y `tipo_propio`
(declarar tu propio tipo). Recetas paso a paso en
[`docs/cookbook.md`](docs/cookbook.md).

```sh
bash scripts/checks/tests.sh   # compila y ejecuta los tests
bash scripts/review.sh         # ejecuta todos los factores de revisión
```

## Revisión por factores independientes

La calidad se evalúa por **factores independientes** que **tú controlas**: en
[`review/factors.toml`](review/factors.toml) decides, por factor, si se ejecuta
(`enabled`) y si bloquea la entrega (`blocking`). `scripts/review.sh` ejecuta
los activos y calcula el `GATE` **solo** sobre los bloqueantes; CI corre cada
factor como un job separado.

| Factor | Por defecto | Qué comprueba |
|---|---|---|
| `build` | enabled, **blocking** | Compila con warnings-as-errors |
| `tests` | enabled, **blocking** | Batería de tests |
| `contracts` | enabled, **blocking** | Contratos en runtime (`-gnata`) |
| `style` | enabled, no-blocking | Tabs / espacios / longitud de línea |
| `proof` | disabled | Demostración SPARK (`gnatprove`) — opt-in |
| `coverage` | disabled | Cobertura (`gnatcov`) — opt-in |
| `docs` | disabled | API docs (`gnatdoc`) — opt-in |

Proceso de auditoría cruzada y puertas de publicación en
[`AUDITORIA_CRUZADA.md`](AUDITORIA_CRUZADA.md).

## Verificación y SPARK

Toda API pública lleva contratos Ada 2022 y se escribe en estilo **SPARK-ready**:
no imponemos prueba formal global, pero el usuario final puede activar el factor
`proof` y obtener "demostración por código" en sus dominios críticos. La
frontera no analizable (llamadas a LAPACK en `Linear_Algebra`) está documentada.

## Licencia

[MIT](LICENSE).
