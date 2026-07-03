# Convenciones API REST

Base URL local: `http://localhost:8000/api/v1`

Documentación interactiva: `http://localhost:8000/api/docs` (Swagger)

Contrato OpenAPI: [openapi.yaml](./openapi.yaml)

## Versionado

- Prefijo global: `/api/v1`
- Cambios breaking → `/api/v2`

## Autenticación

```
Authorization: Bearer <access_token>
```

Endpoints públicos: `POST /auth/register`, `POST /auth/login`, `POST /auth/forgot-password`, `POST /auth/reset-password`

## Formato de respuesta

### Éxito (lista paginada)

```json
{
  "data": [],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  }
}
```

### Éxito (recurso único)

```json
{
  "data": { "id": "uuid", "...": "..." }
}
```

### Error

```json
{
  "statusCode": 400,
  "message": "Descripción del error",
  "error": "Bad Request",
  "timestamp": "2026-06-02T12:00:00.000Z",
  "path": "/api/v1/books"
}
```

## Códigos HTTP

| Código | Uso |
|--------|-----|
| 200 | OK |
| 201 | Creado |
| 204 | Sin contenido (delete) |
| 400 | Validación |
| 401 | No autenticado |
| 403 | Sin permiso |
| 404 | No encontrado |
| 409 | Conflicto (email duplicado) |
| 429 | Rate limit |
| 500 | Error interno |

## Paginación

Query params: `page` (default 1), `limit` (default 20, max 100)

Ejemplo: `GET /books?page=1&limit=20&search=fe&categoryId=uuid`

## Filtros biblioteca (lectores)

| Param | Descripción |
|-------|-------------|
| `search` | Búsqueda en título/resumen |
| `categoryId` | Filtrar por categoría |
| `authorId` | Filtrar por autor |
| `collectionId` | Libros de una colección |
| `excludeCategorySlug` | Excluir libros de una categoría por slug (ej. `biblia`) |
| `isAudiobook` | `true` — solo audiolibros |
| `ids` | UUIDs separados por coma (máx. 100) para carga por lote |

Ejemplos:

```
GET /books?page=1&limit=20&search=fe&categoryId=uuid
GET /books?ids=uuid1,uuid2&limit=2
GET /books?excludeCategorySlug=biblia
```

### Listado vs detalle

| Endpoint | Uso | Incluye |
|----------|-----|---------|
| `GET /books` | Catálogo, listas, pestaña «Leyendo» (batch) | Metadatos ligeros: título, resumen, autor, categoría, URLs de media (`coverUrl`, `contentUrl`, `audioUrl`). **No** incluye capítulos ni el blob `data` de `media_assets`. |
| `GET /books/:id` | Detalle, lector, descarga | Metadatos + `chapters[]` + URLs de contenido |

**Regla para clientes:** no usar `GET /books/:id` en bucle para pintar listas; usar `GET /books?ids=...`.

## Estudio (lectura)

| Endpoint | Uso |
|----------|-----|
| `GET /study/book-ids` | IDs de libros con notas o resaltados del usuario (respuesta ligera para estado «estudiando») |
| `GET /study/highlights` | Listado completo de resaltados (opcional `bookId`) |
| `GET /study/notes` | Listado completo de notas (opcional `folderId`, `bookId`) |

Para badges de progreso en biblioteca, el móvil combina:

1. `GET /sync/state` — progreso de lectura remoto
2. `GET /study/book-ids` — libros con actividad de estudio
3. SQLite local — progreso offline (`reading_progress`)

- `POST /books/:id/chapters` — body: `title`, `order`, `content` (HTML; la API sanitiza etiquetas permitidas)
- `PATCH /chapters/:id` — actualizar capítulo

Etiquetas HTML permitidas en capítulos: `p`, `h2`, `h3`, `strong`, `em`, `ul`, `ol`, `li`, `blockquote`, `a`, `br`. El panel admin usa **TipTap**; el lector móvil renderiza ese HTML.

## Sync

- `GET /sync/state?since=<ISO8601>` — cambios remotos desde timestamp
- `POST /sync/push` — body con `bookmarks[]`, `progress[]`

## Rate limiting

Auth endpoints: 10 req/min por IP (configurable en API).
