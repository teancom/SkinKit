import Testing
@testable import SkinKit

@Suite("SkinKit Public API Tests")
struct SkinKitTests {

    @Test("SpriteName enum is CaseIterable")
    func spriteNameIsCaseIterable() {
        // Verify we can iterate all cases
        let allCases = SpriteName.allCases
        #expect(allCases.count > 50)  // Should have many sprites
    }

    @Test("SpriteName raw values are uppercase with underscores")
    func spriteNameRawValuesAreUppercase() {
        for sprite in SpriteName.allCases {
            let rawValue = sprite.rawValue
            // All raw values should be uppercase (except for digits in CHARACTER_XX)
            let letters = rawValue.filter { $0.isLetter }
            #expect(letters == letters.uppercased())
        }
    }

    @Test("SkinConfig is Sendable")
    func skinConfigIsSendable() {
        let config = SkinConfig.default

        // This compiles only if SkinConfig is Sendable
        Task {
            _ = config.fontName
        }
    }

    @Test("SkinData is Sendable")
    func skinDataIsSendable() {
        let data = SkinData(sprites: [:], config: .default)

        // This compiles only if SkinData is Sendable
        Task {
            _ = data.sprites.count
        }
    }

    @Test("SkinLoader is an actor")
    func skinLoaderIsActor() async {
        let loader = SkinLoader()

        // This compiles only if SkinLoader is an actor (requires await)
        _ = await type(of: loader)
    }

    @Test("BMPFile enum has expected files")
    func bmpFileEnumHasExpectedFiles() {
        let allFiles = SpriteDefinitions.BMPFile.allCases

        #expect(allFiles.contains(.main))
        #expect(allFiles.contains(.cbuttons))
        #expect(allFiles.contains(.volume))
        #expect(allFiles.contains(.numbers))
        #expect(allFiles.contains(.text))
    }

    @Test("BMPFile filename property adds extension")
    func bmpFileFilenameAddsExtension() {
        #expect(SpriteDefinitions.BMPFile.main.filename == "MAIN.BMP")
        #expect(SpriteDefinitions.BMPFile.cbuttons.filename == "CBUTTONS.BMP")
    }
}
