# Design — Adalytical

## 1. Propósito y filosofía

Adalytical persigue el objetivo histórico de Ada: que un experto de dominio
exprese la matemática de su campo con seguridad de tipos, **aislado de la
complejidad de implementación**. El concepto unificador es la **`Variable`**:
"cualquier cosa que respeta las reglas del juego (el álgebra)". Generaliza al
vector de R o la matriz de Matlab. Una **`Signal`** es una `Variable` sobre un
dominio ordenado/temporal (marco *Signals & Systems*).

## 2. Arquitectura de tres capas

```
Capa 1  Adalytical.Algebra.*      firmas genéricas (Field, Ordered_Field, Analytic_Field)
Capa 2  el tipo del usuario        declara su tipo + instancia un álgebra
Capa 3  Adalytical.Variables, .Signals, .Systems, .Statistics, .Linear_Algebra
Fachada Adalytical.Easy.Reals      todo preinstanciado, sin genéricos visibles
```

### 2.1 El álgebra como contrato (Capa 1)

Las firmas son *signature packages* genéricos. Un tipo "entra al juego"
instanciándolas; los operandos por defecto (`is <>`) toman los operadores
directamente visibles del tipo, así que para tipos numéricos la instanciación es
inmediata. Las firmas son **planas** (autocontenidas) en lugar de componerse
unas de otras, para que el motor acceda a `F.Element`, `F."+"`, etc. sin
selectores anidados; la jerarquía Field ⊂ Ordered_Field ⊂ Analytic_Field es
conceptual.

**Verdad arquitectónica clave**: un cuerpo abstracto solo ofrece `+ - * /` y
(si es ordenado) el orden. Las operaciones trascendentes (`sqrt`, `sin`, `exp`)
**no** son expresables con operaciones de cuerpo y exigen `Analytic_Field`. Por
eso `Variance` (solo `/`) es genérica sobre cuerpo ordenado, pero `Std_Dev`
(`sqrt`) y el generador `Sine` viven donde hay un `Analytic_Field` (la fachada).

### 2.2 El motor `Variable` (Capa 3): estrategia híbrida

`Variable` es una **interfaz** (dispatch dinámico) con sabores concretos:

- `Constant_Variable` — ignora el dominio.
- `Analytic_Variable` — envuelve una función `Scalar -> Scalar`.
- `Discrete_Variable` — muestras en rejilla uniforme; `Evaluate` por vecino
  más cercano (búsqueda lineal usando solo el orden, sin convertir a entero).

La **composición es perezosa**: `+`, `-`, `*` y el escalado construyen nodos
(`Composite_Variable`, `Scaled_Variable`) que almacenan sus operandos en
`Ada.Containers.Indefinite_Holders (Variable'Class)` y se evalúan despachando.
Esto da expresiones encadenables y "no definidas a priori" sin gestión manual de
memoria. Como Ada no tiene closures, los sabores con parámetros capturados (p.
ej. `Sinusoid`) son tipos etiquetados que guardan sus datos e implementan
`Evaluate` — la forma idiomática del closure en Ada.

La capa de dispatch/perezosa queda, por diseño, fuera de SPARK; los sabores
puros (`Constant`, `Discrete`) y la estadística se mantienen demostrables.

### 2.3 Signals & Systems

`Adalytical.Signals` añade los generadores estructurales (impulso, escalón) y la
convolución discreta. `Adalytical.Systems` define la interfaz `System` con la
primitiva despachante `Apply : System × Signal → Signal` (FIR y ganancia como
sistemas LTI concretos). Es el "polimorfismo de retorno" señal→señal.

### 2.4 Álgebra lineal y la frontera no-SPARK

`Adalytical.Linear_Algebra` delega en `Ada.Numerics.Generic_Real_Arrays`
(matrices densas, `Solve`, `Determinant`). Su cuerpo es la **frontera** no
analizable por SPARK; el resto de la librería permanece demostrable.

## 3. Estrategia de verificación: SPARK-ready, no SPARK-mandatorio

Contratos Ada 2022 en toda API pública. No se impone prueba formal global; el
factor `proof` (opt-in, [`review/factors.toml`](../review/factors.toml)) permite
al usuario correr `gnatprove` y obtener "demostración por código" en sus
dominios críticos. La disciplina restrictiva en la base habilita esa
flexibilidad arriba.

## 4. Build y revisión

- Crate Alire `adalytical`, sin dependencias externas (build determinista).
- Ada 2022 (`-gnat2022`); el factor `build` exige warnings-as-errors (`-gnatwe`).
- Tests con arnés propio mínimo (migrable a AUnit).
- En macOS, el enlazado necesita la raíz del SDK (`scripts/env.sh` lo gestiona).

## 5. Hoja de ruta (resumen; tickets en STATUS.md)

Sabor `Generalized`/Dirac y perezoso completo, FFT, filtros IIR, transformada Z,
distribuciones de probabilidad, inferencia, optimización, E/S (CSV/WAV), más
álgebras (cuerpos finitos, intervalos/fuzzy). La interfaz `Variable` está
diseñada para admitir estos sabores sin reescribir el núcleo.
