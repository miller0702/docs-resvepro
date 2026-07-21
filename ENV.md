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
| `pnpm docker:up` | — (Cloud Run) |

#### Docker local (desarrollo)

En `egw-api` hay `docker-compose.yml` + `Dockerfile.dev` (hot-reload con volúmenes).

| Comando | Qué levanta |
|---------|-------------|
| `pnpm docker:up` | API (:8000) + Mongo 7 (:27017). **Postgres = Render** (`development.ts`) |
| `pnpm docker:up:db` | Postgres local + Mongo (perfil `local-db`; API con `pnpm dev` o override manual) |
| `pnpm docker:seed` | Seed contra la DB que use la API (por defecto Render) |
| `pnpm docker:down` | Detiene servicios (incluye perfil `local-db`) |

Por defecto la API en Compose **no** apunta a Postgres del contenedor: usa el host de Render de `development.ts`. Mongo sí es el del Compose (`MONGODB_URI=mongodb://mongo:27017/resvepro`).

Si el puerto 27017 (o 5432 con `local-db`) ya está ocupado en tu Mac, para esos servicios o cambia el mapeo en `docker-compose.yml`.

**Cloud Run (GCP proyecto `resvepro`):** dos servicios con el mismo código API (`egw-api`):

| Cliente | Servicio Cloud Run | URL base |
|---------|-------------------|----------|
| **Mobile** | `api-resvepro-app` | `https://api-resvepro-app-1046799880752.us-west1.run.app/api/v1` |
| **Admin (web)** | `api-resvepro-web` | `https://api-resvepro-web-1046799880752.us-west1.run.app/api/v1` |

El `Dockerfile` usa **pnpm** (`pnpm-lock.yaml`). Al arrancar ejecuta `prisma migrate deploy` y luego la API.

Variables mínimas en **cada** servicio Cloud Run:

| Variable | Ejemplo |
|----------|---------|
| `EGW_ENV` | `production` |
| `DATABASE_URL` | URI Session pooler Supabase |
| `MONGODB_URI` | Atlas `/resvepro` |
| `JWT_SECRET` / `JWT_REFRESH_SECRET` | secretos fuertes |
| `CORS_ORIGINS` | En **api-resvepro-web**: `https://resvepro.web.app,https://resvepro.firebaseapp.com` |

Cloud Run inyecta `PORT` (normalmente `8080`); la API lo respeta automáticamente.

### egw-admin (Firebase Hosting)

| Comando | Descripción |
|---------|-------------|
| `pnpm dev` | Desarrollo local (:8002) |
| `pnpm build` | Build estático → `dist/` |
| `pnpm deploy:firebase` | Build + `firebase deploy --only hosting` |

**Proyecto Firebase:** `resvepro` → **https://resvepro.web.app** (también `https://resvepro.firebaseapp.com`).

El admin **no usa Firebase SDK** (auth, Firestore, etc.); solo Firebase **Hosting** para servir el build estático. La autenticación sigue siendo JWT vía la API NestJS.

**Primera vez:**

```bash
cd resvepro-admin
pnpm install
pnpm exec firebase login
pnpm exec firebase use resvepro
cp env.production.example .env.production
pnpm deploy:firebase
```

