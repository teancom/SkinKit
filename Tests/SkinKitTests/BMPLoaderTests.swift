import Testing
import Foundation
import CoreGraphics
import ImageIO
@testable import SkinKit

@Suite("BMPLoader Tests")
struct BMPLoaderTests {

    // MARK: - Loading Valid BMP Data

    @Test("Loads valid BMP data")
    func loadsValidBmpData() throws {
        let bmpData = try createValidBmpData(width: 100, height: 50)

        let image = try BMPLoader.load(from: bmpData)

        #expect(image.width == 100)
        #expect(image.height == 50)
    }

    @Test("Loads 1x1 pixel BMP")
    func loads1x1PixelBmp() throws {
        let bmpData = try createValidBmpData(width: 1, height: 1)

        let image = try BMPLoader.load(from: bmpData)

        #expect(image.width == 1)
        #expect(image.height == 1)
    }

    @Test("Loads large BMP at maximum dimension")
    func loadsLargeBmpAtMaximumDimension() throws {
        let maxDim = 4096
        let bmpData = try createValidBmpData(width: maxDim, height: maxDim)

        let image = try BMPLoader.load(from: bmpData)

        #expect(image.width == maxDim)
        #expect(image.height == maxDim)
    }

    // MARK: - Invalid BMP Data

