# Contribuir a Adalytical

## Principios

1. **El usuario de dominio es lo primero.** Toda función pública debe poder
   usarse sin entender los genéricos internos. Si una API obliga a cruzar capas
   de abstracción, está mal diseñada.
2. **El álgebra es el contrato.** Una operación nueva debe declarar qué álgebra
   exige (cuerpo / cuerpo ordenado / cuerpo analítico) y vivir en la capa que
   corresponde. No metas `sqrt` en algo que solo necesita `+`.
3. **Contratos siempre.** Cada subprograma público lleva `Pre`/`Post`/
   `Type_Invariant` cuando aplique, en estilo SPARK-ready.
4. **Sin contradicciones.** Spec, cuerpo, tests, ejemplos y docs deben contar la
   misma historia (ver [`AUDITORIA_CRUZADA.md`](AUDITORIA_CRUZADA.md)).

## Flujo de trabajo (tablero de tickets)

El trabajo se coordina por tickets `T-XXX` en [`STATUS.md`](STATUS.md):

- Reserva un ticket moviéndolo a `Processing` con `owner` + `scope` (un solo
  archivo/ruta) antes de editar.
- Un agente/persona = un ticket activo = un archivo en uso.
- Si tu cambio toca un archivo ya reservado, abre `CONFLICT-*` en vez de editar.

## Roles de revisión (auditoría cruzada)

| Rol | Responsabilidad |
|---|---|
| **Autor** | Aplica el cambio en un único archivo. |
| **Revisor cruzado** | Comprueba que no contradice otro artefacto. Idealmente, otra persona/agente. |
| **Validador** | Ejecuta `scripts/review.sh` y registra el resultado. |
| **Integrador** | Actualiza `STATUS.md` y cierra el ticket. |

Un autor no valida su propio cambio como "revisión cruzada" salvo que lo marque
`self-check`.

## Puerta de entrega

Antes de cerrar un ticket:

```sh
bash scripts/review.sh
```

Debe dar **`GATE: PASS`** sobre los factores bloqueantes. Tú decides en
[`review/factors.toml`](review/factors.toml) qué factores bloquean en tu dominio
(por ejemplo, activar `proof` como bloqueante en código crítico).

## Estilo

Ada 2022, indentación de 3 espacios, líneas ≤ 100 columnas, sin tabuladores.
Detalle en [`docs/coding_standard.md`](docs/coding_standard.md).
