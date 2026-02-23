# SkinKit

Last verified: 2026-02-23

## What This Is

Host-agnostic parser for Winamp WSZ skin files (ZIP archives of BMP sprite sheets). macOS 15+, Swift 6.0.

## Key Types

- `SkinLoader` — actor, extracts+slices; accepts `Bundle` parameter for resource lookup, defaults to `.main`
- `SkinData` — dictionary of `[SpriteName: CGImage]` + optional `GenExColors` + `hasNativeEasterEggTitlebar: Bool`
- `SpriteName` — enum, ~350 cases including GEN.BMP window chrome, MB.BMP title bar, and font characters
- `BMPLoader` — BMP→CGImage + per-pixel color sampling
- `GenExColors` — 22 colors sampled from GENEX.BMP for browse window styling

## Fallback Behavior

Falls back to bundled base skin sprites for missing PLEDIT.BMP, EQMAIN.BMP, EQ_EX.BMP, GEN.BMP, MB.BMP, or TITLEBAR.BMP (when easter egg titlebar sprites are missing).

**MB.BMP fallback is all-or-nothing:** if a skin lacks MB.BMP, both MB.BMP and GEN.BMP revert to base (no mixing custom GEN.BMP with base MB.BMP).

**TITLEBAR.BMP fallback** triggers when easter egg sprites (rows 5-6, y=57/y=72) are absent; `hasNativeEasterEggTitlebar` flag lets views decide whether to use the skin's GenExColors or defaults for the settings window chrome.

## Building & Testing

```bash
swift build
swift test
```

Tests use **Swift Testing framework** (`@Suite`, `@Test`, `#expect`), not XCTest.
