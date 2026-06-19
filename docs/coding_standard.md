# Estándar de código — Adalytical

## Lenguaje y compilación
- **Ada 2022** (`-gnat2022`). Usa agregados de array con corchetes `[...]`.
- El factor `build` compila con `-gnatwa -gnatwe` (todos los warnings = error).
  Si un warning es legítimo e inevitable (p. ej. formales no usados en un
  *signature package*), siléncialo **localmente** con
  `pragma Warnings (Off, "...")` y un comentario, nunca globalmente.

## Formato
- Indentación de **3 espacios**, sin tabuladores.
- Líneas ≤ **100 columnas**.
- Sin espacios al final de línea; salto de línea final presente.
- (Verificado por el factor `style`; ver `.editorconfig`.)

## Nomenclatura
- Unidades en minúsculas con `-` para hijas: `adalytical-easy-reals.ads`.
- Identificadores `Mixed_Case_With_Underscores`.

## Contratos (obligatorios en API pública)
- `Pre` / `Post` para precondiciones y resultados; `Pre'Class` en primitivas
  despachantes; `Type_Invariant` cuando un tipo mantenga una invariante.
- Escribe en estilo **SPARK-ready**: contratos explícitos, sin excepciones
  ocultas, fronteras no-SPARK aisladas y documentadas (`SPARK_Mode => Off` o un
  comentario claro, como en `Linear_Algebra`).

## Capas y álgebra
- Declara qué álgebra exige cada operación y colócala en su capa:
  - solo `+ - * /` → cuerpo (`Field`);
  - además orden → `Ordered_Field`;
  - además `sqrt`/`sin`/`exp`/... → `Analytic_Field`.
- El motor (Capa 3) no debe asumir más álgebra de la necesaria.

## Documentación
- Cabecera de cada unidad: qué hace y en qué capa vive.
- Comentarios en el *porqué*, no en el *qué* obvio.
