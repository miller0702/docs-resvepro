# Roadmap MVP — Plan Plata (2–3 meses)

## Etapa 1 — Planeación y arquitectura (1–2 semanas)

- [x] Documentación técnica (`docs/`)
- [x] Diseño base de datos (Prisma schema)
- [x] Contrato OpenAPI MVP
- [ ] Diseño UI/UX (Figma) — pendiente cliente
- [x] Scaffolding repositorios

## Etapa 2 — Backend (3–4 semanas)

- [x] Scaffold NestJS + módulos
- [x] API streaming: podcasts, videos, radio
- [x] Listado ligero de libros (sin blob media en `GET /books`) + `ids` batch + `GET /study/book-ids`
- [ ] Completar CRUD admin biblioteca
- [ ] Tests e2e auth + library
- [x] Integración GCS (signed upload hasta 100 MB)

## Etapa 3 — Mobile (4–6 semanas)

- [x] Scaffold Expo + navegación
- [x] Tabs Audio (podcasts + radio) y Videos
- [x] Optimización carga biblioteca (listado ligero API, batch `ids`, `useReadingActivity`, caché React Query)
- [x] Lector HTML en capítulos (TipTap admin + render WebView móvil)
- [ ] Lector EPUB/HTML completo (archivo libro)
- [ ] Offline download + sync
- [ ] Caché persistente del catálogo de libros (SQLite/AsyncStorage)
- [ ] Publicación TestFlight / Internal testing

## Etapa 4 — Panel admin (2–3 semanas)

- [x] Scaffold React admin
- [ ] CRUD completo conectado a API
- [ ] Dashboard estadísticas

## Etapa 5 — QA y despliegue (1–2 semanas)

- [ ] QA funcional
- [ ] Deploy GCP
- [ ] Backups automatizados
- [ ] Documentación operativa

## Evolución post-MVP (Plan Oro)

- [x] Podcasts y radio en vivo (móvil + API)
- [x] Catálogo de videos con reproductor
- Búsqueda avanzada
- i18n básico
- Analytics mejorado

## Evolución enterprise (Plan Platino)

- Sync avanzado
- Recomendaciones
- CDN multimedia
- Multi-idioma completo
