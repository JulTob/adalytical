# AUDITORÍA CRUZADA — proceso de validez y no-contradicción

Define el proceso para que spec, cuerpo, tests, ejemplos, prueba y documentación
**cuenten la misma historia**. Complementa a `STATUS.md` (ownership) y a la
maquinaria de factores (`review/factors.toml`, `scripts/review.sh`).

## 1. Fuentes de verdad por artefacto

| Artefacto | Fuente primaria | Regla |
|---|---|---|
| Contrato de una unidad | `*.ads` (spec + `Pre`/`Post`) | Es la verdad de la API. |
| Comportamiento | `*.adb` | Debe cumplir el contrato del spec. |
| Corrección numérica | `tests/` | Cifras con tolerancia explícita. |
| Demostración (opcional) | `gnatprove` (factor `proof`) | No reescribe el contrato; lo verifica. |
| Ejemplos | `examples/` | Deben compilar y reflejar la API real. |
| Narrativa/arquitectura | `docs/Design.md` | Explica el porqué; no sustituye checks. |
| Estado / ownership | `STATUS.md` | Decide quién toca qué, no validez técnica. |

Si un documento (README, cookbook) muestra código, ese código debe corresponder
a la API vigente; si no, es una contradicción S1.

## 2. Severidades

| Sev | Criterio | Acción |
|---|---|---|
| **S0** Bloqueante | Rompe build/tests/contratos o invalida una garantía pública. | `CONFLICT-*`, bloquear entrega. |
| **S1** Alta | Spec y cuerpo/tests/docs discrepan; ejemplo que no compila. | Ticket de corrección antes de entregar. |
| **S2** Media | Lenguaje ambiguo, alcance no declarado, contrato laxo. | Corregir o anotar en limitaciones. |
| **S3** Baja | Estilo, etiqueta, trazabilidad. | Agrupar en limpieza. |

## 3. Roles (corrección cruzada)

| Rol | Responsabilidad |
|---|---|
| Autor | Aplica el cambio en un único archivo. |
| Revisor cruzado | Comprueba que no contradice otro artefacto (idealmente, otro agente). |
| Validador | Ejecuta `scripts/review.sh` y registra resultado/commit. |
| Integrador | Actualiza `STATUS.md` y cierra el ticket. |

Un agente no valida como "revisión cruzada" su propio cambio salvo `self-check`.
Si dos discrepan, se abre `CONFLICT-*` con una decisión requerida.

## 4. Puerta de publicación

Una entrega puede cerrarse solo si:
- `scripts/review.sh` da `GATE: PASS` sobre los factores bloqueantes;
- no hay `CONFLICT-*` activo;
- las discrepancias S0/S1 están cerradas; las S2 abiertas figuran en limitaciones;
- los ejemplos compilan y los tests pasan;
- el commit final queda registrado en `STATUS.md`.

## 5. Plantilla de hallazgo

```text
ID:
Severidad:
Artefactos en conflicto:
Contrato/cifra afectada:
Fuente primaria aceptada:
Decisión requerida:
Ticket de corrección:
Revisor cruzado:
Validación (review.sh / commit):
Estado:
```
