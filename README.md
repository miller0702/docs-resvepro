# EGW Writings — Documentación técnica

Repositorio central de arquitectura, contratos API y guías del MVP **Plan Plata**.

## Repositorios de la plataforma

Cada componente vive en su **propio repositorio Git**. Ver [REPOS.md](./REPOS.md) para el mapa completo y el flujo de desarrollo local.

| Repositorio | Descripción |
|-------------|-------------|
| **egw-docs** (este) | Arquitectura, OpenAPI, roles, variables de entorno |
| **egw-api** | Backend NestJS + Prisma + PostgreSQL |
| **egw-admin** | Panel administrativo React + Vite |
| **egw-mobile** | App Expo React Native |

## Índice de documentos

| Documento | Contenido |
|-----------|-----------|
| [AGENTS.md](./AGENTS.md) | Guía para agentes de IA y Cursor |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Diagramas y decisiones técnicas |
| [DATABASE.md](./DATABASE.md) | Modelo ER e índices |
| [API.md](./API.md) | Convenciones REST |
| [ROLES.md](./ROLES.md) | Roles y permisos |
| [ENV.md](./ENV.md) | Entornos development / production |
| [ROADMAP.md](./ROADMAP.md) | Etapas del MVP |
| [openapi.yaml](./openapi.yaml) | Contrato OpenAPI v1 |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | Flujo de trabajo multi-repo |

## Inicio rápido

Clona los cuatro repositorios en una misma carpeta padre (opcional):

```
~/proyectos/egw/
├── egw-docs/
├── egw-api/
├── egw-admin/
└── egw-mobile/
```

Luego sigue [REPOS.md#desarrollo-local](./REPOS.md#desarrollo-local) y [ENV.md](./ENV.md).

Abre [egw.code-workspace](../egw.code-workspace) en Cursor/VS Code para tener los cuatro repos en un solo workspace.

### Levantar todo el stack

Desde la carpeta `docs/` (o desde `EGW/` con el atajo del root):

```bash
cd docs
pnpm install          # solo la primera vez (instala concurrently)
pnpm setup            # install en api/admin/mobile + migrate + seed
pnpm dev:all          # API :8000, Admin :8002, Mobile Metro :8003
```

Atajos individuales: `pnpm dev:api`, `pnpm dev:admin`, `pnpm dev:mobile`.

Alternativa sin scripts: `bash scripts/dev-all.sh`

En Cursor: **Terminal → Run Task → EGW: dev:all**

**Cursor:** cada repo incluye `AGENTS.md` y reglas en `.cursor/rules/` para guiar al agente de IA.

**Gestor de paquetes:** [pnpm](https://pnpm.io) en api, admin y mobile (`pnpm install` en cada repo).
