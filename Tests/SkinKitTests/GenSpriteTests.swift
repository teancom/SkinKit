import Testing
import Foundation
import CoreGraphics
@testable import SkinKit

/// Tests that SkinLoader correctly extracts all 20 GEN.BMP sprite regions
/// from various skins, including skins with lowercase `gen.bmp` filenames
/// and skins missing GEN.BMP entirely (which fall back to base skin).
@Suite("GEN Sprite Tests")
struct GenSpriteTests {

    /// Path to the test `Fixtures/` directory, computed from this test file's location.
    private static let skinsDir: URL = {
        let testFile = URL(fileURLWithPath: #filePath)
        return testFile
            .deletingLastPathComponent()  // SkinKitTests/
            .appendingPathComponent("Fixtures")
    }()

    private static let baseSkinURL: URL = skinsDir.appendingPathComponent("base-2.91.wsz")

    // MARK: - Test Skins

    /// Base skin with GEN.BMP (used as fallback)
    private static let baseSkin: URL = baseSkinURL

    /// Winamp5_Classified uses lowercase `gen.bmp` (tests case-insensitive matching)
    private static let classifiedSkin: URL = skinsDir.appendingPathComponent("Winamp5_Classified_v5.5.wsz")

    /// XMMS-no-pledit-eqmain-eq_ex unlikely to have GEN.BMP; should fall back to base
    private static let skinMissingOptionalBMPs: URL = skinsDir.appendingPathComponent("XMMS-no-pledit-eqmain-eq_ex.wsz")

    /// Helper to create a loader pointed at the base skin for fallback
    private func makeLoader() -> SkinLoader {
        SkinLoader(fallbackSkinURL: Self.baseSkinURL)
    }

    // MARK: - Utility: Check sprite dimensions

    /// Helper to verify a sprite exists and has expected dimensions
    private func expectSpriteWithDimensions(
        _ sprite: CGImage?,
        name: String,
        width: Int,
        height: Int
    ) {
        #expect(sprite != nil, "Expected \(name) to be non-nil")
        if let sprite = sprite {
            #expect(sprite.width == width, "Expected \(name) width \(width), got \(sprite.width)")
            #expect(sprite.height == height, "Expected \(name) height \(height), got \(sprite.height)")
        }
    }

    // MARK: - gen-bmp-browse.AC1.1: Base skin extraction

    @Test("Base skin has all 20 GEN sprites with correct dimensions")
    func baseGenSpritesHaveCorrectDimensions() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkin)

