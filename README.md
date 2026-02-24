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

## Standing on the shoulders of Webamp

This project would not exist without [Webamp](https://github.com/captbaritone/webamp) by Jordan Eldredge. The Winamp skin format was never formally documented — the only "spec" was the original Winamp source code and the community knowledge built around it. Webamp's faithful open-source reimplementation made all of that knowledge accessible: sprite sheet coordinates, layout composition rules, character rendering offsets, equalizer slider geometry, and countless other details we relied on to parse WSZ files and assemble their sprites into a pixel-accurate interface. Parsing BMP sprite sheets and getting every pixel in the right place would have been a far more daunting undertaking without Webamp lighting the way. Thank you, Jordan, and all Webamp contributors.

## Acknowledgments

- [Webamp](https://github.com/captbaritone/webamp) by Jordan Eldredge (see above)
