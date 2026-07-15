# Manual de usuario — Panel web RESVEPRO

El **panel administrativo** es la herramienta del equipo editorial y de operaciones para gestionar el catálogo, multimedia, usuarios, comunidad (moderación), y la configuración de la app móvil RESVEPRO.

---

## Índice

1. [Acceso y seguridad](#1-acceso-y-seguridad)
2. [Dashboard](#2-dashboard)
3. [Biblioteca editorial](#3-biblioteca-editorial)
4. [Multimedia](#4-multimedia)
5. [Usuarios, roles y auditoría](#5-usuarios-roles-y-auditoría)
6. [Moderación y requerimientos](#6-moderación-y-requerimientos)
7. [Configuración de la app móvil](#7-configuración-de-la-app-móvil)
8. [Ajustes del sistema](#8-ajustes-del-sistema)
9. [Buenas prácticas](#9-buenas-prácticas)
10. [Problemas frecuentes](#10-problemas-frecuentes)

---

## 1. Acceso y seguridad

### 1.1 Iniciar sesión

1. Abre la dirección del panel que te haya indicado tu organización.
2. Ingresa **correo** o **usuario** y **contraseña**.
3. Pulsa **Iniciar sesión**.

Solo cuentas con rol de panel (`SUPER_ADMIN`, `ADMIN_GENERAL` o `ADMIN_MODULAR` con permisos) pueden entrar. Los lectores de la app **no** usan este panel.

### 1.2 Cerrar sesión y sesión activa

- Usa la opción de cerrar sesión del menú/perfil cuando termine tu trabajo.
- No compartas tu contraseña. El superadministrador puede revisar acciones en **Auditoría**.

### 1.3 Roles (resumen)

| Rol | Qué puede hacer (orientativo) |
|-----|-------------------------------|
| **Super Administrador** | Control total, seguridad, personificar otros admins, roles |
| **Administrador General** | Operación editorial, usuarios, moderación, estadísticas |
| **Administrador Modular** | Solo los permisos que le asignen (p. ej. solo libros) |

Los lectores (`LECTOR`) operan únicamente en la app móvil.

### 1.4 Páginas públicas relacionadas

- Documentos legales publicados (`/legal/...`).
- Página de **eliminación de cuenta** para usuarios finales.

---

## 2. Dashboard

La portada del panel resume el estado de la plataforma:

- Conteos de usuarios, biblioteca y multimedia.
- Indicadores de **requerimientos** o **reportes** pendientes.

Úsalo al comenzar el día para priorizar moderación y contenidos sin publicar.

---

## 3. Biblioteca editorial

### 3.1 Libros

**Listado**

- Busca, pagina y revisa el estado (**Publicado** / **Borrador**).
- Acciones por fila (iconos):
  - **Editar** — formulario completo.
  - **Ver / previsualizar** — ficha de solo lectura (contenido, capítulos, archivos). Desde la cabecera puedes **Editar**, **Publicar / Quitar de la app** o **Eliminar**.
  - **Publicar / Quitar de la app** — cambia si el libro aparece en la app.
  - **Eliminar** — borrado permanente (pide confirmación).

**Crear / editar libro**

1. Completa título, resumen, autor, categoría.
2. Marca si está **publicado** y si es **audiolibro**.
3. Sube **portada**, archivo de referencia (PDF/EPUB según límites) y **audio** si aplica.
4. Gestiona **capítulos HTML** (editor enriquecido): título, orden y contenido.  
   Importante: el lector de la app muestra estos capítulos, no el PDF automáticamente.
5. Guarda metadatos y capítulos.

**Consejo:** para que un libro se lea offline en la app, el usuario debe descargarlo desde la app; asegúrate de que los capítulos tengan contenido real.

### 3.2 Autores, categorías y colecciones

| Entidad | Uso |
|---------|-----|
| **Autores** | Personas asociadas a libros/podcasts |
| **Categorías** | Clasificación por tipo (libros, podcasts, videos) |
| **Colecciones** | Agrupaciones editoriales de libros |

En el listado, **Ver detalle** abre un **modal** rápido (pocos campos). **Editar** abre la página completa. En colecciones puedes añadir o quitar libros.

---

## 4. Multimedia

### 4.1 Podcasts

1. Crea o edita una **serie** (título, descripción, autor, categoría, portada, publicado).
2. Añade **episodios** con título, orden, descripción y URL o archivo de audio.
3. Publica la serie/episodios para que se vean en la app.

Los archivos muy grandes suelen requerir URL externa (CDN/S3), no solo subida inline.

### 4.2 Videos

1. Crea un video con título, descripción y categoría.
2. Indica URL de **YouTube** o video directo; el sistema puede sugerir duración/miniatura.
3. Opcionalmente sube miniatura personalizada.
4. Publica para la app.

En previsualización (modo ver) la cabecera permite editar, publicar/quitar y eliminar.

### 4.3 Radio

1. Configura nombre, URL del stream, descripción, orden.
2. Marca **En vivo** y **Publicado** según corresponda.
3. Sube portada si aplica.

---

## 5. Usuarios, roles y auditoría

### 5.1 Usuarios

Hay dos contextos (pestañas):

| Pestaña | Contenido |
|---------|-----------|
| **Equipo del panel** | Administradores |
| **Lectores de la app** | Usuarios móviles |

**Acciones habituales**

- **Editar** — datos, roles (según contexto), estado activo, permiso de publicar (lectores).
- **Ver detalle** — consulta sin editar.
- **Personificar** — solo superadmin y hacia cuentas de **panel** (no lectores). Úsalo con cuidado; queda registrado.
- **Bloquear / desbloquear** — impide el inicio de sesión.
- En lectores: opciones de restringir publicaciones o eliminar cuenta (según permisos y flujo).

### 5.2 Roles y permisos

- Consulta roles del sistema.
- El rol **LECTOR** es de la app y no se gestiona como un rol editable de panel.
- Roles inmutables del sistema no se borran ni se desvirtúan.
- **ADMIN_MODULAR**: asigna solo los permisos necesarios (principio de mínimo privilegio).

### 5.3 Auditoría

Revisa el historial de acciones administrativas (altas, cambios, personificaciones). Útil ante incidencias o cumplimiento interno.

---

## 6. Moderación y requerimientos

### 6.1 Reportes de moderación

Los lectores pueden denunciar publicaciones, usuarios, comentarios o imágenes.

En **Moderación**:

1. Filtra por estado (pendiente, en revisión, resuelto, descartado).
2. Revisa la columna de **contenido** y abre **Revisar**.
3. En el detalle verás el **contenido reportado** (texto, autor, imágenes) cuando exista.
4. Actualiza el **estado** y deja **notas internas**.
5. Guarda. Actúa también sobre el contenido o usuario desde otras secciones si hace falta (bloquear, borrar post, etc., según herramientas disponibles).

### 6.2 Requerimientos

Mensajes que los lectores envían desde la app (**Enviar requerimiento**).

1. Abre un requerimiento.
2. Cambia estado (pendiente, en revisión, resuelto, rechazado).
3. Añade notas internas.
4. Guarda y da seguimiento al usuario por el canal que use tu organización (correo, etc.), si aplica.

---

## 7. Configuración de la app móvil

Sección **App** (o equivalente en el menú).

### 7.1 Pestañas

- Ordena las pestañas de la barra inferior (arrastrar si está habilitado).
- Edita título, iconos (normal / activo) y si la pestaña es visible.

Los cambios se reflejan en la app tras actualizar/refrescar datos de plataforma.

### 7.2 Menú lateral (drawer)

- Gestiona ítems: etiqueta, icono, destino/ruta, visibilidad y orden.
- Mantén visibles **Centro de estudios**, **Mis descargas**, **Manual** y ayuda legal para una buena experiencia offline y de soporte.

### 7.3 Anuncios

- Publica anuncios que aparecen fijados o destacados en el feed de la comunidad.
- Usa textos claros y fechas de vigencia si el formulario lo permite.

### 7.4 Manual de usuario (app y panel)

- En **App móvil → Manual** hay dos pestañas: **App móvil** (lo que ven los lectores) y **Panel web** (esta guía del equipo).
- Los lectores ven el manual en la app (menú → Manual de usuario). El equipo puede leerlo aquí en **Manual del panel**.
- Cuando cambien flujos importantes, actualiza esas secciones desde el panel para que nadie use información desactualizada.

### 7.5 Tutorial

- Define los pasos del tutorial de bienvenida para usuarios nuevos (icono, título, texto, orden).

---

## 8. Ajustes del sistema

### 8.1 General

- Nombre del sitio, contacto de soporte.
- Modo **mantenimiento** o no disponibilidad (la app mostrará pantallas de sistema).
- Versión mínima de app, si está configurada.

### 8.2 Marca y colores

- Nombre comercial, lema, logos.
- Paleta de colores de la app (tema claro/oscuro según branding).

### 8.3 Seguridad (superadministrador)

- Políticas de sesión y límites de intentos de login (según campos disponibles).
- No publiques secretos reales en repositorios.

### 8.4 Legal

- Redacta y publica **términos**, **privacidad**, cookies, normas de comunidad.
- Los lectores los aceptan en el registro y pueden consultarlos desde la app o URL públicas.

---

## 9. Buenas prácticas

1. **Publicar con cuidado:** previsualiza libros y multimedia antes de marcar «Publicado».
2. **Capítulos completos:** sin HTML de capítulo, el lector móvil no tiene contenido útil (ni offline).
3. **Moderación ágil:** atiende reportes pendientes a diario.
4. **Permisos mínimos:** no des `SUPER_ADMIN` a todo el equipo.
5. **Personificación:** solo cuando sea necesario y durante poco tiempo.
6. **Anuncios claros:** un anuncio a la vez evita saturar el feed.
7. **Manual y tutorial** actualizados cuando cambien flujos importantes (descargas, comunidad).
8. En listados, usa **Ver** para consultar sin riesgo de editar por error; usa **Editar** solo cuando vayas a cambiar datos.

---

## 10. Problemas frecuentes

| Situación | Qué hacer |
|-----------|-----------|
| No entro al panel | Confirma que tu usuario es de panel, no solo lector; verifica URL y contraseña |
| No veo un menú | Tu rol modular puede no tener ese permiso |
| El libro no aparece en la app | Debe estar **Publicado**; el usuario debe actualizar/refrescar la app |
| La app no lee el PDF | El lector usa **capítulos HTML**, no el adjunto PDF automático |
| No aparecen reportes con contenido | El contenido pudo borrarse; el detalle lo indica como no disponible |
| Personificar no aparece en lectores | Es intencional: solo admins de panel |
| Cambié pestañas y no veo cambio | Pide a usuarios cerrar y reabrir la app o esperar refresco de configuración |
| Tooltip de acciones genera scroll | Debe estar corregido; recarga el panel |

---

## Flujos recomendados (checklist)

### Publicar un libro nuevo

1. Crear autor (si no existe) → 2. Crear libro → 3. Subir portada → 4. Añadir capítulos → 5. Publicar → 6. Verificar en la app.

### Publicar un podcast

1. Crear serie → 2. Guardar → 3. Subir episodios con audio → 4. Publicar → 5. Probar en pestaña Audio.

### Atender un reporte

1. Abrir Moderación → 2. Revisar contenido → 3. Decidir (resolver/descartar) → 4. Notas → 5. Si procede, bloquear usuario o retirar contenido.

### Preparar onboarding de lectores

1. Actualizar Manual en App → 2. Revisar Tutorial → 3. Confirmar documentos legales → 4. Publicar anuncio de bienvenida.

---

## Documentación relacionada

| Documento | Uso |
|-----------|-----|
| [MANUAL-USUARIO-APP.md](./MANUAL-USUARIO-APP.md) | Qué ven y hacen los lectores |
| [ROLES.md](./ROLES.md) | Matriz de permisos |
| [ENV.md](./ENV.md) | URLs y puertos de desarrollo |
| [APP-DESCRIPTION.md](./APP-DESCRIPTION.md) | Ficha de producto y tiendas |

Para tareas técnicas (API, base de datos, despliegue) consulta `ARCHITECTURE.md`, `API.md` y `CONTRIBUTING.md`.
