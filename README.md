# NewYorkRents App (Flutter + Shopify Storefront)

Catálogo móvil con **Flutter**, **Dio**, **BLoC**, **Provider**, **go_router** y **SharedPreferences**, consumiendo **Shopify Storefront API**.  
Incluye arquitectura **Clean** (data/domain/presentation), **entornos dev/prod**, **filtros oficiales (Search & Discovery)**, **metafields/metaobjects dinámicos** y **página de detalle**.

---

## 📋 Requisitos

- Flutter SDK instalado (`flutter doctor`)  
- Android Studio (SDK + emulador)  
- (iOS solo en macOS)  

Comprobación rápida:
```powershell
flutter doctor; flutter doctor --android-licenses
```

---

## 🚀 Arranque rápido

### 1) Variables de entorno

**Desarrollo (`.env.dev`)** – ejemplo con tus datos:
```powershell
Set-Content -Path .env.dev -Value "SHOP_PUBLIC_HOST=newyorkrents.co`nSHOP_MYSHOPIFY_DOMAIN=wzkvr1-j0.myshopify.com`nSHOPIFY_API_VERSION=2025-07`nSTOREFRONT_TOKEN=08d2985753a03be8da132fe8796623d4`nPAGE_SIZE=12`nDEFAULT_SORT=CREATED`nDEFAULT_HANDLE=rooms`nCOLLECTION_HANDLES=rooms,manhattan,brooklyn,queens,bronx,aparment`nMF_LIST=custom.gender,custom.neighborhood`nMF_REF_MAP=custom.neighborhood=name"
```

**Producción (`.env.prod`)** – placeholder (completar luego):
```powershell
Set-Content -Path .env.prod -Value "SHOP_PUBLIC_HOST=`nSHOP_MYSHOPIFY_DOMAIN=`nSHOPIFY_API_VERSION=2025-07`nSTOREFRONT_TOKEN=`nPAGE_SIZE=12`nDEFAULT_SORT=CREATED`nDEFAULT_HANDLE=rooms`nCOLLECTION_HANDLES=`nMF_LIST=`nMF_REF_MAP="
```

Ignorar en Git:
```powershell
Add-Content -Path .gitignore -Value "`n.env*"
```

> ⚠️ Usa **Storefront API access token** (no el Admin). No subas `.env*` al repo.

---

### 2) Ejecutar

**Dev (Windows/PowerShell):**
```powershell
flutter run --dart-define-from-file=.env.dev
```

**Build Android (release):**
```powershell
flutter build apk --release --dart-define-from-file=.env.prod
```

**VS Code (seleccionar ambiente en el Depurador):** crea `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Android) — DEV",
      "type": "dart",
      "request": "launch",
      "toolArgs": ["--dart-define-from-file=.env.dev"]
    },
    {
      "name": "Flutter (Android) — PROD",
      "type": "dart",
      "request": "launch",
      "toolArgs": ["--dart-define-from-file=.env.prod"]
    }
  ]
}
```

---

## 🧱 Arquitectura

```
lib/
  core/
    config/            # AppEnv (lee --dart-define)
    network/           # Dio (client/postGql)
    storage/           # SharedPreferences wrapper
    router/            # GoRouter centralizado (app_router.dart)
    theme/             # Colores y ThemeData (app_colors.dart, app_theme.dart)
  di/
    injector.dart      # Providers/ProxyProviders
  features/
    catalog/
      data/            # datasources, models, repository impl
      domain/          # entities, repositories, usecases
      presentation/
        gallery/
          bloc/        # gallery_bloc.dart, gallery_event.dart, gallery_state.dart
          pages/       # gallery_page.dart
          widgets/     # product_card.dart, filter_bar.dart, collections_bar.dart
        detail/
          bloc/        # detail_bloc.dart, detail_event.dart, detail_state.dart
          pages/       # product_detail_page.dart