Si Hosting aún no está activo: [Firebase Console → resvepro → Hosting](https://console.firebase.google.com/project/resvepro/hosting) → **Comenzar**.

> `pnpm deploy` es un comando reservado de pnpm; usa **`pnpm deploy:firebase`**.

La API en Cloud Run debe incluir `https://resvepro.web.app` y `https://resvepro.firebaseapp.com` en `CORS_ORIGINS`.

### egw-mobile (EAS Build)

| Comando | Descripción |
|---------|-------------|
| `pnpm start:dev` | Metro desarrollo (:8003) |
| `pnpm start:prod` | Metro con config producción |
| `pnpm build:preview:android` | APK preview → API prod (Cloud Run app) |
| `pnpm build:preview:ios` | IPA preview (TestFlight interno) |

**Proyecto Expo:** [@miller07/resvepro](https://expo.dev/accounts/miller07/projects/resvepro)

Perfil **`preview`** en `eas.json`:
- `EGW_ENV=production`
- `EXPO_PUBLIC_API_URL=https://api-resvepro-app-1046799880752.us-west1.run.app/api/v1`
- Android: **`buildType: apk`** (instalable directo, sin Play Store)

**Primera vez:**

```bash
cd resvepro-mobile
pnpm install
pnpm exec eas login
pnpm build:preview:android
```

EAS genera el keystore Android si no existe. Al terminar, descarga el APK desde el enlace de Expo o:

```bash
pnpm exec eas build:list --platform android --limit 1
```

Credencial seed prod: `lector@resvepro.local` / `Lector123!` (si corriste `prisma:seed:prod`).

## egw-api — `src/config/environments/`

| Campo | Descripción |
|-------|-------------|
| `postgres.*` | Conexión PostgreSQL (Render, GCP, etc.) |
| `jwt.*` | Secretos y expiración de tokens |
| `corsOrigins` | Orígenes permitidos separados por coma |
| `gcs.bucket` | Bucket GCS canónico (`media-resvepro`); vacío = fallback inline local |
| `gcs.keyFile` | Ruta a JSON de service account (opcional si usas ADC / Cloud Run) |
| `gcs.publicBaseUrl` | Base pública opcional (CDN). Si vacío: `https://storage.googleapis.com/{bucket}` |
| `media.inlineMaxBytes` | Fallback sin GCS: máx. base64 en PostgreSQL (default 5 MB) |
| `media.maxUploadBytes` | Tope duro de subida a GCS; `0` = sin límite (recomendado) |
| `mongodb.uri` | Conexión MongoDB para feed social (posts, comentarios, reacciones) |

### MongoDB (feed comunitario)

Posts, comentarios y reacciones viven en **MongoDB** (Mongoose), no en PostgreSQL. Desarrollo local:

```bash
# macOS con Homebrew
brew services start mongodb-community
```

URI por defecto en `development.ts`: `mongodb://127.0.0.1:27017/resvepro` (o `mongodb://mongo:27017/resvepro` con Docker Compose).

En producción, define `MONGODB_URI` con base de datos **`/resvepro`** (ej. `...mongodb.net/resvepro?retryWrites=true&w=majority`) en `.env.production` o en el hosting. Se carga automáticamente cuando `EGW_ENV=production`.

### Almacenamiento multimedia

| Destino | Uso |
|---------|-----|
| **GCS (`media-resvepro`)** | Almacén canónico de todo el multimedia nuevo |
| PostgreSQL `media_assets.data` | Solo legado INLINE o fallback si no hay `GCS_BUCKET` |

| Flujo | Endpoint |
|--------|----------|
| Panel (cualquier tamaño) | `POST /media/gcs/upload-url` → PUT → `POST /media/gcs/confirm` |
| Multipart API (avatars, etc.) | `POST /media/upload` → GCS si está configurado |
| URL ya pública | `POST /media/external` |
| Migrar INLINE → GCS | `POST /media/gcs/migrate-inline` `{ "limit": 50 }` |

**Compresión en el panel:** imágenes &gt; 200 KB → JPEG ~1920 px; videos &gt; 15 MB → compresión adaptativa (sin rechazo por tamaño). Guía de costes para admins: ruta `/storage` en egw-admin.

**CORS del bucket (obligatorio para el panel):** archivo listo en el repo:

```bash
# Desde egw-api (proyecto GCP donde está el bucket)
gcloud storage buckets update gs://media-resvepro --cors-file=scripts/gcs-cors-media-resvepro.json
```

También puedes pegar el JSON de `scripts/gcs-cors-media-resvepro.json` en Consola → bucket → Configuration → CORS.

**Lectura pública (reproducción en app/panel):** con acceso uniforme a nivel de bucket:

```bash
gcloud storage buckets add-iam-policy-binding gs://media-resvepro \
  --member=allUsers \
  --role=roles/storage.objectViewer
```

El service account de Cloud Run (API) necesita `roles/storage.objectAdmin` sobre `media-resvepro`.

Variables: `GCS_BUCKET=media-resvepro` (default en development/production).

En producción, `production.ts` puede leer overrides de `process.env` del proveedor de deploy.

### Supabase (PostgreSQL producción)

Proyecto RESVEPRO usa Supabase **solo como hosting PostgreSQL** (Prisma). No se instala el SDK de Supabase en admin ni mobile.

| Campo | Valor producción |
|-------|------------------|
| Host direct | `db.kccmopduvtlrqnlimowx.supabase.co` (**solo IPv6** — suele fallar en Mac/red local) |
| Host pooler (Session) | `aws-0-<region>.pooler.supabase.com` (**IPv4**, usar este) |
| Port | `5432` |
| Database | `postgres` |
| User direct | `postgres` |
| User pooler | `postgres.kccmopduvtlrqnlimowx` |
| Password | Project Settings → Database → **Database password** |

**Error P1001 (`Can't reach database server`)** desde tu Mac: el host `db.*.supabase.co` no tiene IPv4. Solución:

1. Supabase → **Project Settings → Database → Connection string**
2. Pestaña **Connection pooling** → modo **Session**
3. Copia la URI y ponla en `egw-api/.env.production` como `DATABASE_URL=...`
4. Vuelve a ejecutar: `pnpm prisma:migrate:prod`

**Advisor "RLS Disabled in Public":** Supabase avisa si hay tablas en `public` sin Row Level Security (expuestas vía PostgREST). RESVEPRO **no usa** Supabase SDK en admin/mobile; solo Prisma desde la API. La migración `20250703120000_enable_rls_public_schema` activa RLS en todas las tablas públicas (incl. `_prisma_migrations`). El rol `postgres` del pooler sigue accediendo con normalidad; roles `anon`/`authenticated` quedan bloqueados sin policies.

Plantilla: `egw-api/env.production.example` → copia a **`egw-api/.env.production`** (gitignored). Con `EGW_ENV=production`, la API carga ese archivo automáticamente.

**Primera vez contra Supabase:**

```bash
cd resvepro-api
EGW_ENV=production pnpm prisma:migrate:prod
# Usuarios/roles seed (opcional):
# EGW_ENV=production pnpm prisma:seed:prod
# Biblia RVR1960 — obligatoria en prod (~15–30 min, requiere red):
pnpm seed:bible:prod
```

**Biblia (común denominador):** colección `biblia`, categoría `biblia`, 66 libros RVR1960 desde `bible-api.deno.dev`. Idempotente: si ya existen 66 libros, no reimporta. Forzar: `pnpm seed:bible:prod -- --force`.

**Admin (Firebase):** `VITE_API_URL=https://api-resvepro-web-1046799880752.us-west1.run.app/api/v1` en `.env.production` antes del build.

**Mobile (EAS):** `EXPO_PUBLIC_API_URL=https://api-resvepro-app-1046799880752.us-west1.run.app/api/v1` en secrets o `.env` de build.

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