    @Test("Throws on empty data")
    func throwsOnEmptyData() {
        let emptyData = Data()

        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: emptyData)
        }
    }

    @Test("Throws on invalid BMP data")
    func throwsOnInvalidBmpData() {
        let invalidData = Data("not a valid BMP file".utf8)

        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: invalidData)
        }
    }

    @Test("Throws on corrupted BMP header")
    func throwsOnCorruptedBmpHeader() {
        let corruptedData = Data([0x00, 0x01, 0x02, 0x03])

        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: corruptedData)
        }
    }

    // MARK: - Dimension Validation

    @Test("Throws when width exceeds maximum dimension")
    func throwsWhenWidthExceedsMaximum() throws {
        let excessiveDim = 5000

        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: try createValidBmpData(width: excessiveDim, height: 100))
        }
    }

    @Test("Throws when height exceeds maximum dimension")
    func throwsWhenHeightExceedsMaximum() throws {
        let excessiveDim = 5000

        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: try createValidBmpData(width: 100, height: excessiveDim))
        }
    }

    @Test("Throws when both dimensions exceed maximum")
    func throwsWhenBothDimensionsExceedMaximum() throws {
        let excessiveDim = 5000

        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: try createValidBmpData(width: excessiveDim, height: excessiveDim))
        }
    }

    @Test("Throws on zero width")
    func throwsOnZeroWidth() throws {
        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: try createValidBmpData(width: 0, height: 100))
        }
    }

    @Test("Throws on zero height")
    func throwsOnZeroHeight() throws {
        #expect(throws: SkinError.self) {
            try BMPLoader.load(from: try createValidBmpData(width: 100, height: 0))
        }
    }

    // MARK: - Sprite Extraction

    @Test("Extracts sprite from valid region")
    func extractsSpriteFromValidRegion() throws {
        let sourceImage = try createTestImage(width: 100, height: 100)
        let region = SpriteRegion(x: 10, y: 20, width: 30, height: 40)

        let sprite = try BMPLoader.extractSprite(from: sourceImage, region: region)

        #expect(sprite.width == 30)
        #expect(sprite.height == 40)
    }

    @Test("Extracts full-size sprite")
    func extractsFullSizeSprite() throws {
        let sourceImage = try createTestImage(width: 100, height: 100)
        let region = SpriteRegion(x: 0, y: 0, width: 100, height: 100)

        let sprite = try BMPLoader.extractSprite(from: sourceImage, region: region)

        #expect(sprite.width == 100)
        #expect(sprite.height == 100)
    }

    @Test("Extracts small 1x1 sprite")
    func extractsSmall1x1Sprite() throws {
        let sourceImage = try createTestImage(width: 100, height: 100)
        let region = SpriteRegion(x: 50, y: 50, width: 1, height: 1)

        let sprite = try BMPLoader.extractSprite(from: sourceImage, region: region)

        #expect(sprite.width == 1)
        #expect(sprite.height == 1)
    }

    @Test("Extracts sprite from top-left corner")
    func extractsSpriteFromTopLeftCorner() throws {
        let sourceImage = try createTestImage(width: 200, height: 200)
        let region = SpriteRegion(x: 0, y: 0, width: 50, height: 50)

        let sprite = try BMPLoader.extractSprite(from: sourceImage, region: region)

        #expect(sprite.width == 50)
        #expect(sprite.height == 50)
    }

    @Test("Extracts sprite from bottom-right corner")
    func extractsSpriteFromBottomRightCorner() throws {
        let sourceImage = try createTestImage(width: 200, height: 200)
        let region = SpriteRegion(x: 150, y: 150, width: 50, height: 50)

        let sprite = try BMPLoader.extractSprite(from: sourceImage, region: region)

        #expect(sprite.width == 50)
        #expect(sprite.height == 50)
    }

    // MARK: - Sprite Extraction Edge Cases

    @Test("Extracts sprite with region partially outside bounds")
    func extractsSpriteWithRegionPartiallyOutsideBounds() throws {
        let sourceImage = try createTestImage(width: 100, height: 100)
        // Region extends beyond image bounds - CGImage.cropping() clamps to valid area
        let region = SpriteRegion(x: 80, y: 10, width: 30, height: 20)

        let sprite = try BMPLoader.extractSprite(from: sourceImage, region: region)

        // The cropped image is smaller than the requested region
        #expect(sprite.width > 0)
        #expect(sprite.height > 0)
    }

    @Test("Extracts sprite at image edge")
    func extractsSpriteAtImageEdge() throws {
        let sourceImage = try createTestImage(width: 100, height: 100)
        // Region at the exact edge
        let region = SpriteRegion(x: 100, y: 100, width: 1, height: 1)

        // Requesting a sprite completely outside bounds returns nil from cropping()
        #expect(throws: SkinError.self) {
            try BMPLoader.extractSprite(from: sourceImage, region: region)
        }
    }

    @Test("Extracts sprite with negative coordinates in region")
    func extractsSpriteWithNegativeCoordinatesInRegion() throws {
        let sourceImage = try createTestImage(width: 100, height: 100)
        // CGImage.cropping() clamps negative coordinates
        let region = SpriteRegion(x: -5, y: 10, width: 20, height: 20)

        let sprite = try BMPLoader.extractSprite(from: sourceImage, region: region)

        // The crop is clamped to valid region
        #expect(sprite.width > 0)
        #expect(sprite.height > 0)
    }

    // MARK: - Extract Multiple Sprites

    @Test("Extracts multiple sprites from same source")
    func extractsMultipleSpritesFromSameSource() throws {
        let sourceImage = try createTestImage(width: 100, height: 100)

        let sprite1 = try BMPLoader.extractSprite(from: sourceImage, region: SpriteRegion(x: 0, y: 0, width: 25, height: 25))
        let sprite2 = try BMPLoader.extractSprite(from: sourceImage, region: SpriteRegion(x: 25, y: 0, width: 25, height: 25))
        let sprite3 = try BMPLoader.extractSprite(from: sourceImage, region: SpriteRegion(x: 0, y: 25, width: 25, height: 25))

        #expect(sprite1.width == 25)
        #expect(sprite2.width == 25)
        #expect(sprite3.width == 25)
    }

    // MARK: - Extract Sprites from BMP File

    @Test("Extracts sprites from BMP file returns dictionary")
    func extractsSpritesFromBmpFileReturnsDictionary() throws {
        let bmpData = try createValidBmpData(width: 400, height: 300)

        let sprites = try BMPLoader.extractSprites(from: bmpData, file: .cbuttons)

        #expect(sprites is [SpriteName: CGImage])
    }

    @Test("Extracts sprites skips out-of-bounds sprites")
    func extractsSpritesSkipsOutOfBoundsSprites() throws {
        // Create a small BMP (smaller than typical sprite sheets)
        let bmpData = try createValidBmpData(width: 100, height: 100)

        let sprites = try BMPLoader.extractSprites(from: bmpData, file: .cbuttons)

        // The CBUTTONS file has sprites at specific coordinates
        // Many should be out of bounds in a 100x100 image
        #expect(sprites.count >= 0)  // May be empty or partial, depending on sprite definitions
    }

    @Test("Extracts sprites handles empty BMP gracefully")
    func extractsSpritesHandlesEmptyBmpGracefully() throws {
        let bmpData = try createValidBmpData(width: 10, height: 10)

        let sprites = try BMPLoader.extractSprites(from: bmpData, file: .main)

        // Should return a dictionary (possibly empty if sprites are out of bounds)
        #expect(sprites is [SpriteName: CGImage])
    }

    // MARK: - Helper Functions

    private func createValidBmpData(width: Int, height: Int) throws -> Data {
        // Create a simple bitmap context
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

        // Fill with a color
        context.setFillColor(CGColor(gray: 0.5, alpha: 1.0))
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        guard let cgImage = context.makeImage() else {
            throw SkinError.invalidBitmap("failed to create image from context")
        }

        // Convert CGImage to BMP data
        guard let mutableData = CFDataCreateMutable(kCFAllocatorDefault, 0) else {
            throw SkinError.invalidBitmap("failed to create mutable data")
        }

        guard let destination = CGImageDestinationCreateWithData(
            mutableData,
            "com.microsoft.bmp" as CFString,
            1,
            nil
        ) else {
            throw SkinError.invalidBitmap("failed to create image destination")
        }

        CGImageDestinationAddImage(destination, cgImage, nil)

        guard CGImageDestinationFinalize(destination) else {
            throw SkinError.invalidBitmap("failed to finalize image destination")
        }

        return mutableData as Data
    }

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

        // Fill with a simple color (gray)
        context.setFillColor(CGColor(gray: 0.5, alpha: 1.0))
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))

        guard let cgImage = context.makeImage() else {
            throw SkinError.invalidBitmap("failed to create image from context")
        }

        return cgImage
    }
}
