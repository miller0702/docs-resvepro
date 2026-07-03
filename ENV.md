# Variables de entorno y configuración

La plataforma usa **archivos de configuración TypeScript** por ambiente, no múltiples `.env`.

## Estructura

Cada repo tiene:

```
src/config/environments/
├── types.ts
├── development.ts    ← valores de desarrollo (commiteado)
├── production.ts     ← valores de producción (commiteado)
└── index.ts          ← getConfig() según EGW_ENV
```

## Selección de ambiente

| Variable | Valores | Default |
|----------|---------|---------|
| `EGW_ENV` | `development` \| `production` | `development` |

En **egw-admin**, Vite también respeta `import.meta.env.MODE` al hacer build.

## Puertos en desarrollo

| Servicio | Puerto | URL |
|----------|--------|-----|
| **egw-api** | `8000` | http://localhost:8000/api/v1 |
| **egw-admin** | `8002` | http://localhost:8002 |
| **egw-mobile** (Metro/Expo) | `8003` | `pnpm start:dev` |

La API acepta CORS desde admin (`8002`) y la app (`8003`). Admin y mobile apuntan a la API en `http://localhost:8000/api/v1` vía `development.ts`.

## Gestor de paquetes

**pnpm** en `egw-api`, `egw-admin` y `egw-mobile`. Instala dependencias con `pnpm install` (no `npm install`).

## Comandos

### Orquestación (desde egw-docs)

| Comando | Descripción |
|---------|-------------|
| `pnpm setup` | install en api/admin/mobile + migrate + seed |
| `pnpm dev:all` | API + admin + mobile en paralelo |
| `pnpm dev:api` | Solo API (:8000) |
| `pnpm dev:admin` | Solo admin (:8002) |
| `pnpm dev:mobile` | Solo Metro/Expo (:8003) |

Desde la carpeta padre `EGW/`: mismos comandos vía `pnpm dev:all` (delega en docs).

### egw-api

| Desarrollo | Producción |
|------------|------------|
| `pnpm dev` | `pnpm build:prod && pnpm start:prod` |
| `pnpm prisma:migrate:dev` | `pnpm prisma:migrate:prod` |
| `pnpm prisma:seed:dev` | `pnpm prisma:seed:prod` |

### egw-admin

| `pnpm dev` | `pnpm build` |

### egw-mobile

| `pnpm start:dev` | `pnpm start:prod` |

## egw-api — `src/config/environments/`

| Campo | Descripción |
|-------|-------------|
| `postgres.*` | Conexión PostgreSQL (Render, GCP, etc.) |
| `jwt.*` | Secretos y expiración de tokens |
| `corsOrigins` | Orígenes permitidos separados por coma |
| `gcs.*` | Bucket GCS para archivos grandes (videos); vacío = solo inline + URLs externas |
| `media.inlineMaxBytes` | Tamaño máx. para guardar en base64 en PostgreSQL (default 5 MB) |
| `mongodb.uri` | Conexión MongoDB para feed social (posts, comentarios, reacciones) |

### MongoDB (feed comunitario)

Posts, comentarios y reacciones viven en **MongoDB** (Mongoose), no en PostgreSQL. Desarrollo local:

```bash
# macOS con Homebrew
brew services start mongodb-community
```

URI por defecto en `development.ts`: `mongodb://127.0.0.1:27017/egw_community`

En producción, define `MONGODB_URI` en el entorno de despliegue o en `production.ts`.

### Almacenamiento multimedia

| Tamaño | Estrategia | Endpoint |
|--------|------------|----------|
| ≤ `inlineMaxBytes` | Base64 en PostgreSQL | `POST /media/upload` |
| > límite o videos | URL externa (GCS, CDN, enlace) | `POST /media/external` |

No se usa disco local (`uploadDir`). El contenido inline se sirve en `GET /media/:id/content`.

En producción, `production.ts` puede leer overrides de `process.env` del proveedor de deploy.

## egw-admin — `src/config/environments/`

| Campo | Descripción |
|-------|-------------|
| `apiUrl` | Base URL de la API |
| `appName` | Nombre del panel |

## egw-mobile — `src/config/environments/`

| Campo | Descripción |
|-------|-------------|
| `apiUrl` | Base URL de la API |
| `appName` | Nombre de la app |

> En dispositivo físico (development), cambia `apiUrl` a la IP de tu máquina.

## Editar configuración

1. **Desarrollo**: edita `development.ts` en cada repo
2. **Producción**: edita `production.ts` con hosts y dominios reales
3. **Secretos en deploy**: usa variables del proveedor; `production.ts` de la API las lee con `process.env`

No se requieren archivos `.env` para el flujo normal.
