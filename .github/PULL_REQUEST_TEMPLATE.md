<!-- Codifica los roles de auditoría cruzada (ver AUDITORIA_CRUZADA.md). -->

## Ticket
<!-- T-XXX en STATUS.md -->

## Cambio
<!-- Qué y por qué. Capa(s) afectada(s). Álgebra exigida si aplica. -->

## Auditoría cruzada
- [ ] **Autor**: cambio en scope acotado.
- [ ] **Revisor cruzado**: no contradice spec / cuerpo / tests / ejemplos / docs.
- [ ] **Validador**: `scripts/review.sh` → `GATE: PASS` (pegar resumen de factores).
- [ ] **Integrador**: `STATUS.md` actualizado, ticket cerrado.

## Resultado de factores
```
<!-- pegar la tabla RESUMEN DE FACTORES de scripts/review.sh -->
```

## Contratos / verificación
- [ ] API pública con `Pre`/`Post` cuando aplica, estilo SPARK-ready.
- [ ] Fronteras no-SPARK (si las hay) documentadas.