```

- **Clean:** `presentation → domain → data` (dep. hacia abajo).  
- **BLoC por feature:** cada feature tiene su propia carpeta `presentation/<feature>/{bloc,pages,widgets}`.  
- **Rutas:** centralizadas en `core/router/app_router.dart`.  
- **Tema/colores:** en `core/theme`.

---

## ⚙️ Variables de entorno (soportadas)

| Variable | Ejemplo | Descripción |
|---|---|---|
| `SHOP_PUBLIC_HOST` | `newyorkrents.co` | Dominio público (opcional, fallback del endpoint). |
| `SHOP_MYSHOPIFY_DOMAIN` | `wzkvr1-j0.myshopify.com` | Dominio myshopify (endpoint Storefront). |
| `SHOPIFY_API_VERSION` | `2025-07` | Versión Storefront API. |
| `STOREFRONT_TOKEN` | `...` | Storefront API access token. |
| `PAGE_SIZE` | `12` | Tamaño de página para paginación. |
| `DEFAULT_SORT` | `CREATED` | Clave de orden (ProductCollectionSortKeys). |
| `DEFAULT_HANDLE` | `rooms` | Colección inicial. |
| `COLLECTION_HANDLES` | `rooms,manhattan,...` | Barra de colecciones en UI. |
| `MF_LIST` | `custom.gender,custom.neighborhood` | Lista **namespace.key** de **metafields** de producto a mostrar. |
| `MF_REF_MAP` | `custom.neighborhood=name` | Para metafields que referencian **metaobjects**: qué campo mostrar. |

> Para ampliar: solo edita `MF_LIST`/`MF_REF_MAP` y vuelve a ejecutar; no hace falta tocar código.

---

## 🛣️ Rutas (go_router)

- `/` → **GalleryPage** (grid con filtros y selector de colecciones)  
- `/product/:handle` → **ProductDetailPage** (imágenes, descripción, precio + **metafields/metaobjects**)

El `GoRouter` vive en `core/router/app_router.dart`.  
Para navegar al detalle desde la grilla:
```dart
context.push('/product/${item.handle}');
```

---

## 🎨 Tema y colores

- **Colores:** `core/theme/app_colors.dart` (variables centralizadas; luego pasas tu paleta y las ajustamos).
- **ThemeData:** `core/theme/app_theme.dart`.
```dart
theme: AppTheme.light()
```

---

## 🧩 Catálogo, filtros y metadatos

- **Listado por colección** (paginación) y **filtros** desde `collection.products.filters` (Search & Discovery).  
- **Chips**: `FilterBar` consume `filters.values.input` y reenvía ese JSON en el query.  
- **Metafields/Metaobjects dinámicos**: configurados por env (`MF_LIST`, `MF_REF_MAP`).  
  - Si el metafield referencia un **metaobjeto**, se resuelve `reference { ... on Metaobject { field(key:"..."){ value } } }` en el selection set.

> En Shopify: expón tus **metafields** al **Storefront** y habilita filtros en **Search & Discovery → Filters**.

---

## 🔌 Red (Dio + GraphQL)

- `core/network/dio_client.dart` configura headers y fallback de endpoints:
  - `https://$SHOP_PUBLIC_HOST/api/$API_VERSION/graphql.json`
  - `https://$SHOP_MYSHOPIFY_DOMAIN/api/$API_VERSION/graphql.json`  
- `X-Shopify-Storefront-Access-Token` desde `AppEnv.storefrontToken`.

---

## 🧪 Smoke test (cURL)

Verifica que tu token/colección devuelven datos:
```powershell
curl -X POST https://wzkvr1-j0.myshopify.com/api/2025-07/graphql.json -H "Content-Type: application/json" -H "X-Shopify-Storefront-Access-Token: 08d2985753a03be8da132fe8796623d4" -d "{"query":"{ collection(handle:\"rooms\"){ title products(first:1){ edges{ node{ title featuredImage{ url } priceRange{ minVariantPrice{ amount currencyCode } } } } } } }"}"
```

---

## 🛠️ Scripts útiles (1 línea)

**Permiso de Internet (Android):**
```powershell
$mf="android\app\src\main\AndroidManifest.xml"; if(-not (Select-String -Path $mf -Pattern "android.permission.INTERNET" -Quiet)){(Get-Content $mf) -join "`n" -replace '(<manifest[^>]*>)','$1`n    <uses-permission android:name="android.permission.INTERNET" />'|Set-Content $mf}
```

**Agregar más handles/metafields en `.env.dev`:**
```powershell
Add-Content .env.dev "`nCOLLECTION_HANDLES=rooms,manhattan,brooklyn,queens,bronx,aparment"; Add-Content .env.dev "`nMF_LIST=custom.gender,custom.neighborhood,custom.property_type"; Add-Content .env.dev "`nMF_REF_MAP=custom.neighborhood=name"
```

---

## 🧭 Convenciones

- **Features-first:** cada feature encapsula `data/domain/presentation`.  
- **BLoC por feature** en `presentation/<feature>/bloc`.  
- **Páginas** en `presentation/<feature>/pages`.  
- **Widgets** en `presentation/<feature>/widgets`.  
- **Rutas** solo en `core/router/app_router.dart`.  
- **Tema** solo en `core/theme`.

---

## ❗ Troubleshooting

- **401/403** → token erróneo (usa **Storefront**), colección/prods **no publicados** en **Online Store**.  
- **Collection/Product not found** → `handle` incorrecto o sin publicar.  
- **Sin filtros** → habilitar en **Search & Discovery → Filters** (y asignar tags/metafields a productos).  
- **Campos de metafield vacíos** → revisa `MF_LIST/MF_REF_MAP` y que estén **expuestos al Storefront**.

---

## 📄 Licencia

Uso interno / proyecto demo. Ajusta según tu necesidad.
