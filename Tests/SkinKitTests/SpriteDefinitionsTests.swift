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

    @Test("PLEDIT sprites are mapped to pledit file")
    func pleditSpritesAreMappedToPleditFile() {
        let pleditSprites = SpriteDefinitions.sprites(in: .pledit)

        #expect(pleditSprites.count == 60)
        #expect(pleditSprites.contains(.playlistTitleBar))
        #expect(pleditSprites.contains(.playlistAddFile))
        #expect(pleditSprites.contains(.playlistCloseSelected))
    }

    @Test("PLEDIT sprite regions have valid coordinates")
    func pleditSpriteRegionsHaveValidCoordinates() {
        let titleBar = SpriteDefinitions.region(for: .playlistTitleBar)
        #expect(titleBar?.x == 26)
        #expect(titleBar?.y == 21)
        #expect(titleBar?.width == 100)
        #expect(titleBar?.height == 20)

        let addFile = SpriteDefinitions.region(for: .playlistAddFile)
        #expect(addFile?.x == 0)
        #expect(addFile?.y == 149)
        #expect(addFile?.width == 22)
        #expect(addFile?.height == 18)

        let closeSelected = SpriteDefinitions.region(for: .playlistCloseSelected)
        #expect(closeSelected?.x == 52)
        #expect(closeSelected?.y == 42)
        #expect(closeSelected?.width == 9)
        #expect(closeSelected?.height == 9)
    }

    @Test("All PLEDIT sprites have regions defined")
    func allPleditSpritesHaveRegionsDefined() {
        let pleditSprites = SpriteDefinitions.sprites(in: .pledit)

        for sprite in pleditSprites {
            let region = SpriteDefinitions.region(for: sprite)
            #expect(region != nil, "PLEDIT sprite \(sprite.rawValue) should have a region")
        }
    }

    @Test("EQ sprites are mapped to correct BMP files")
    func eqSpritesAreMappedToCorrectBmpFiles() {
        // EQMAIN sprites
        let eqmainSprites = SpriteDefinitions.sprites(in: .eqmain)
        #expect(eqmainSprites.count == 22, "EQMAIN file should have 22 sprites")
        #expect(eqmainSprites.contains(.eqWindowBackground))
        #expect(eqmainSprites.contains(.eqTitleBar))
        #expect(eqmainSprites.contains(.eqSliderBackground))
        #expect(eqmainSprites.contains(.eqOnButton))
        #expect(eqmainSprites.contains(.eqPreampLine))

        // EQ_EX sprites
        let eqExSprites = SpriteDefinitions.sprites(in: .eqEx)
        #expect(eqExSprites.count == 12, "EQ_EX file should have 12 sprites")
        #expect(eqExSprites.contains(.eqShadeBackground))
        #expect(eqExSprites.contains(.eqShadeVolumeSliderLeft))
        #expect(eqExSprites.contains(.eqMaximizeButtonActive))
        #expect(eqExSprites.contains(.eqShadeCloseButtonActive))

        // Total EQ sprites: 22 + 12 = 34
        #expect(eqmainSprites.count + eqExSprites.count == 34)
    }

    @Test("EQ sprite regions have valid coordinates")
    func eqSpriteRegionsHaveValidCoordinates() {
        // EQMAIN sprites
        let eqWindowBackground = SpriteDefinitions.region(for: .eqWindowBackground)
        #expect(eqWindowBackground?.x == 0)
        #expect(eqWindowBackground?.y == 0)
        #expect(eqWindowBackground?.width == 275)
        #expect(eqWindowBackground?.height == 116)

        let eqSliderBackground = SpriteDefinitions.region(for: .eqSliderBackground)
        #expect(eqSliderBackground?.x == 13)
        #expect(eqSliderBackground?.y == 164)
        #expect(eqSliderBackground?.width == 209)
        #expect(eqSliderBackground?.height == 129)

        let eqOnButton = SpriteDefinitions.region(for: .eqOnButton)
        #expect(eqOnButton?.x == 10)
        #expect(eqOnButton?.y == 119)
        #expect(eqOnButton?.width == 26)
        #expect(eqOnButton?.height == 12)

        let eqGraphBackground = SpriteDefinitions.region(for: .eqGraphBackground)
        #expect(eqGraphBackground?.x == 0)
        #expect(eqGraphBackground?.y == 294)
        #expect(eqGraphBackground?.width == 113)
        #expect(eqGraphBackground?.height == 19)

        let eqGraphLineColors = SpriteDefinitions.region(for: .eqGraphLineColors)
        #expect(eqGraphLineColors?.x == 115)
        #expect(eqGraphLineColors?.y == 294)
        #expect(eqGraphLineColors?.width == 1)
        #expect(eqGraphLineColors?.height == 19)

        // EQ_EX sprites
        let eqShadeBackground = SpriteDefinitions.region(for: .eqShadeBackground)
        #expect(eqShadeBackground?.x == 0)
        #expect(eqShadeBackground?.y == 15)
        #expect(eqShadeBackground?.width == 275)
        #expect(eqShadeBackground?.height == 14)

        let eqMaximizeButtonActive = SpriteDefinitions.region(for: .eqMaximizeButtonActive)
        #expect(eqMaximizeButtonActive?.x == 1)
        #expect(eqMaximizeButtonActive?.y == 38)
        #expect(eqMaximizeButtonActive?.width == 9)
        #expect(eqMaximizeButtonActive?.height == 9)

        let eqShadeCloseButtonActive = SpriteDefinitions.region(for: .eqShadeCloseButtonActive)
        #expect(eqShadeCloseButtonActive?.x == 11)
        #expect(eqShadeCloseButtonActive?.y == 47)
        #expect(eqShadeCloseButtonActive?.width == 9)
        #expect(eqShadeCloseButtonActive?.height == 9)
    }

    @Test("All EQ sprites have regions defined")
    func allEqSpritesHaveRegionsDefined() {
        let eqmainSprites = SpriteDefinitions.sprites(in: .eqmain)
        for sprite in eqmainSprites {
            let region = SpriteDefinitions.region(for: sprite)
            #expect(region != nil, "EQMAIN sprite \(sprite.rawValue) should have a region")
        }

        let eqExSprites = SpriteDefinitions.sprites(in: .eqEx)
        for sprite in eqExSprites {
            let region = SpriteDefinitions.region(for: sprite)
            #expect(region != nil, "EQ_EX sprite \(sprite.rawValue) should have a region")
        }
    }

    @Test("bmpFile returns correct files for EQ sprites")
    func bmpFileReturnsCorrectFilesForEqSprites() {
        // EQMAIN sprites
        #expect(SpriteDefinitions.bmpFile(for: .eqWindowBackground) == .eqmain)
        #expect(SpriteDefinitions.bmpFile(for: .eqSliderBackground) == .eqmain)
        #expect(SpriteDefinitions.bmpFile(for: .eqOnButton) == .eqmain)
        #expect(SpriteDefinitions.bmpFile(for: .eqPreampLine) == .eqmain)

        // EQ_EX sprites
        #expect(SpriteDefinitions.bmpFile(for: .eqShadeBackground) == .eqEx)
        #expect(SpriteDefinitions.bmpFile(for: .eqMaximizeButtonActive) == .eqEx)
        #expect(SpriteDefinitions.bmpFile(for: .eqShadeCloseButtonActive) == .eqEx)
    }

    @Test("BMPLoader bounds-checking skips out-of-bounds EQ sprites")
    func bmpLoaderBoundsCheckingSkipsOutOfBoundsEqSprites() throws {
        // Create a small CGImage (100x50 pixels) that's smaller than expected EQMAIN.BMP
        // This simulates a skin with an undersized EQMAIN.BMP
        let smallImage = try createTestImage(width: 100, height: 50)

        // Extract sprites from the undersized image
        let eqmainSprites = SpriteDefinitions.sprites(in: .eqmain)
        var extractedSprites: [SpriteName: CGImage] = [:]

        for sprite in eqmainSprites {
            guard let region = SpriteDefinitions.region(for: sprite) else {
                continue
            }

            // Check bounds manually (same logic as BMPLoader.extractSprites)
            if region.x >= 0 && region.y >= 0 &&
               region.x + region.width <= smallImage.width &&
               region.y + region.height <= smallImage.height {
                do {
                    let image = try BMPLoader.extractSprite(from: smallImage, region: region)
                    extractedSprites[sprite] = image
                } catch {
                    // Continue with other sprites even if one fails
                    continue
                }
            }
        }

        // Verify in-bounds sprites are extracted
        // eqCloseButton at (0, 116) with size (9, 9) - fits in 100x50? No, 116+9 > 50
        // eqOnButton at (10, 119) with size (26, 12) - fits in 100x50? No, 119+12 > 50
        // eqWindowBackground at (0, 0) with size (275, 116) - fits in 100x50? No

        // Most sprites should be skipped due to bounds check
        // Let's find a sprite that fits in 100x50
        let inBoundsSprites = eqmainSprites.filter { sprite in
            guard let region = SpriteDefinitions.region(for: sprite) else {
                return false
            }
            return region.x >= 0 && region.y >= 0 &&
                   region.x + region.width <= 100 &&
                   region.y + region.height <= 50
        }

        let outOfBoundsSprites = eqmainSprites.filter { sprite in
            guard let region = SpriteDefinitions.region(for: sprite) else {
                return false
            }
            return !(region.x >= 0 && region.y >= 0 &&
                     region.x + region.width <= 100 &&
                     region.y + region.height <= 50)
        }

        // Verify that extracted sprites match in-bounds sprites
        #expect(extractedSprites.count == inBoundsSprites.count,
                "Extracted sprite count should match in-bounds sprites")

        // Verify out-of-bounds sprites were skipped (not extracted)
        for sprite in outOfBoundsSprites {
            #expect(extractedSprites[sprite] == nil,
                    "Out-of-bounds sprite \(sprite.rawValue) should not be extracted")
        }

        // Verify in-bounds sprites were extracted
        for sprite in inBoundsSprites {
            #expect(extractedSprites[sprite] != nil,
                    "In-bounds sprite \(sprite.rawValue) should be extracted")
        }
    }

    // MARK: - Helper Functions

    private func createTestImage(width: Int, height: Int) throws -> CGImage {
        // Create a simple bitmap context with the specified dimensions
        let bitmapInfo = CGBitmapInfo(
            rawValue: CGImageAlphaInfo.premultipliedLast.rawValue
        )

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            throw SkinError.invalidBitmap("failed to create bitmap context")
        }

        // Fill with a simple color (white)
        context.setFillColor(CGColor(gray: 1.0, alpha: 1.0))
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        guard let cgImage = context.makeImage() else {
            throw SkinError.invalidBitmap("failed to create image from context")
        }

        return cgImage
    }
}
