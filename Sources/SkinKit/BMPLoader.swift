import Foundation
import CoreGraphics
import ImageIO

/// Loads BMP image files and extracts sprite regions as CGImages.
public struct BMPLoader: Sendable {

    /// Load a BMP image from raw data.
    /// - Parameter data: Raw BMP file data.
    /// - Returns: CGImage if loading succeeds.
    /// - Throws: SkinError if the data is invalid.
    /// Maximum allowed dimension for skin BMPs (pixels per axis).
    /// The largest legitimate Winamp sprite sheet is ~800px wide. 4096 provides
    /// generous headroom while still rejecting decompression bombs.
    private static let maxDimension = 4096

    public static func load(from data: Data) throws -> CGImage {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            throw SkinError.invalidBitmap("failed to create image source")
        }

        guard let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
            throw SkinError.invalidBitmap("failed to create image from source")
        }

        // Guard against decompression bombs from malicious/corrupt skin files
        guard image.width > 0, image.height > 0,
              image.width <= maxDimension, image.height <= maxDimension else {
            throw SkinError.invalidBitmap(
                "image dimensions \(image.width)x\(image.height) exceed maximum \(maxDimension)x\(maxDimension)"
            )
        }

        return image
    }

    /// Extract a sprite region from a source image.
    /// - Parameters:
    ///   - source: The source CGImage (full sprite sheet).
    ///   - region: The region to extract.
    /// - Returns: Cropped CGImage for the sprite.
    /// - Throws: SkinError if cropping fails.
    public static func extractSprite(from source: CGImage, region: SpriteRegion) throws -> CGImage {
        let rect = CGRect(
            x: region.x,
            y: region.y,
            width: region.width,
            height: region.height
        )

        guard let cropped = source.cropping(to: rect) else {
            throw SkinError.invalidBitmap("failed to crop sprite at \(rect)")
        }

        return cropped
    }

    /// Extract all sprites from a BMP file for a given sheet type.
    /// - Parameters:
    ///   - data: Raw BMP file data.
    ///   - file: The BMP file type (determines which sprites to extract).
    /// - Returns: Dictionary mapping sprite names to their extracted images.
    /// - Throws: SkinError if loading or extraction fails.
    public static func extractSprites(
        from data: Data,
        file: SpriteDefinitions.BMPFile
    ) throws -> [SpriteName: CGImage] {
        let source = try load(from: data)
        let sprites = SpriteDefinitions.sprites(in: file)

        var result: [SpriteName: CGImage] = [:]

        for sprite in sprites {
            guard let region = SpriteDefinitions.region(for: sprite) else {
                continue
            }

            // Validate region is within bounds
            guard region.x >= 0 && region.y >= 0 &&
                  region.x + region.width <= source.width &&
                  region.y + region.height <= source.height else {
                // Skip sprites that don't fit - some skins have smaller images
                continue
            }

            do {
                let image = try extractSprite(from: source, region: region)
                result[sprite] = image
            } catch {
                // Continue with other sprites even if one fails
                continue
            }
        }

        return result
    }

    /// Read the color of a single pixel from a CGImage.
    /// - Parameters:
    ///   - image: The source CGImage.
    ///   - x: The x-coordinate of the pixel.
    ///   - y: The y-coordinate of the pixel.
    /// - Returns: The pixel color as a CGColor in sRGB color space.
    /// - Throws: SkinError if coordinates are out of bounds or context creation fails.
    public static func readPixelColor(from image: CGImage, x: Int, y: Int) throws -> CGColor {
        guard x >= 0, x < image.width, y >= 0, y < image.height else {
            throw SkinError.invalidBitmap("pixel (\(x), \(y)) out of bounds (\(image.width)x\(image.height))")
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var pixel: [UInt8] = [0, 0, 0, 0]  // RGBA
        guard let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            throw SkinError.invalidBitmap("failed to create pixel context")
        }

        // Draw the single pixel into our 1x1 context
        context.draw(image, in: CGRect(
            x: -CGFloat(x),
            y: -CGFloat(image.height - 1 - y),
            width: CGFloat(image.width),
            height: CGFloat(image.height)
        ))

        let r = CGFloat(pixel[0]) / 255.0
        let g = CGFloat(pixel[1]) / 255.0
        let b = CGFloat(pixel[2]) / 255.0
        return CGColor(colorSpace: colorSpace, components: [r, g, b, 1.0])!
    }

    /// Extract variable-width GEN.BMP font character sprites using pixel scanning.
    ///
    /// GEN.BMP contains two font rows:
    /// - y=88: Selected/highlighted characters (A-Z)
    /// - y=96: Normal/unhighlighted characters (A-Z)
    ///
    /// Characters have variable widths. Boundaries are detected by scanning for
    /// the background color (sampled at x=0 of each row). Characters are separated
    /// by 1-pixel gaps of background color.
    ///
    /// Based on Webamp's `genGenTextSprites()` algorithm.
    public static func extractGenFontSprites(from image: CGImage) throws -> [SpriteName: CGImage] {
        let letters: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let fontHeight = 7
        let rows: [(y: Int, selected: Bool)] = [(88, true), (96, false)]

        var sprites: [SpriteName: CGImage] = [:]

        for (rowY, selected) in rows {
            // Ensure the font row fits within the image
            guard rowY + fontHeight <= image.height else { continue }

            // Get background color at x=0
            let bgColor = try readPixelColor(from: image, x: 0, y: rowY)
            let bgComponents = bgColor.components ?? [0, 0, 0, 1]

            var x = 1  // Start scanning after 1-pixel background margin

            for letter in letters {
                // Find end of character (next background pixel)
                var nextBg = x
                while nextBg < image.width {
                    let pixelColor = try readPixelColor(from: image, x: nextBg, y: rowY)
                    let pixelComponents = pixelColor.components ?? [0, 0, 0, 1]
                    if colorsMatch(bgComponents, pixelComponents) {
                        break
                    }
                    nextBg += 1
                }

                let charWidth = nextBg - x
                guard charWidth > 0 else {
                    x = nextBg + 1
                    continue
                }

                let region = SpriteRegion(x: x, y: rowY, width: charWidth, height: fontHeight)
                if let sprite = try? extractSprite(from: image, region: region),
                   let spriteName = SpriteName.genFont(letter, selected: selected) {
                    sprites[spriteName] = sprite
                }

                x = nextBg + 1  // Skip 1-pixel gap
            }
        }

        return sprites
    }

    /// Compare two CGColor component arrays for approximate equality.
    private static func colorsMatch(
        _ a: [CGFloat],
        _ b: [CGFloat],
        tolerance: CGFloat = 0.01
    ) -> Bool {
        guard a.count >= 3, b.count >= 3 else { return false }
        return abs(a[0] - b[0]) < tolerance
            && abs(a[1] - b[1]) < tolerance
            && abs(a[2] - b[2]) < tolerance
    }
}
