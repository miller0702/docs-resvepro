# Roles y permisos (Plan Plata)

## Roles del sistema

| Rol | Código | Descripción |
|-----|--------|-------------|
| Super Administrador | `SUPER_ADMIN` | Control total |
| Administrador General | `ADMIN_GENERAL` | Operación y editorial |
| Administrador Modular | `ADMIN_MODULAR` | Permisos asignados |
| Lector | `LECTOR` | Usuario final móvil |

## Matriz de permisos MVP

| Permiso | SUPER | ADMIN_GEN | ADMIN_MOD | LECTOR |
|---------|:-----:|:---------:|:---------:|:------:|
| `users:read` | ✓ | ✓ | — | — |
| `users:write` | ✓ | ✓ | — | — |
| `users:impersonate` | ✓ | — | — | — |
| `admin:audit` | ✓ | ✓ | — | — |
| `roles:read` | ✓ | ✓ | — | — |
| `roles:write` | ✓ | — | — | — |
| `books:read` | ✓ | ✓ | ✓* | ✓ |
| `books:write` | ✓ | ✓ | ✓* | — |
| `categories:write` | ✓ | ✓ | ✓* | — |
| `collections:write` | ✓ | ✓ | ✓* | — |
| `media:upload` | ✓ | ✓ | ✓* | — |
| `streaming:write` | ✓ | ✓ | ✓* | — |
| `admin:stats` | ✓ | ✓ | — | — |
| `moderation:read` | ✓ | ✓ | — | — |
| `moderation:write` | ✓ | ✓ | — | — |
| `library:read` | ✓ | ✓ | ✓ | ✓ |
| `sync:write` | — | — | — | ✓ |

\* ADMIN_MODULAR: solo si el permiso está asignado explícitamente en `role_permissions`.

## Usuario seed (desarrollo)

| Email | Contraseña | Rol |
|-------|------------|-----|
| `superadmin@resvepro.local` | `Admin123!` | SUPER_ADMIN (usuario: `superadmin`) |
| `lector@resvepro.local` | `Lector123!` | LECTOR |

## Implementación en API

- Decorador `@Roles('SUPER_ADMIN', 'ADMIN_GENERAL')`
- Guard `RolesGuard` lee roles del JWT payload
- Permisos granulares: `@RequirePermissions('books:write')`
