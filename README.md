# Air Gourmet iOS App

Native SwiftUI app for Air Gourmet inflight catering.

## Setup

### Prerequisites
- Xcode 15+
- iOS 16+ deployment target
- Apple Developer account (joel@air-gourmet.com)

### Fonts (one-time setup)
Download and place these font files into `ios-swift/AirGourmet/Resources/Fonts/`:
- `Outfit-Light.ttf`
- `Outfit-ExtraLight.ttf`
- `Outfit-Regular.ttf`
- `Hanuman-Medium.ttf`

Download from: https://fonts.google.com/specimen/Outfit and https://fonts.google.com/specimen/Hanuman

### Run

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_ORG/airgourmet-ios.git
cd airgourmet-ios

# 2. Open in Xcode
open ios-swift/AirGourmet.xcodeproj

# 3. In Xcode:
#    - Select AirGourmet target
#    - Signing & Capabilities → set Team to "Air Gourmet, Inc."
#    - Select iPhone 16 Pro Max simulator
#    - Press ⌘R
```

## Project Structure

```
ios-swift/
├── AirGourmet.xcodeproj/
└── AirGourmet/
    ├── AirGourmetApp.swift       # App entry point
    ├── Design/
    │   ├── Colors.swift          # Color tokens
    │   ├── Typography.swift      # Font system
    │   └── Spacing.swift         # Layout constants
    ├── Models/
    │   └── Models.swift          # Data models
    ├── State/
    │   ├── AuthStore.swift       # Auth state
    │   ├── CartStore.swift       # Cart state
    │   ├── MenuStore.swift       # Menu data
    │   └── OrderStore.swift      # Order state
    ├── Services/
    │   └── APIClient.swift       # Network layer
    ├── Utilities/
    │   ├── Extensions/ViewExtensions.swift
    │   └── Helpers/Notifications.swift
    ├── Views/
    │   ├── Home/
    │   │   ├── ContentView.swift # App shell + tab nav
    │   │   └── HomeView.swift    # Home screen
    │   ├── Menu/
    │   │   ├── CategoryView.swift
    │   │   └── SearchView.swift
    │   ├── Cart/
    │   │   └── CartView.swift
    │   ├── Auth/
    │   │   └── AuthViews.swift   # Login, signup, forgot pw
    │   ├── Order/
    │   │   └── OrderViews.swift  # Delivery, summary, history
    │   ├── Profile/
    │   │   └── ProfileViews.swift
    │   └── Info/
    │       └── InfoViews.swift   # About, Contact
    └── Resources/
        ├── menu.json
        ├── Fonts/                # Add TTF files here
        └── Assets.xcassets/
```

## Architecture

- **SwiftUI** — all UI
- **@EnvironmentObject** — shared state (Auth, Cart, Menu, Order)
- **async/await** — all network calls
- **Bundled JSON** — menu loads from `menu.json` for offline use
