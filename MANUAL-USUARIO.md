# Manuales de usuario — RESVEPRO

Guías orientadas a **personas que usan el producto** (no a desarrolladores).

| Manual | Para quién | Dónde se muestra |
|--------|------------|------------------|
| [App móvil](./MANUAL-USUARIO-APP.md) | Lectores | App → menú → **Manual de usuario** |
| [Panel web](./MANUAL-USUARIO-PANEL.md) | Equipo editorial y operaciones | Panel → **Manual del panel** |

El texto que ven los usuarios se edita en el panel (**App móvil → Manual**) y se guarda para la app y para el propio panel. Los archivos Markdown de este repositorio son una referencia ampliada para el equipo.

## Nota para el equipo técnico (no mostrar a usuarios finales)

Al cambiar el seed del manual en la API, actualiza `MANUAL_SEED_VERSION` en `manual-sections.seed.ts` para refrescar el contenido base. Las credenciales de prueba de entornos locales no deben aparecer en los manuales productivos.
