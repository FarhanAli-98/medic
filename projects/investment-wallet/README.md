# Crescent Ledger

Crescent Ledger is a fictional Flutter investment wallet. It models available cash, three simulated sukuk holdings, and a dated activity history. You can add demo cash and allocate it to a holding to see the balance, holding size, and history update together. It uses an in-memory ledger that resets when the app restarts.

## Run

Use Flutter 3.47 or later with Chrome or Chromium. Run these commands from this directory.

```sh
flutter pub get
flutter run -d chrome
```

For a remote or headless environment, use `flutter run -d web-server --web-port 8080` and open the forwarded port. If Chrome detection can't locate Chromium, point `CHROME_EXECUTABLE` at the installed binary. The checked-in platform scaffold targets Flutter Web. The Flutter presentation and domain code are shared and can run under native runner scaffolds.

## Verify

```sh
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
```

Tests cover exact fils, amount limits, invalid and insufficient-funds protection, the relationship between wallet value and allocations, and interactions at desktop and phone widths.

## Code layout

- `lib/domain/` contains immutable money, positions, transactions, and wallet operations. Values stay in integer fils. Only the displayed portfolio percentages use floating-point math.
- `lib/data/` seeds fictional holdings and a transaction history that reconciles to the starting balance.
- `lib/application/` coordinates validated state changes and notifies the presentation.
- `lib/presentation/` provides responsive balance and history views, accessible field and button labels, and demo transaction dialogs.

The app is a standalone portfolio demonstration. All holdings, values, and transactions are synthetic.
