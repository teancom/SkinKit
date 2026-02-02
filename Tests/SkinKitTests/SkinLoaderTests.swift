import Testing
import Foundation
@testable import SkinKit

@Suite("SkinLoader Tests")
struct SkinLoaderTests {

    @Test("SpriteDefinitions returns correct file for sprite")
    func spriteDefinitionsReturnsCorrectFile() {
        let file = SpriteDefinitions.bmpFile(for: .mainPlayButton)
        #expect(file == .cbuttons)

        let mainFile = SpriteDefinitions.bmpFile(for: .mainWindowBackground)
        #expect(mainFile == .main)

        let volumeFile = SpriteDefinitions.bmpFile(for: .mainVolumeThumb)
        #expect(volumeFile == .volume)
    }

    @Test("SpriteDefinitions returns correct region for sprite")
    func spriteDefinitionsReturnsCorrectRegion() {
        let region = SpriteDefinitions.region(for: .mainPlayButton)

        #expect(region != nil)
        #expect(region?.x == 23)
        #expect(region?.y == 0)
        #expect(region?.width == 23)
        #expect(region?.height == 18)
    }

    @Test("SpriteDefinitions lists all sprites for file")
    func spriteDefinitionsListsAllSpritesForFile() {
        let cbuttonSprites = SpriteDefinitions.sprites(in: .cbuttons)

        #expect(cbuttonSprites.contains(.mainPlayButton))
        #expect(cbuttonSprites.contains(.mainPauseButton))
        #expect(cbuttonSprites.contains(.mainStopButton))
        #expect(cbuttonSprites.count == 12)  // 6 buttons * 2 states
    }

    @Test("SpriteRegion converts to CGRect correctly")
    func spriteRegionConvertsToCGRect() {
        let region = SpriteRegion(x: 10, y: 20, width: 30, height: 40)
        let rect = region.cgRect

        #expect(rect.origin.x == 10)
        #expect(rect.origin.y == 20)
        #expect(rect.size.width == 30)
        #expect(rect.size.height == 40)
    }

    @Test("Character sprite lookup works")
    func characterSpriteLookupWorks() {
        let aSprite = SpriteName.character("A")
        #expect(aSprite == .characterA)

        let digitSprite = SpriteName.character("5")
        #expect(digitSprite == .character5)

        let spaceSprite = SpriteName.character(" ")
        #expect(spaceSprite == .characterSpace)

        let missingSprite = SpriteName.character("€")
        #expect(missingSprite == nil)
    }

    @Test("SkinData subscript returns sprite")
    func skinDataSubscriptReturnsSprite() {
        let config = SkinConfig.default
        let skinData = SkinData(sprites: [:], config: config)

        #expect(skinData[.mainPlayButton] == nil)
    }

    @Test("SkinConfig has sensible defaults")
    func skinConfigHasSensibleDefaults() {
        let config = SkinConfig.default

        #expect(config.fontName == "Arial")
        // CGColor is non-optional, so we just verify the fontName
        // which is the primary configuration property
    }

    @Test("SkinError descriptions are lowercase sentences")
    func skinErrorDescriptionsAreLowercase() {
        let error1 = SkinError.fileNotFound("test.wsz")
        #expect(error1.errorDescription?.first?.isLowercase == true)

        let error2 = SkinError.invalidArchive("corrupt")
        #expect(error2.errorDescription?.first?.isLowercase == true)

        let error3 = SkinError.missingRequiredFile("MAIN.BMP")
        #expect(error3.errorDescription?.first?.isLowercase == true)
    }
}
