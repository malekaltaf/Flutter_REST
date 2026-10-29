# Flutter REST Products

A modern Flutter application that browses products from the [dummyjson.com](https://dummyjson.com) REST API. Built with Material 3, cached network images, a search bar, and a smooth image carousel on the detail screen.

## Screenshots

| Home | Detail |
|------|--------|
| Product list with search | Image carousel, pricing, rating, cart |

## Features

- **REST API** — fetches up to 100 products from `dummyjson.com/products`
- **Search** — filter by product name, category, or brand in real time
- **Material 3** — `useMaterial3: true`, dynamic `ColorScheme.fromSeed`, light + dark theme support
- **Image carousel** — swipe through all product images on the detail screen with dot indicators and Hero transitions
- **Real star rating** — half-star precision using the API `rating` field
- **Discount display** — shows original price, discounted price, and percentage badge
- **Stock status** — live stock count with colour-coded indicator
- **Cart counter** — in-memory cart badge on the app bar
- **Error + empty states** — friendly UI for network failures and empty search results
- **Cached images** — `cached_network_image` for efficient image loading

## Project Structure

```
lib/
├── main.dart                  # App entry point, MaterialApp, themes
├── models/
│   └── product.dart           # Product data class + fromJson factory
├── services/
│   └── product_service.dart   # HTTP fetch logic
├── screens/
│   ├── home_screen.dart       # Product list + search bar
│   └── product_detail_screen.dart  # Detail view, carousel, buy actions
└── widgets/
    ├── product_card.dart      # List tile card widget
    └── star_rating.dart       # Reusable half-star rating row
```

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.1.5
- Dart SDK ≥ 3.1.5

### Run

```bash
flutter pub get
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `http ^1.1.0` | HTTP requests |
| `cached_network_image ^3.3.1` | Efficient image caching |
| `cupertino_icons ^1.0.6` | iOS-style icons |

## API

Uses the public [dummyjson.com](https://dummyjson.com) API — no key required.

Endpoint: `GET https://dummyjson.com/products?limit=100`

## License

MIT
