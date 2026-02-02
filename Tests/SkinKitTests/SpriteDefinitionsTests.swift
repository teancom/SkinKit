import Testing
import CoreGraphics
@testable import SkinKit

@Suite("SpriteDefinitions Tests")
struct SpriteDefinitionsTests {

    @Test("Returns correct file for sprite")
    func returnsCorrectFileForSprite() {
        let file = SpriteDefinitions.bmpFile(for: .mainPlayButton)
        #expect(file == .cbuttons)

        let mainFile = SpriteDefinitions.bmpFile(for: .mainWindowBackground)
        #expect(mainFile == .main)

        let volumeFile = SpriteDefinitions.bmpFile(for: .mainVolumeThumb)
        #expect(volumeFile == .volume)
    }

    @Test("Returns correct region for sprite")
    func returnsCorrectRegionForSprite() {
        let region = SpriteDefinitions.region(for: .mainPlayButton)

        #expect(region != nil)
        #expect(region?.x == 23)
        #expect(region?.y == 0)
        #expect(region?.width == 23)
        #expect(region?.height == 18)
    }

    @Test("Lists all sprites for file")
    func listsAllSpritesForFile() {
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

    @Test("BMP file enum has expected files")
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
        #expect(SpriteDefinitions.BMPFile.volume.filename == "VOLUME.BMP")
    }

    @Test("Character sprites are properly mapped")
    func characterSpritesAreProperlyMapped() {
        let textSprites = SpriteDefinitions.sprites(in: .text)

        #expect(textSprites.contains(.characterA))
        #expect(textSprites.contains(.character0))
        #expect(textSprites.contains(.characterSpace))
        #expect(textSprites.count > 50)  // Lots of characters
    }

    @Test("Numbers are properly distributed")
    func numbersAreProperlyDistributed() {
        let numberSprites = SpriteDefinitions.sprites(in: .numbers)

        #expect(numberSprites.contains(.digit0))
        #expect(numberSprites.contains(.digit9))
        #expect(numberSprites.contains(.minusSign))
        #expect(numberSprites.count == 12)  // 10 digits + 2 signs
    }

    @Test("All main buttons are in cbuttons file")
    func allMainButtonsAreInCbuttonsFile() {
        let cbuttonSprites = SpriteDefinitions.sprites(in: .cbuttons)

        let mainButtons: [SpriteName] = [
            .mainPreviousButton, .mainPreviousButtonActive,
            .mainPlayButton, .mainPlayButtonActive,
            .mainPauseButton, .mainPauseButtonActive,
            .mainStopButton, .mainStopButtonActive,
            .mainNextButton, .mainNextButtonActive,
            .mainEjectButton, .mainEjectButtonActive,
        ]

        for button in mainButtons {
            #expect(cbuttonSprites.contains(button))
        }
    }

    @Test("Regions are valid (non-negative)")
    func regionsAreValid() {
        for sprite in SpriteName.allCases {
            guard let region = SpriteDefinitions.region(for: sprite) else {
                continue
            }

            #expect(region.x >= 0)
            #expect(region.y >= 0)
            #expect(region.width > 0)
            #expect(region.height > 0)
        }
    }
}
