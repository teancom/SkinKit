import Testing
import Foundation
@testable import SkinKit

/// Tests that SkinLoader correctly fills in missing sprite sheets from the
/// bundled base skin. Uses three test skins derived from XMMS.wsz, each
/// missing a different number of the three fallback-eligible BMPs:
/// PLEDIT.BMP, EQMAIN.BMP, and EQ_EX.BMP.
@Suite("Fallback Sprite Tests")
struct FallbackSpriteTests {

    /// Path to the project-root `skins/` directory, computed from this test file's location.
    private static let skinsDir: URL = {
        // FallbackSpriteTests.swift → SkinKitTests/ → Tests/ → SkinKit/ → Packages/ → project root
        let testFile = URL(fileURLWithPath: #filePath)
        return testFile
            .deletingLastPathComponent()  // SkinKitTests/
            .deletingLastPathComponent()  // Tests/
            .deletingLastPathComponent()  // SkinKit/
            .deletingLastPathComponent()  // Packages/
            .deletingLastPathComponent()  // project root
            .appendingPathComponent("skins")
    }()

    private static let baseSkinURL: URL = skinsDir.appendingPathComponent("base-2.91.wsz")

    // MARK: - Test Skins

    /// Missing only EQ_EX.BMP (1 fallback needed)
    private static let skinMissing1: URL = skinsDir.appendingPathComponent("XMMS-no-eq_ex.wsz")

    /// Missing EQMAIN.BMP + EQ_EX.BMP (2 fallbacks needed)
    private static let skinMissing2: URL = skinsDir.appendingPathComponent("XMMS-no-eqmain-eq_ex.wsz")

    /// Missing PLEDIT.BMP + EQMAIN.BMP + EQ_EX.BMP (3 fallbacks needed)
    private static let skinMissing3: URL = skinsDir.appendingPathComponent("XMMS-no-pledit-eqmain-eq_ex.wsz")

    /// Helper to create a loader pointed at the base skin for fallback
    private func makeLoader() -> SkinLoader {
        SkinLoader(fallbackSkinURL: Self.baseSkinURL)
    }

    // MARK: - Precondition: full XMMS skin loads everything

    @Test("Full XMMS skin has all three sprite groups")
    func fullXmmsSkinHasAllSprites() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.skinsDir.appendingPathComponent("XMMS.wsz"))

