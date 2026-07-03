# Guía de contribución

## Repositorios independientes

Cada componente es un **repositorio Git propio**:

- `egw-docs` — documentación (este repo)
- `egw-api` — backend
- `egw-admin` — panel web
- `egw-mobile` — app móvil

No subas código de la API al repo de mobile, ni al revés. Los cambios de contrato API se documentan aquí (`openapi.yaml`, `API.md`) y se implementan en `egw-api`.

## Commits (Conventional Commits)

```
feat(api): add book chapters endpoint
fix(mobile): sync bookmark timestamp
docs: update ENV variables
```

Tipos: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## Entornos (development / production)

Cada repo define la config en `src/config/environments/`. Edita `development.ts` o `production.ts` según el ambiente. Detalle en [ENV.md](./ENV.md).

## Gestor de paquetes

Usamos **pnpm** en todos los repos con código (`egw-api`, `egw-admin`, `egw-mobile`). No uses `npm install` salvo herramientas puntuales que lo exijan.

```bash
corepack enable   # una vez en tu máquina
pnpm install
```

Cada `package.json` declara `"packageManager": "pnpm@10.24.0"` para que Corepack use la versión correcta.

## Flujo de trabajo local

Requiere clonar los repos que vayas a tocar. Ver [REPOS.md](./REPOS.md).

### Opción rápida (recomendada)

Desde **egw-docs** (`docs/`):

```bash
pnpm install
pnpm setup      # install + migrate + seed en egw-api
pnpm dev:all    # levanta api, admin y mobile en paralelo
```

| Servicio | Puerto | URL |
|----------|--------|-----|
| egw-api | 8000 | http://localhost:8000/api/v1 |
| egw-admin | 8002 | http://localhost:8002 |
| egw-mobile | 8003 | Metro / Expo |

También puedes ejecutar desde la carpeta padre `EGW/`: `pnpm dev:all` (delega en docs).

### Opción manual

Orden recomendado:

1. **egw-api** — `pnpm install` → `pnpm prisma:migrate:dev` → `pnpm prisma:seed:dev` → `pnpm dev` (puerto **8000**)
2. **egw-admin** — `pnpm install` → `pnpm dev` (puerto **8002**)
3. **egw-mobile** — `pnpm install` → `pnpm start:dev` (Metro puerto **8003**)

## Calidad

- No commitear secretos de producción reales en `production.ts` si el repo es público
- Actualizar `openapi.yaml` si cambias endpoints públicos
- Probar admin y mobile contra la API en development antes de abrir PR
- **egw-mobile:** estados de carga en cards/listas → skeleton ([MOBILE-UI.md](./MOBILE-UI.md)); no texto «Cargando...» ni spinners centrados
