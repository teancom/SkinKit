# SkinKit

A Swift library for parsing Winamp WSZ skin files. macOS 15+, Swift 6.0.

SkinKit extracts sprite graphics from WSZ skin archives (ZIP files containing BMP sprite sheets) and slices them into individual UI elements for rendering Winamp-style interfaces.

## Usage

```swift
import SkinKit

let loader = SkinLoader()
let skinData = try await loader.load(from: skinURL)

// Access individual sprites
if let playButton = skinData.sprites[.cButtonPlay] {
    // Use CGImage...
}

// Access GenEx colors for window styling
if let colors = skinData.genExColors {
    // colors.windowBackground, colors.buttonFace, etc.
}
```

## Adding to Your Project

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/teancom/SkinKit.git", branch: "main"),
]
```

## Key Types

| Type | Purpose |
|------|---------|
| `SkinLoader` | Actor that extracts and slices skin files |
| `SkinData` | Dictionary of `[SpriteName: CGImage]` + colors |
| `SpriteName` | Enum with ~350 cases for all sprite elements |
| `BMPLoader` | BMP→CGImage converter with color sampling |
| `GenExColors` | 22 colors sampled from GENEX.BMP |

## Building & Testing

```bash
swift build
swift test
```