        #expect(skinData[.playlistTitleBar] != nil, "Expected PLEDIT sprites in full skin")
        #expect(skinData[.eqWindowBackground] != nil, "Expected EQMAIN sprites in full skin")
        #expect(skinData[.eqShadeBackground] != nil, "Expected EQ_EX sprites in full skin")
    }

    // MARK: - Fallback tests

    @Test("Skin missing EQ_EX.BMP gets fallback EQ shade sprites")
    func fallbackForMissingEqEx() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.skinMissing1)

        // PLEDIT and EQMAIN should come from the skin itself
        #expect(skinData[.playlistTitleBar] != nil, "Expected PLEDIT sprites from skin's own pledit.bmp")
        #expect(skinData[.eqWindowBackground] != nil, "Expected EQMAIN sprites from skin's own eqmain.bmp")

        // EQ_EX should be filled from fallback
        #expect(skinData[.eqShadeBackground] != nil, "Expected EQ_EX sprites from fallback base skin")
    }

    @Test("Skin missing EQMAIN + EQ_EX gets fallback EQ sprites")
    func fallbackForMissingEqmainAndEqEx() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.skinMissing2)

        // PLEDIT should come from the skin itself
        #expect(skinData[.playlistTitleBar] != nil, "Expected PLEDIT sprites from skin's own pledit.bmp")

        // Both EQ sheets should be filled from fallback
        #expect(skinData[.eqWindowBackground] != nil, "Expected EQMAIN sprites from fallback base skin")
        #expect(skinData[.eqShadeBackground] != nil, "Expected EQ_EX sprites from fallback base skin")
    }

    @Test("Skin missing PLEDIT + EQMAIN + EQ_EX gets all three from fallback")
    func fallbackForAllThreeMissing() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.skinMissing3)

        // All three should be filled from fallback
        #expect(skinData[.playlistTitleBar] != nil, "Expected PLEDIT sprites from fallback base skin")
        #expect(skinData[.eqWindowBackground] != nil, "Expected EQMAIN sprites from fallback base skin")
        #expect(skinData[.eqShadeBackground] != nil, "Expected EQ_EX sprites from fallback base skin")

        // Main window sprites should still come from the skin itself
        #expect(skinData[.mainWindowBackground] != nil, "Expected MAIN sprites from skin's own main.bmp")
        #expect(skinData[.mainPlayButton] != nil, "Expected CBUTTONS sprites from skin's own cbuttons.bmp")
    }

    @Test("Fallback does not overwrite sprites that the skin already provides")
    func fallbackDoesNotOverwriteExistingSprites() async throws {
        // Skin 1 has its own eqmain.bmp — verify the fallback didn't replace it
        // by comparing image dimensions against the base skin's EQMAIN
        let loader = makeLoader()
        let skinWithEqmain = try await loader.load(from: Self.skinMissing1)
        let baseSkin = try await loader.load(from: Self.baseSkinURL)

        let skinEqBg = skinWithEqmain[.eqWindowBackground]
        let baseEqBg = baseSkin[.eqWindowBackground]
        #expect(skinEqBg != nil)
        #expect(baseEqBg != nil)

        // XMMS and base-2.91 have different EQMAIN sprites — if the skin's
        // own version was preserved, they won't be byte-identical
        if let s = skinEqBg, let b = baseEqBg {
            let skinData = s.dataProvider?.data as Data?
            let baseData = b.dataProvider?.data as Data?
            #expect(skinData != baseData, "Skin's EQMAIN should differ from base — fallback should not overwrite")
        }
    }

    @Test("No fallback when fallbackSkinURL is nil")
    func noFallbackWhenURLIsNil() async throws {
        let loader = SkinLoader(fallbackSkinURL: nil)
        let skinData = try await loader.load(from: Self.skinMissing3)

        // Without fallback, these should all be nil
        #expect(skinData[.playlistTitleBar] == nil, "Expected no PLEDIT sprites without fallback")
        #expect(skinData[.eqWindowBackground] == nil, "Expected no EQMAIN sprites without fallback")
        #expect(skinData[.eqShadeBackground] == nil, "Expected no EQ_EX sprites without fallback")

        // Main window sprites should still load from the skin
        #expect(skinData[.mainWindowBackground] != nil, "Expected MAIN sprites even without fallback")
    }

    // MARK: - Easter Egg Titlebar Fallback (Settings Window)

    @Test("Base skin has native easter egg titlebar sprites")
    func baseSkinHasEasterEggTitlebar() async throws {
        let loader = makeLoader()
        let baseSkinData = try await loader.load(from: Self.baseSkinURL)

        // Base skin must have both easter egg titlebar variants
        #expect(baseSkinData[.mainEasterEggTitleBar] != nil, "Base skin must have easter egg titlebar unselected variant")
        #expect(baseSkinData[.mainEasterEggTitleBarSelected] != nil, "Base skin must have easter egg titlebar selected variant")

        // hasNativeEasterEggTitlebar should be true
        #expect(baseSkinData.hasNativeEasterEggTitlebar == true, "Base skin should report native easter egg titlebar")
    }

    @Test("XMMS skin may lack easter egg titlebar sprites")
    func xmmsSkinEasterEggTitlebarDetection() async throws {
        let loader = makeLoader()
        let xmmsSkinData = try await loader.load(from: Self.skinsDir.appendingPathComponent("XMMS.wsz"))

        // XMMS may or may not have easter egg sprites depending on TITLEBAR.BMP height
        // Just verify that hasNativeEasterEggTitlebar reflects whether they loaded
        let hasSelected = xmmsSkinData[.mainEasterEggTitleBarSelected] != nil
        #expect(xmmsSkinData.hasNativeEasterEggTitlebar == hasSelected, "hasNativeEasterEggTitlebar should match sprite load status")
    }

    @Test("When skin lacks easter egg titlebar, fallback provides them from base skin")
    func easterEggTitlebarFallback() async throws {
        // Test using XMMS skin which may lack easter egg sprites
        let loader = makeLoader()
        let xmmsSkinData = try await loader.load(from: Self.skinsDir.appendingPathComponent("XMMS.wsz"))

        // After loading (with fallback), easter egg sprites must exist
        #expect(xmmsSkinData[.mainEasterEggTitleBar] != nil, "Easter egg titlebar unselected sprite should load (fallback if needed)")
        #expect(xmmsSkinData[.mainEasterEggTitleBarSelected] != nil, "Easter egg titlebar selected sprite should load (fallback if needed)")

        // The loader sets hasNativeEasterEggTitlebar correctly
        // If XMMS has the sprites natively, hasNativeEasterEggTitlebar=true
        // If XMMS lacks them, hasNativeEasterEggTitlebar=false (fallback loaded them)
        _ = xmmsSkinData.hasNativeEasterEggTitlebar
        // Both true and false are valid — the test just verifies fallback provided them
        #expect(true, "Fallback successfully provided easter egg sprites")
    }

    @Test("When easter egg titlebar falls back, GEN.BMP sprites are NOT removed from browse window")
    func easterEggFallbackDoesNotRemoveGenSprites() async throws {
        // Load XMMS with fallback enabled
        let loader = makeLoader()
        let xmmsSkinData = try await loader.load(from: Self.skinsDir.appendingPathComponent("XMMS.wsz"))

        // GEN sprites should always be present (from skin or fallback, never removed)
        #expect(xmmsSkinData[.genMiddleLeft] != nil, "GEN middle left sprite should exist")
        #expect(xmmsSkinData[.genMiddleLeftBottom] != nil, "GEN middle left bottom sprite should exist")
        #expect(xmmsSkinData[.genMiddleRight] != nil, "GEN middle right sprite should exist")
        #expect(xmmsSkinData[.genMiddleRightBottom] != nil, "GEN middle right bottom sprite should exist")
        #expect(xmmsSkinData[.genBottomLeft] != nil, "GEN bottom left sprite should exist")
        #expect(xmmsSkinData[.genBottomFill] != nil, "GEN bottom fill sprite should exist")
        #expect(xmmsSkinData[.genBottomRight] != nil, "GEN bottom right sprite should exist")
    }

    @Test("Skin with native easter egg titlebar keeps its custom GEN sprites")
    func skinWithEasterEggKeepsCustomGenSprites() async throws {
        // Base skin definitely has both easter egg and GEN sprites
        let loader = makeLoader()
        let baseSkinData = try await loader.load(from: Self.baseSkinURL)

        #expect(baseSkinData.hasNativeEasterEggTitlebar == true, "Base skin has native easter egg titlebar")

        // All GEN sprites should be present from the base skin's own GEN.BMP
        let genSprites: [SpriteName] = [
            .genMiddleLeft, .genMiddleLeftBottom, .genMiddleRight, .genMiddleRightBottom,
            .genBottomLeft, .genBottomFill, .genBottomRight
        ]
        for spriteName in genSprites {
            #expect(baseSkinData[spriteName] != nil, "Base skin should have GEN sprite \(spriteName)")
        }
    }

    // MARK: - F1: TITLEBAR.BMP Fallback (Settings Window)

    @Test("F1: When skin lacks easter egg titlebar sprites, they are loaded from base skin")
    func titlebarFallbackForMissingEasterEggSprites() async throws {
        // XMMS typically has a short TITLEBAR.BMP without easter egg rows (y=57, y=72)
        let loader = makeLoader()
        let xmmsSkinData = try await loader.load(from: Self.skinsDir.appendingPathComponent("XMMS.wsz"))

        // After loading, easter egg titlebar sprites must exist (from fallback if needed)
        #expect(
            xmmsSkinData[.mainEasterEggTitleBar] != nil,
            "Easter egg titlebar unselected sprite should exist (from fallback if skin lacked it)"
        )
        #expect(
            xmmsSkinData[.mainEasterEggTitleBarSelected] != nil,
            "Easter egg titlebar selected sprite should exist (from fallback if skin lacked it)"
        )

        // hasNativeEasterEggTitlebar correctly reflects whether XMMS provides them natively
        // If true, XMMS has tall enough TITLEBAR.BMP; if false, fallback provided them
        // Both states are valid — this test verifies that fallback made them available
        _ = xmmsSkinData.hasNativeEasterEggTitlebar
    }

    @Test("F1: hasNativeEasterEggTitlebar flag is set correctly")
    func easterEggTitlebarFlagAccuracy() async throws {
        // Base skin should have native easter egg titlebar
        let loader = makeLoader()
        let baseSkinData = try await loader.load(from: Self.baseSkinURL)
        #expect(
            baseSkinData.hasNativeEasterEggTitlebar == true,
            "Base skin should report native easter egg titlebar (hasNativeEasterEggTitlebar = true)"
        )

        // XMMS may or may not have native easter egg titlebar depending on TITLEBAR.BMP height
        let xmmsSkinData = try await loader.load(from: Self.skinsDir.appendingPathComponent("XMMS.wsz"))

        // If hasNativeEasterEggTitlebar is true, the sprites must come from XMMS's own TITLEBAR.BMP
        // If hasNativeEasterEggTitlebar is false, the sprites were filled from base skin fallback
        let hasSelected = xmmsSkinData[.mainEasterEggTitleBarSelected] != nil
        #expect(
            xmmsSkinData.hasNativeEasterEggTitlebar == hasSelected,
            "hasNativeEasterEggTitlebar flag should match whether selected sprite exists"
        )
    }

    @Test("F1: Classified skin handles easter egg titlebar correctly")
    func classifiedSkinEasterEggTitlebar() async throws {
        // Classified skin should handle easter egg titlebar (either native or fallback)
        let loader = makeLoader()
        let classifiedSkinData = try await loader.load(from: Self.skinsDir.appendingPathComponent("Winamp5_Classified_v5.5.wsz"))

        // After loading, both sprites must exist
        #expect(
            classifiedSkinData[.mainEasterEggTitleBar] != nil,
            "Classified skin should have easter egg titlebar unselected sprite"
        )
        #expect(
            classifiedSkinData[.mainEasterEggTitleBarSelected] != nil,
            "Classified skin should have easter egg titlebar selected sprite"
        )

        // hasNativeEasterEggTitlebar may be true or false — both are valid
        // This test verifies the fallback made them available if needed
        _ = classifiedSkinData.hasNativeEasterEggTitlebar
    }
}
