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
}
