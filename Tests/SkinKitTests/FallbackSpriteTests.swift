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
}
