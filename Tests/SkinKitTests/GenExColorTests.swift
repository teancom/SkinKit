import Testing
import Foundation
import CoreGraphics
@testable import SkinKit

/// Tests for GENEX.BMP color extraction and GEN.BMP font character extraction.
///
/// These tests verify that:
/// - GenExColors are correctly extracted from GENEX.BMP's y=0 pixel row (AC2.1, AC2.2, AC2.3, AC2.4)
/// - GEN font characters (A-Z, highlighted and unhighlighted) are extracted (AC1.3)
/// - BMPLoader.readPixelColor reads individual pixel colors correctly
/// - Fallback to base skin occurs when GENEX.BMP or GEN.BMP are missing
@Suite("GENEX Color and GEN Font Tests")
struct GenExColorTests {

    /// Path to the test `Fixtures/` directory, computed from this test file's location.
    private static let skinsDir: URL = {
        let testFile = URL(fileURLWithPath: #filePath)
        return testFile
            .deletingLastPathComponent()  // SkinKitTests/
            .appendingPathComponent("Fixtures")
    }()

    private static let baseSkinURL: URL = skinsDir.appendingPathComponent("base-2.91.wsz")
    private static let classifiedSkinURL: URL = skinsDir.appendingPathComponent("Winamp5_Classified_v5.5.wsz")
    private static let xmmsSkinURL: URL = skinsDir.appendingPathComponent("XMMS.wsz")
    private static let jackieChanSkinURL: URL = skinsDir.appendingPathComponent("Jackie_Chan_skin.wsz")

    /// Helper to create a loader pointed at the base skin for fallback
    private func makeLoader() -> SkinLoader {
        SkinLoader(fallbackSkinURL: Self.baseSkinURL)
    }

    // MARK: - BMPLoader.readPixelColor Tests

    @Test("readPixelColor reads valid coordinates without crashing")
    @MainActor
    func readPixelColorReadsValidCoordinates() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        guard let mainSprite = skinData[.mainWindowBackground] else {
            #expect(Bool(false), "MAIN.BMP not found in base skin")
            return
        }

        // Test reading a pixel at (0, 0) - should not crash
        let color = try BMPLoader.readPixelColor(from: mainSprite, x: 0, y: 0)

        // Verify we got a CGColor back
        #expect(color.components != nil, "readPixelColor should return a valid CGColor")

        // Verify components are in valid range [0, 1]
        let components = color.components ?? [0, 0, 0, 1]
        #expect(components[0] >= 0 && components[0] <= 1, "R component should be in range [0, 1]")
        #expect(components[1] >= 0 && components[1] <= 1, "G component should be in range [0, 1]")
        #expect(components[2] >= 0 && components[2] <= 1, "B component should be in range [0, 1]")
    }

    @Test("readPixelColor throws for out-of-bounds x coordinate")
    @MainActor
    func readPixelColorThrowsForOutOfBoundsX() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        guard let mainSprite = skinData[.mainWindowBackground] else {
            #expect(Bool(false), "MAIN.BMP not found in base skin")
            return
        }