        // Title bar (selected) — 6 sprites, 25x20 each
        expectSpriteWithDimensions(skinData[.genTopLeftSelected], name: "genTopLeftSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftEndSelected], name: "genTopLeftEndSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopCenterFillSelected], name: "genTopCenterFillSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightEndSelected], name: "genTopRightEndSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftRightFillSelected], name: "genTopLeftRightFillSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightSelected], name: "genTopRightSelected", width: 25, height: 20)

        // Title bar (unselected) — 6 sprites, 25x20 each
        expectSpriteWithDimensions(skinData[.genTopLeft], name: "genTopLeft", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftEnd], name: "genTopLeftEnd", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopCenterFill], name: "genTopCenterFill", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightEnd], name: "genTopRightEnd", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftRightFill], name: "genTopLeftRightFill", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRight], name: "genTopRight", width: 25, height: 20)

        // Bottom bar and edges
        expectSpriteWithDimensions(skinData[.genBottomLeft], name: "genBottomLeft", width: 125, height: 14)
        expectSpriteWithDimensions(skinData[.genBottomRight], name: "genBottomRight", width: 125, height: 14)
        expectSpriteWithDimensions(skinData[.genBottomFill], name: "genBottomFill", width: 25, height: 14)
        expectSpriteWithDimensions(skinData[.genMiddleLeft], name: "genMiddleLeft", width: 11, height: 29)
        expectSpriteWithDimensions(skinData[.genMiddleLeftBottom], name: "genMiddleLeftBottom", width: 11, height: 24)
        expectSpriteWithDimensions(skinData[.genMiddleRight], name: "genMiddleRight", width: 8, height: 29)
        expectSpriteWithDimensions(skinData[.genMiddleRightBottom], name: "genMiddleRightBottom", width: 8, height: 24)
        expectSpriteWithDimensions(skinData[.genCloseSelected], name: "genCloseSelected", width: 9, height: 9)
    }

    // MARK: - gen-bmp-browse.AC1.2: Lowercase gen.bmp matching

    @Test("Classified skin with lowercase gen.bmp extracts all 20 GEN sprites")
    func classifiedGenSpritesExtractSuccessfully() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.classifiedSkin)

        // All 20 should exist with correct dimensions
        expectSpriteWithDimensions(skinData[.genTopLeftSelected], name: "genTopLeftSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftEndSelected], name: "genTopLeftEndSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopCenterFillSelected], name: "genTopCenterFillSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightEndSelected], name: "genTopRightEndSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftRightFillSelected], name: "genTopLeftRightFillSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightSelected], name: "genTopRightSelected", width: 25, height: 20)

        expectSpriteWithDimensions(skinData[.genTopLeft], name: "genTopLeft", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftEnd], name: "genTopLeftEnd", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopCenterFill], name: "genTopCenterFill", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightEnd], name: "genTopRightEnd", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftRightFill], name: "genTopLeftRightFill", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRight], name: "genTopRight", width: 25, height: 20)

        expectSpriteWithDimensions(skinData[.genBottomLeft], name: "genBottomLeft", width: 125, height: 14)
        expectSpriteWithDimensions(skinData[.genBottomRight], name: "genBottomRight", width: 125, height: 14)
        expectSpriteWithDimensions(skinData[.genBottomFill], name: "genBottomFill", width: 25, height: 14)
        expectSpriteWithDimensions(skinData[.genMiddleLeft], name: "genMiddleLeft", width: 11, height: 29)
        expectSpriteWithDimensions(skinData[.genMiddleLeftBottom], name: "genMiddleLeftBottom", width: 11, height: 24)
        expectSpriteWithDimensions(skinData[.genMiddleRight], name: "genMiddleRight", width: 8, height: 29)
        expectSpriteWithDimensions(skinData[.genMiddleRightBottom], name: "genMiddleRightBottom", width: 8, height: 24)
        expectSpriteWithDimensions(skinData[.genCloseSelected], name: "genCloseSelected", width: 9, height: 9)
    }

    // MARK: - gen-bmp-browse.AC1.4: Fallback for missing GEN.BMP

    @Test("Skin missing GEN.BMP falls back to base skin sprites")
    func fallbackForMissingGenBmp() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.skinMissingOptionalBMPs)

        // All 20 should still exist (from fallback) with correct dimensions
        expectSpriteWithDimensions(skinData[.genTopLeftSelected], name: "genTopLeftSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftEndSelected], name: "genTopLeftEndSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopCenterFillSelected], name: "genTopCenterFillSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightEndSelected], name: "genTopRightEndSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftRightFillSelected], name: "genTopLeftRightFillSelected", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightSelected], name: "genTopRightSelected", width: 25, height: 20)

        expectSpriteWithDimensions(skinData[.genTopLeft], name: "genTopLeft", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftEnd], name: "genTopLeftEnd", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopCenterFill], name: "genTopCenterFill", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRightEnd], name: "genTopRightEnd", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopLeftRightFill], name: "genTopLeftRightFill", width: 25, height: 20)
        expectSpriteWithDimensions(skinData[.genTopRight], name: "genTopRight", width: 25, height: 20)

        expectSpriteWithDimensions(skinData[.genBottomLeft], name: "genBottomLeft", width: 125, height: 14)
        expectSpriteWithDimensions(skinData[.genBottomRight], name: "genBottomRight", width: 125, height: 14)
        expectSpriteWithDimensions(skinData[.genBottomFill], name: "genBottomFill", width: 25, height: 14)
        expectSpriteWithDimensions(skinData[.genMiddleLeft], name: "genMiddleLeft", width: 11, height: 29)
        expectSpriteWithDimensions(skinData[.genMiddleLeftBottom], name: "genMiddleLeftBottom", width: 11, height: 24)
        expectSpriteWithDimensions(skinData[.genMiddleRight], name: "genMiddleRight", width: 8, height: 29)
        expectSpriteWithDimensions(skinData[.genMiddleRightBottom], name: "genMiddleRightBottom", width: 8, height: 24)
        expectSpriteWithDimensions(skinData[.genCloseSelected], name: "genCloseSelected", width: 9, height: 9)
    }

    // MARK: - Additional: SpriteDefinitions verification

    @Test("SpriteDefinitions contains exactly 20 GEN sprites")
    func spriteDefinitionsContainsAllGenSprites() {
        let genSprites = SpriteDefinitions.sprites(in: .gen)
        #expect(genSprites.count == 20, "Expected exactly 20 GEN sprites, got \(genSprites.count)")
    }

    @Test("All GEN sprites are defined in spriteRegions")
    func allGenSpritesAreDefinedInSpriteRegions() {
        let genSprites = SpriteDefinitions.sprites(in: .gen)

        for sprite in genSprites {
            let region = SpriteDefinitions.region(for: sprite)
            #expect(region != nil, "Expected region definition for \(sprite.rawValue)")
        }
    }
}
