# AGENTS.md — egw-docs

Guía para agentes de IA que trabajan en el repositorio de documentación de **EGW Writings** (Plan Plata MVP).

## Rol de este repositorio

Este repo es la **fuente de verdad** del diseño de la plataforma. No contiene código ejecutable. Define arquitectura, contrato API, modelo de datos, roles y guías de contribución para los demás repos.

| Repositorio | Responsabilidad |
|-------------|-----------------|
| **egw-docs** (este) | Documentación y OpenAPI |
| **egw-api** | Backend NestJS + Prisma + PostgreSQL |
| **egw-admin** | Panel administrativo React + Vite |
| **egw-mobile** | App Expo React Native |

No es un monorepo. Cada componente tiene su propio Git, CI/CD y despliegue.

## Mapa de documentos

| Archivo | Cuándo consultarlo / actualizarlo |
|---------|-----------------------------------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Decisiones técnicas, diagramas, flujos auth/offline |
| [DATABASE.md](./DATABASE.md) | Modelo ER; actualizar si cambia `prisma/schema.prisma` en egw-api |
| [API.md](./API.md) | Convenciones REST (formato respuesta, paginación, códigos HTTP) |
| [openapi.yaml](./openapi.yaml) | Contrato OpenAPI v1; **obligatorio** actualizar al cambiar endpoints públicos |
| [ROLES.md](./ROLES.md) | Matriz RBAC y usuarios seed |
| [ENV.md](./ENV.md) | Puertos, config por ambiente, comandos pnpm |
| [MOBILE-UI.md](./MOBILE-UI.md) | Skeletons, estados de carga, caché React Query en biblioteca |
| [REPOS.md](./REPOS.md) | Clonado local, dependencias entre repos |
| [ROADMAP.md](./ROADMAP.md) | Estado del MVP y etapas pendientes |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Commits, flujo multi-repo, calidad |
| [MANUAL-USUARIO.md](./MANUAL-USUARIO.md) | Índice de manuales para usuarios finales |
| [MANUAL-USUARIO-APP.md](./MANUAL-USUARIO-APP.md) | Manual de la app móvil (lectores) |
| [MANUAL-USUARIO-PANEL.md](./MANUAL-USUARIO-PANEL.md) | Manual del panel web (equipo editorial) |

## Reglas para agentes

1. **Cambios de contrato API** → actualizar `openapi.yaml` y, si aplica, `API.md` aquí; implementar en `egw-api`.
2. **Cambios de schema** → reflejar en `DATABASE.md` y en el schema Prisma de egw-api.
3. **Nuevos permisos o roles** → actualizar `ROLES.md`.
4. **Nuevas variables o puertos** → actualizar `ENV.md` y los `development.ts` / `production.ts` de cada repo afectado.
5. No inventar endpoints ni entidades que no estén documentados o en el schema sin alinear con el resto de la plataforma.
6. Commits: [Conventional Commits](https://www.conventionalcommits.org/) con prefijo `docs:` (ej. `docs: add sync push schema`).

Consulta también `.cursor/rules/` en este repo para reglas automáticas de Cursor.

## Plataforma en contexto

- Base URL API: `http://localhost:8000/api/v1`
- Puertos dev: API `8000`, Admin `8002`, Mobile Metro `8003`
- Gestor de paquetes: **pnpm** en api, admin y mobile
- Auth: JWT Bearer; refresh cada 15 min
- IDs: UUID v4
- i18n: no incluido en Plan Plata

## Workspace local recomendado

```
~/egw/
├── egw-docs/
├── egw-api/
├── egw-admin/
└── egw-mobile/
```

Abrir los cuatro como multi-root workspace en Cursor/VS Code facilita cambios coordinados. Usa [egw.code-workspace](../egw.code-workspace) en la carpeta padre.

## Reglas de Cursor

Cada repo tiene `.cursor/rules/` con reglas que se activan automáticamente:

| Repo | Reglas |
|------|--------|
| egw-docs | `platform.mdc`, `openapi-contract.mdc`, `conventional-commits.mdc` |
| egw-api | `platform.mdc`, `nestjs-modules.mdc`, `prisma-schema.mdc`, `conventional-commits.mdc` |
| egw-admin | `platform.mdc`, `react-pages.mdc`, `conventional-commits.mdc` |
| egw-mobile | `platform.mdc`, `expo-screens.mdc`, `conventional-commits.mdc` |

Las reglas `platform.mdc` aplican siempre; el resto se activa al editar archivos del stack correspondiente.