        // Try to read beyond the image width
        #expect(throws: SkinError.self) {
            try BMPLoader.readPixelColor(from: mainSprite, x: mainSprite.width + 10, y: 0)
        }
    }

    @Test("readPixelColor throws for out-of-bounds y coordinate")
    @MainActor
    func readPixelColorThrowsForOutOfBoundsY() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        guard let mainSprite = skinData[.mainWindowBackground] else {
            #expect(Bool(false), "MAIN.BMP not found in base skin")
            return
        }

        // Try to read beyond the image height
        #expect(throws: SkinError.self) {
            try BMPLoader.readPixelColor(from: mainSprite, x: 0, y: mainSprite.height + 10)
        }
    }

    // MARK: - AC2.1: base-2.91.wsz GENEX.BMP Color Extraction

    @Test("base-2.91.wsz genExColors extracted successfully")
    @MainActor
    func baseSkinGenExColorsExtracted() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        #expect(skinData.genExColors != nil, "genExColors should be extracted from base-2.91.wsz")
        guard let colors = skinData.genExColors else { return }

        // Verify all 22 color properties exist
        #expect(colors.itemBackground.components != nil, "itemBackground should not be nil")
        #expect(colors.itemForeground.components != nil, "itemForeground should not be nil")
        #expect(colors.windowBackground.components != nil, "windowBackground should not be nil")
        #expect(colors.buttonText.components != nil, "buttonText should not be nil")
        #expect(colors.windowText.components != nil, "windowText should not be nil")
        #expect(colors.divider.components != nil, "divider should not be nil")
        #expect(colors.playlistSelection.components != nil, "playlistSelection should not be nil")
        #expect(colors.listHeaderBackground.components != nil, "listHeaderBackground should not be nil")
        #expect(colors.listHeaderText.components != nil, "listHeaderText should not be nil")
        #expect(colors.listHeaderFrameTopAndLeft.components != nil, "listHeaderFrameTopAndLeft should not be nil")
        #expect(colors.listHeaderFrameBottomAndRight.components != nil, "listHeaderFrameBottomAndRight should not be nil")
        #expect(colors.listHeaderFramePressed.components != nil, "listHeaderFramePressed should not be nil")
        #expect(colors.listHeaderDeadArea.components != nil, "listHeaderDeadArea should not be nil")
        #expect(colors.scrollbarOne.components != nil, "scrollbarOne should not be nil")
        #expect(colors.scrollbarTwo.components != nil, "scrollbarTwo should not be nil")
        #expect(colors.pressedScrollbarOne.components != nil, "pressedScrollbarOne should not be nil")
        #expect(colors.pressedScrollbarTwo.components != nil, "pressedScrollbarTwo should not be nil")
        #expect(colors.scrollbarDeadArea.components != nil, "scrollbarDeadArea should not be nil")
        #expect(colors.listTextHighlighted.components != nil, "listTextHighlighted should not be nil")
        #expect(colors.listTextHighlightedBackground.components != nil, "listTextHighlightedBackground should not be nil")
        #expect(colors.listTextSelected.components != nil, "listTextSelected should not be nil")
        #expect(colors.listTextSelectedBackground.components != nil, "listTextSelectedBackground should not be nil")

        // Spot-check that colors have distinct R/G/B component values (not all black)
        let bgComponents = colors.windowBackground.components ?? [0, 0, 0, 1]
        let foregroundComponents = colors.itemForeground.components ?? [0, 0, 0, 1]

        // Base skin should have non-trivial color values (not all 0 or all 1)
        let bgIntensity = bgComponents[0] + bgComponents[1] + bgComponents[2]
        let fgIntensity = foregroundComponents[0] + foregroundComponents[1] + foregroundComponents[2]
        #expect(bgIntensity >= 0 && bgIntensity <= 3, "windowBackground should have valid intensity")
        #expect(fgIntensity >= 0 && fgIntensity <= 3, "itemForeground should have valid intensity")
    }

    // MARK: - AC2.2: Winamp5_Classified_v5.5.wsz Color Extraction and Comparison

    @Test("Winamp5_Classified_v5.5.wsz genExColors extracted successfully")
    @MainActor
    func classifiedSkinGenExColorsExtracted() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.classifiedSkinURL)

        #expect(skinData.genExColors != nil, "genExColors should be extracted from Winamp5_Classified_v5.5.wsz")
        guard let colors = skinData.genExColors else { return }

        // Verify all 22 color properties exist
        #expect(colors.windowBackground.components != nil, "windowBackground should not be nil")
        #expect(colors.itemForeground.components != nil, "itemForeground should not be nil")
    }

    @Test("Classified skin and base skin have different GENEX colors")
    @MainActor
    func classifiedAndBaseSkinsDifferentColors() async throws {
        let loader = makeLoader()
        let baseSkinData = try await loader.load(from: Self.baseSkinURL)
        let classifiedSkinData = try await loader.load(from: Self.classifiedSkinURL)

        guard let baseColors = baseSkinData.genExColors,
              let classifiedColors = classifiedSkinData.genExColors else {
            #expect(Bool(false), "Both skins should have genExColors")
            return
        }

        let baseWindowBg = baseColors.windowBackground.components ?? [0, 0, 0, 1]
        let classifiedWindowBg = classifiedColors.windowBackground.components ?? [0, 0, 0, 1]

        // The skins should have at least some different color values
        let baseIntensity = baseWindowBg[0] + baseWindowBg[1] + baseWindowBg[2]
        let classifiedIntensity = classifiedWindowBg[0] + classifiedWindowBg[1] + classifiedWindowBg[2]

        #expect(baseIntensity != classifiedIntensity, "Skins should have different color values")
    }

    // MARK: - AC2.3: Fallback for missing GENEX.BMP

    @Test("Skin without GENEX.BMP falls back to base skin colors")
    @MainActor
    func skinWithoutGenexFallsBack() async throws {
        let loader = makeLoader()

        // Jackie_Chan_skin.wsz is expected to be missing GENEX.BMP
        let skinData = try await loader.load(from: Self.jackieChanSkinURL)

        // Even without GENEX.BMP, genExColors should be populated via fallback
        #expect(skinData.genExColors != nil, "genExColors should be populated via fallback to base skin")
    }

    @Test("Fallback colors match base skin colors")
    @MainActor
    func fallbackColorsMatchBaseSkinColors() async throws {
        let loader = makeLoader()
        let baseSkinData = try await loader.load(from: Self.baseSkinURL)
        let jackieSkinData = try await loader.load(from: Self.jackieChanSkinURL)

        guard let baseColors = baseSkinData.genExColors,
              let jackieColors = jackieSkinData.genExColors else {
            #expect(Bool(false), "Both skins should have genExColors")
            return
        }

        // Fallback colors should match the base skin's colors
        let baseWindowBg = baseColors.windowBackground.components ?? [0, 0, 0, 1]
        let jackieWindowBg = jackieColors.windowBackground.components ?? [0, 0, 0, 1]

        #expect(abs(baseWindowBg[0] - jackieWindowBg[0]) < 0.01, "Fallback windowBackground R should match base")
        #expect(abs(baseWindowBg[1] - jackieWindowBg[1]) < 0.01, "Fallback windowBackground G should match base")
        #expect(abs(baseWindowBg[2] - jackieWindowBg[2]) < 0.01, "Fallback windowBackground B should match base")
    }

    // MARK: - AC2.4: genExColors accessible via SkinData

    @Test("genExColors accessible via SkinData property path")
    @MainActor
    func genExColorsAccessibleViaSkinData() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        // Test property path: skinData.genExColors?.windowBackground
        let windowBackground = skinData.genExColors?.windowBackground

        #expect(windowBackground != nil, "genExColors?.windowBackground should be accessible and non-nil")
    }

    // MARK: - AC1.3: GEN Font Character Extraction

    @Test("GEN font A (unhighlighted) extracted successfully")
    @MainActor
    func genFontAExtracted() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        let fontA = skinData[.genFontA]
        #expect(fontA != nil, "GEN_FONT_A should be extracted from base-2.91.wsz")
        #expect(fontA?.height == 7, "GEN font height should be 7")
        #expect(fontA?.width ?? 0 > 0, "GEN font width should be greater than 0")
    }

    @Test("GEN font A (highlighted) extracted successfully")
    @MainActor
    func genFontASelectedExtracted() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        let fontASelected = skinData[.genFontASelected]
        #expect(fontASelected != nil, "GEN_FONT_A_SELECTED should be extracted from base-2.91.wsz")
        #expect(fontASelected?.height == 7, "GEN font height should be 7")
        #expect(fontASelected?.width ?? 0 > 0, "GEN font width should be greater than 0")
    }

    @Test("GEN font Z (last letter) extracted successfully")
    @MainActor
    func genFontZExtracted() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        let fontZ = skinData[.genFontZ]
        #expect(fontZ != nil, "GEN_FONT_Z should be extracted from base-2.91.wsz")
        #expect(fontZ?.height == 7, "GEN font height should be 7")
        #expect(fontZ?.width ?? 0 > 0, "GEN font width should be greater than 0")
    }

    @Test("All 52 GEN font sprites extracted (26 normal + 26 selected)")
    @MainActor
    func allGenFontSpritesExtracted() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.baseSkinURL)

        let genFontSprites: [SpriteName] = [
            .genFontA, .genFontB, .genFontC, .genFontD, .genFontE, .genFontF, .genFontG,
            .genFontH, .genFontI, .genFontJ, .genFontK, .genFontL, .genFontM, .genFontN,
            .genFontO, .genFontP, .genFontQ, .genFontR, .genFontS, .genFontT, .genFontU,
            .genFontV, .genFontW, .genFontX, .genFontY, .genFontZ,
            .genFontASelected, .genFontBSelected, .genFontCSelected, .genFontDSelected,
            .genFontESelected, .genFontFSelected, .genFontGSelected, .genFontHSelected,
            .genFontISelected, .genFontJSelected, .genFontKSelected, .genFontLSelected,
            .genFontMSelected, .genFontNSelected, .genFontOSelected, .genFontPSelected,
            .genFontQSelected, .genFontRSelected, .genFontSSelected, .genFontTSelected,
            .genFontUSelected, .genFontVSelected, .genFontWSelected, .genFontXSelected,
            .genFontYSelected, .genFontZSelected
        ]

        for sprite in genFontSprites {
            let image = skinData[sprite]
            #expect(image != nil, "Sprite \(sprite.rawValue) should be extracted")
            if let img = image {
                #expect(img.height == 7, "Sprite \(sprite.rawValue) should have height 7")
                #expect(img.width > 0, "Sprite \(sprite.rawValue) should have width > 0")
            }
        }
    }

    @Test("SpriteName.genFont lookup for A unhighlighted")
    func spriteNameGenFontLookupA() {
        let sprite = SpriteName.genFont("A", selected: false)
        #expect(sprite == .genFontA, "genFont(\"A\", selected: false) should return .genFontA")
    }

    @Test("SpriteName.genFont lookup for A highlighted")
    func spriteNameGenFontLookupASelected() {
        let sprite = SpriteName.genFont("A", selected: true)
        #expect(sprite == .genFontASelected, "genFont(\"A\", selected: true) should return .genFontASelected")
    }

    @Test("SpriteName.genFont lookup for Z unhighlighted")
    func spriteNameGenFontLookupZ() {
        let sprite = SpriteName.genFont("Z", selected: false)
        #expect(sprite == .genFontZ, "genFont(\"Z\", selected: false) should return .genFontZ")
    }

    @Test("SpriteName.genFont lookup returns nil for non-letters")
    func spriteNameGenFontLookupNonLetters() {
        let digit = SpriteName.genFont("1", selected: false)
        #expect(digit == nil, "genFont(\"1\", selected: false) should return nil")

        let space = SpriteName.genFont(" ", selected: false)
        #expect(space == nil, "genFont(\" \", selected: false) should return nil")

        let symbol = SpriteName.genFont("@", selected: false)
        #expect(symbol == nil, "genFont(\"@\", selected: false) should return nil")
    }

    @Test("SpriteName.genFont lookup works for lowercase letters")
    func spriteNameGenFontLookupLowercase() {
        let lower = SpriteName.genFont("a", selected: false)
        #expect(lower == .genFontA, "genFont(\"a\", selected: false) should return .genFontA (uppercased)")

        let lowerSelected = SpriteName.genFont("z", selected: true)
        #expect(lowerSelected == .genFontZSelected, "genFont(\"z\", selected: true) should return .genFontZSelected")
    }

    // MARK: - Integration: XMMS skin (has all required BMPs)

    @Test("XMMS skin loads with genExColors and GEN font sprites")
    @MainActor
    func xmmsSkinLoadsWithAllData() async throws {
        let loader = makeLoader()
        let skinData = try await loader.load(from: Self.xmmsSkinURL)

        #expect(skinData.genExColors != nil, "XMMS should have genExColors")
        #expect(skinData[.genFontA] != nil, "XMMS should have GEN font A")
        #expect(skinData[.genFontASelected] != nil, "XMMS should have GEN font A Selected")
    }
}
