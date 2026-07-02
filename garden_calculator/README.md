# 🌱 GrowVault — Grow a Garden Calculator Suite

A **premium Flutter Web** calculator suite for the *Grow a Garden* universe.
GrowVault recreates the full functionality of a Grow a Garden calculator —
crop values, mutation stacking, a searchable crop database and a pet value
estimator — behind an original, modern, glassmorphic interface.

> Built with an entirely original brand, palette and layout. No third-party
> logos, artwork or assets are used.

---

## ✨ Features

| Tool | What it does |
|------|--------------|
| **Crop Value Calculator** | Pick a crop, set weight, quantity, growth + environmental mutations and a friend boost. Live value with a full multiplier breakdown. |
| **Mutation Stacker** | Combine any mutations and see the exact combined multiplier, then project it onto a base value. Handles exclusivity & conflicts. |
| **Crop Database** | Browse every crop with search, rarity filters and sorting (value / weight / name). |
| **Pet Value Estimator** | Estimate a pet's worth from species, age and weight. |
| **Guide** | The value formula, the three-step calculation, mutation rules and an FAQ. |

Plus: **dark / light mode** (remembered), **fully responsive** layouts
(desktop sidebar → mobile drawer + bottom bar), smooth page transitions,
animated counters, hover effects, empty states and keyboard-friendly inputs.

---

## 🧮 The value formula

```
Value = Base Value
      × (Weight ÷ Base Weight)²          ← weight factor (squared!)
      × Growth Multiplier                ← Gold ×20 or Rainbow ×50
      × (1 + Σ Environmental − Env Count) ← environmental term
      × (1 + Friend Boost ÷ 100)         ← friend boost
      × Quantity
```

- **Growth mutations** (Gold, Rainbow) are mutually exclusive and multiply
  directly.
- **Environmental mutations** stack inside the `(1 + Σ − count)` term.
- Conflicting mutations (e.g. Wet / Chilled / Frozen) auto-swap.

The pure engine lives in [`lib/services/calculator_service.dart`](lib/services/calculator_service.dart)
and is covered by unit tests in [`test/`](test/).

---

## 🏗️ Architecture

Clean, layered and modular:

```
lib/
├── main.dart                  # entry point + URL strategy
├── app.dart                   # MaterialApp.router + theming
├── core/
│   ├── constants/             # app + route constants
│   ├── providers/             # Riverpod root providers (repo, service)
│   ├── router/                # GoRouter config (ShellRoute + transitions)
│   ├── theme/                 # colors, ThemeData, theme controller
│   └── utils/                 # formatters, responsive helpers
├── data/
│   ├── models/                # Crop, Mutation, Rarity, Calculation
│   ├── datasources/           # crop + mutation catalogues
│   └── repositories/          # GardenRepository abstraction
├── services/                  # CalculatorService (pure logic)
├── features/
│   ├── home/                  # dashboard
│   ├── calculator/            # crop value calculator (+ controller)
│   ├── mutation/              # mutation stacker
│   ├── database/              # crop database
│   ├── pet/                   # pet value estimator
│   ├── guide/                 # how-it-works + FAQ
│   └── about/                 # about + tech
└── widgets/                   # reusable UI (GlassCard, chips, shell, …)
```

**Tech stack**

- **Flutter Web** · Material 3 · null-safe
- **Riverpod** for state management
- **GoRouter** for routing (clean URLs via `usePathUrlStrategy`)
- **google_fonts**, **intl**, **shared_preferences**

---

## 🚀 Getting started

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run in Chrome (debug)
flutter run -d chrome

# 3. Run tests
flutter test

# 4. Build for production
flutter build web --release
```

The production build is emitted to `build/web/` — deploy it to any static host
(GitHub Pages, Netlify, Firebase Hosting, Cloudflare Pages, …).

> **Note on assets:** original PWA icons (`web/icons/Icon-192.png`,
> `Icon-512.png`) and a `favicon.png` are not committed. Run
> `flutter create . --platforms web` in this folder once to scaffold defaults,
> then replace them with your own brand assets.

---

## 🎨 Design language

- Deep midnight-green backgrounds with a vivid **emerald** primary and warm
  **gold** value accents.
- **Glassmorphism** cards, soft shadows, rounded corners and gradient CTAs.
- Large, readable typography (Plus Jakarta Sans headings + Inter body).
- Consistent hover lifts, animated value counters and 320 ms page fades.

---

## 📊 Data

Crop and mutation data mirror community-documented Grow a Garden values,
curated in [`lib/data/datasources/`](lib/data/datasources/) so numbers can be
tuned in one place. A JSON reference export lives in
[`assets/data/crops.sample.json`](assets/data/crops.sample.json) for anyone who
prefers a data-driven / remote pipeline.

---

## ⚠️ Disclaimer

GrowVault is an **unofficial, fan-made** tool. It is not affiliated with,
endorsed by, or connected to the creators of *Grow a Garden* or Roblox
Corporation. All values are estimates and may change with game updates.
