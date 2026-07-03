# MOBILE-UI.md — egw-mobile

Convenciones de interfaz para la app **RESVEPRO** (Expo React Native). Referencia para humanos y agentes de IA al implementar pantallas nuevas.

## Estados de carga (skeleton)

### Regla obligatoria

Todo contenido que se muestra dentro de una **card**, **lista**, **contenedor** o **pantalla de detalle** debe usar **skeleton** mientras `isLoading` (TanStack Query) o equivalente.

**No usar** para esos casos:

- Texto plano (`"Cargando..."`, `"Cargando catálogo..."`, etc.)
- `ActivityIndicator` centrado como sustituto de una lista o card

### Excepciones permitidas

| Caso | Motivo |
|------|--------|
| `Button` con `loading` | Spinner inline en el botón |
| `FavoriteToggle` / play en `PodcastCard` | Acción puntual, no layout de página |
| Splash / `app/index.tsx` (sesión) | Pantalla global sin contenido previo |
| Dropdown pequeño (p. ej. sugerencias `@` en compositor) | Área auxiliar, no card principal |
| `WebView` / reproductor nativo | El propio componente gestiona buffer |

## Componentes

| Archivo | Uso |
|---------|-----|
| `src/components/ui/Skeleton.tsx` | Bloque base con pulso (Reanimated). Props: `width`, `height`, `borderRadius`, `fill` |
| `src/components/skeletons/ContentSkeletons.tsx` | Skeletons compuestos que replican cards reales |

### Skeletons disponibles

| Componente | Replica |
|------------|---------|
| `BookCardSkeleton` | `BookCard` |
| `VideoCardSkeleton` | `VideoCard` |
| `PodcastCardSkeleton` | `PodcastCard` |
| `RadioCardSkeleton` | `RadioCard` (carrusel horizontal) |
| `FeedPostSkeleton` | `FeedPostCard` |
| `FilterChipsSkeleton` | `ContentFilterBar` |
| `FavoritesSkeleton` | Sección de favoritos |
| `SearchResultsSkeleton` | Filas del buscador |
| `ListRowSkeleton` | Comentarios, reacciones |
| `CompactCardSkeleton` | Carpetas, notas, highlights |
| `ParallaxDetailSkeleton` | Detalle libro / video / podcast |
| `CommentListSkeleton` | Lista de comentarios |

Helper: `skeletonKeys(n)` — genera ids estables para `FlatList` en modo carga.

## Patrones de implementación

### Lista (`FlatList`)

```tsx
const { data, isLoading } = useQuery({ ... });
const items = data ?? [];

<FlatList
  data={isLoading ? skeletonKeys() : items}
  keyExtractor={(item) => (typeof item === 'string' ? item : item.id)}
  renderItem={({ item, index }) =>
    isLoading ? <BookCardSkeleton /> : <BookCard {...item} index={index} />
  }
  ListEmptyComponent={!isLoading ? <EmptyState /> : null}
/>
```

### Sección en `ScrollView`

```tsx
{query.isLoading ? (
  <>
    <PodcastCardSkeleton />
    <PodcastCardSkeleton />
  </>
) : items.length === 0 ? (
  <EmptyText />
) : (
  items.map(...)
)}
```

### Pantalla de detalle

```tsx
if (isLoading) {
  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <ParallaxDetailSkeleton />
    </View>
  );
}
```

### Filtros

`ContentFilterBar` ya usa `FilterChipsSkeleton` cuando `loading={true}`. No añadir spinners propios.

## Caché de datos (biblioteca)

La pantalla de biblioteca (`library.tsx`) usa TanStack Query con tiempos de frescura para evitar refetch innecesario:

| Query key | Hook / origen | `staleTime` | Notas |
|-----------|---------------|-------------|-------|
| `['books', 'infinite', params]` | `useInfiniteBooks` | 5 min | Catálogo paginado; pull-to-refresh invalida manualmente |
| `['categories', 'BOOK']` / `['collections']` | `useBookFilters` | 10 min | Chips de filtro |
| `['reading-activity']` | `useReadingActivity` | 60 s | `GET /sync/state` + `GET /study/book-ids` (una sola vez compartida) |
| `['reading-now-books']` | `useReadingNowBooks` | 60 s | Usa `GET /books?ids=` en batch |
| `['reading-statuses', …]` | `useReadingStatuses` | 30 s | Solo en pestañas de catálogo; en «Leyendo» se reutilizan estados del hook anterior |

**Reglas:**

- No llamar `GET /books/:id` en bucle para listas; usar `ids` en el listado.
- No refetch en cada `useFocusEffect` si los datos siguen frescos; reservar actualización a pull-to-refresh o invalidación explícita (lector, marcar leído).
- Tras cambiar progreso o crear resaltado, invalidar `reading-activity`, `reading-now-books` y `reading-statuses`.
- `useReadingActivity` usa `GET /sync/state?since=<lastSync>` (no volcar todo el historial) y fusiona SQLite en **segundo plano** para no bloquear iOS.
- En iOS los skeletons son estáticos (sin pulso Reanimated) para reducir CPU y calentamiento.

## Añadir un skeleton nuevo

1. Crear o extender el componente en `ContentSkeletons.tsx`.
2. **Replicar el layout** de la card real (mismos márgenes, bordes, proporciones de imagen).
3. Usar `Skeleton` con `colors.surface` / `colors.border` en el contenedor padre.
4. Conectar en la pantalla con el patrón `isLoading` de arriba.
5. Documentar en esta tabla si es reutilizable.

## Theming

- Los skeletons leen `useTheme()`; funcionan en claro y oscuro.
- Color base: `colors.border` (claro) o blanco al 10% (oscuro).
- Animación: pulso de opacidad ~850 ms (no shimmer externo).

## Checklist para PR / feature nueva

- [ ] ¿Hay cards, listas o contenedores con datos async? → skeleton
- [ ] ¿El skeleton coincide visualmente con el componente cargado?
- [ ] ¿`ListEmptyComponent` solo aparece cuando `!isLoading`?
- [ ] ¿Filtros usan `FilterChipsSkeleton` vía `ContentFilterBar`?

## Referencias en código

Pantallas de referencia: `app/(drawer)/(tabs)/library.tsx`, `feed.tsx`, `videos.tsx`, `audio.tsx`, `favorites.tsx`, `app/book/[id].tsx`, `src/components/community/ContentSearchOverlay.tsx`.

Hooks de biblioteca: `src/hooks/useInfiniteBooks.ts`, `useReadingActivity.ts`, `useReadingNowBooks.ts`, `useReadingStatuses.ts`.
