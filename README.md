# Tomora

Inventario de libros personal y compartido, con valoraciones, búsqueda en Google Books
y (próximamente) traducción de fichas. App Flutter con arquitectura limpia y backend
Firebase.

- Paquete Android / bundle iOS: `com.pedrogrameitor.tomora`
- Flutter fijado con FVM (ver `.fvmrc`)

## Puesta en marcha

```sh
fvm install
fvm flutter pub get
fvm flutter run
```

### Estructura

- `lib/core/` — configuración transversal: DI (`get_it`), rutas (`go_router`), tema,
  almacenamiento, arranque de Firebase, anuncios.
- `lib/features/<feature>/{data,domain,presentation}` — cada funcionalidad en capas
  (auth, catalog, library, preferences, splash).
- `functions/` — Cloud Functions (referidos, escrituras entre cuentas).
- `firestore.rules` — reglas que restringen la escritura al dueño de cada documento.
