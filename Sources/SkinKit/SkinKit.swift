import Foundation
import CoreGraphics

/// SkinKit provides parsing and sprite extraction for Winamp-style WSZ skin files.
///
/// The library extracts BMP sprite sheets from WSZ archives (which are ZIP files)
/// and slices them into individual CGImage sprites based on coordinate definitions
/// ported from the Webamp project.

/// Configuration extracted from a skin's pledit.txt file.
public struct SkinConfig: Sendable {
    public let normalTextColor: CGColor
    public let currentTextColor: CGColor
    public let normalBackgroundColor: CGColor
    public let selectedBackgroundColor: CGColor
    public let fontName: String

    public init(
        normalTextColor: CGColor,
        currentTextColor: CGColor,
        normalBackgroundColor: CGColor,
        selectedBackgroundColor: CGColor,
        fontName: String
    ) {
        self.normalTextColor = normalTextColor
        self.currentTextColor = currentTextColor
        self.normalBackgroundColor = normalBackgroundColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.fontName = fontName
    }

    /// Default Winamp skin configuration (green on black).
    public static let `default` = SkinConfig(
        normalTextColor: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
        currentTextColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1),
        normalBackgroundColor: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
        selectedBackgroundColor: CGColor(red: 0, green: 0, blue: 0.5, alpha: 1),
        fontName: "Arial"
    )
}

/// The complete data extracted from a Winamp skin file.
public struct SkinData: Sendable {
    /// Dictionary mapping sprite names to their extracted images.
    public let sprites: [SpriteName: CGImage]

    /// Configuration from pledit.txt (colors, font).
    public let config: SkinConfig

    public init(sprites: [SpriteName: CGImage], config: SkinConfig) {
        self.sprites = sprites
        self.config = config
    }

    /// Get a sprite by name.
    public subscript(sprite: SpriteName) -> CGImage? {
        sprites[sprite]
    }
}

/// Errors that can occur during skin loading.
public enum SkinError: Error, Sendable, LocalizedError {
    case fileNotFound(String)
    case invalidArchive(String)
    case missingRequiredFile(String)
    case invalidBitmap(String)
    case invalidConfiguration(String)

    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "skin file not found: \(path)"
        case .invalidArchive(let reason):
            return "invalid skin archive: \(reason)"
        case .missingRequiredFile(let file):
            return "missing required file: \(file)"
        case .invalidBitmap(let reason):
            return "invalid bitmap: \(reason)"
        case .invalidConfiguration(let reason):
            return "invalid configuration: \(reason)"
        }
    }
}

/// Loads and parses Winamp WSZ skin files.
///
/// SkinLoader extracts WSZ archives (which are standard ZIP files), loads BMP
/// sprite sheets, and slices them into individual sprites based on Winamp's
/// coordinate definitions.
public actor SkinLoader {
    private let fileManager = FileManager.default

    /// URL for the fallback skin used when a skin lacks PLEDIT.BMP.
    /// Defaults to the bundled base-2.91.wsz. Can be overridden for testing.
    public var fallbackSkinURL: URL? = Bundle.main.url(forResource: "base-2.91", withExtension: "wsz")

    public init() {}

    /// Create a loader with a custom fallback skin URL (for testing).
    public init(fallbackSkinURL: URL?) {
        self.fallbackSkinURL = fallbackSkinURL
    }

    /// Load a skin from a file URL.
    /// - Parameter url: URL to the WSZ skin file
    /// - Returns: Extracted skin data with sprites and configuration
    /// - Throws: SkinError if loading fails
    public func load(from url: URL) async throws -> SkinData {
        guard fileManager.fileExists(atPath: url.path) else {
            throw SkinError.fileNotFound(url.path)
        }

        // Create temporary directory for extraction
        let tempDir = fileManager.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)

        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)

        defer {
            try? fileManager.removeItem(at: tempDir)
        }

        // Extract ZIP archive
        try await extractZIP(from: url, to: tempDir)

        // Find the actual skin directory (may be root or a subdirectory)
        let skinDir = try findSkinDirectory(in: tempDir)

        // Load sprites and config
        return try await loadFromDirectory(skinDir)
    }

    /// Load a skin bundled with the application.
    /// - Parameter bundleName: Name of the skin file (without extension) in the app bundle
    /// - Returns: Extracted skin data with sprites and configuration
    /// - Throws: SkinError if loading fails
    public func load(named bundleName: String) async throws -> SkinData {
        guard let url = Bundle.main.url(forResource: bundleName, withExtension: "wsz") else {
            throw SkinError.fileNotFound(bundleName + ".wsz")
        }
        return try await load(from: url)
    }

    // MARK: - Private Implementation

    /// Find the directory containing skin files.
    /// Some skins have files at the root, others have them in a subdirectory.
    private func findSkinDirectory(in directory: URL) throws -> URL {
        let contents = try fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey]
        )

        // Check if there are BMP files at the root level
        let hasBMPAtRoot = contents.contains { url in
            url.pathExtension.lowercased() == "bmp"
        }

        if hasBMPAtRoot {
            return directory
        }

        // Look for subdirectories that might contain skin files
        let subdirs = contents.filter { url in
            (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
        }

        // If there's exactly one subdirectory, check if it has BMP files
        if subdirs.count == 1, let subdir = subdirs.first {
            let subdirContents = try fileManager.contentsOfDirectory(
                at: subdir,
                includingPropertiesForKeys: nil
            )
            let hasBMP = subdirContents.contains { url in
                url.pathExtension.lowercased() == "bmp"
            }
            if hasBMP {
                return subdir
            }
        }

        // Default to root directory (let loadFromDirectory handle missing files error)
        return directory
    }

    private func extractZIP(from url: URL, to destination: URL) async throws {
        // Use Process to run unzip command (more reliable than manual ZIP parsing)
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = ["-o", "-q", url.path, "-d", destination.path]

        let pipe = Pipe()
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        if process.terminationStatus != 0 {
            let errorData = pipe.fileHandleForReading.readDataToEndOfFile()
            let errorMessage = String(data: errorData, encoding: .utf8) ?? "unknown error"
            throw SkinError.invalidArchive(errorMessage)
        }

        // Verify no extracted files escaped the destination (zip slip protection)
        try validateExtractedPaths(in: destination)
    }

    /// Verify that all extracted files are within the destination directory.
    /// Protects against zip slip attacks where entries contain "../" path components.
    private func validateExtractedPaths(in directory: URL) throws {
        let resolvedBase = directory.standardizedFileURL.path
        let enumerator = fileManager.enumerator(at: directory, includingPropertiesForKeys: nil)
        while let fileURL = enumerator?.nextObject() as? URL {
            let resolvedPath = fileURL.standardizedFileURL.path
            guard resolvedPath.hasPrefix(resolvedBase) else {
                throw SkinError.invalidArchive("archive entry escaped destination directory: \(fileURL.lastPathComponent)")
            }
        }
    }

    /// Extract sprites for multiple BMP files from a fallback skin archive.
    /// Extracts the ZIP once and loads all requested BMPs in one pass.
    private func loadFallbackSprites(
        from url: URL,
        bmpFiles: [SpriteDefinitions.BMPFile]
    ) throws -> [SpriteName: CGImage] {
        guard !bmpFiles.isEmpty else { return [:] }

        let tempDir = fileManager.temporaryDirectory.appendingPathComponent("skinkit-fallback-\(UUID().uuidString)")
        defer { try? fileManager.removeItem(at: tempDir) }
        try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
        process.arguments = ["-o", "-qq", url.path, "-d", tempDir.path]
        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            throw SkinError.invalidArchive("Failed to extract fallback skin")
        }

        let skinDir = try findSkinDirectory(in: tempDir)
        let files = try fileManager.contentsOfDirectory(at: skinDir, includingPropertiesForKeys: nil)
        let fileMap = Dictionary(
            files.map { ($0.lastPathComponent.uppercased(), $0) },
            uniquingKeysWith: { first, _ in first }
        )

        var sprites: [SpriteName: CGImage] = [:]
        for bmpFile in bmpFiles {
            guard let fileURL = fileMap[bmpFile.filename],
                  let data = try? Data(contentsOf: fileURL) else {
                continue
            }
            if let extracted = try? BMPLoader.extractSprites(from: data, file: bmpFile) {
                sprites.merge(extracted) { _, new in new }
            }
        }
        return sprites
    }

    private func loadFromDirectory(_ directory: URL) async throws -> SkinData {
        var allSprites: [SpriteName: CGImage] = [:]
        var config = SkinConfig.default

        // Get list of files (case-insensitive matching)
        let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        let fileMap = Dictionary(
            files.map { ($0.lastPathComponent.uppercased(), $0) },
            uniquingKeysWith: { first, _ in first }
        )

        // Load each BMP file
        for bmpFile in SpriteDefinitions.BMPFile.allCases {
            let filename = bmpFile.filename
            guard let fileURL = fileMap[filename] else {
                // Optional files can be missing
                continue
            }

            guard let data = try? Data(contentsOf: fileURL) else {
                continue
            }

            do {
                let sprites = try BMPLoader.extractSprites(from: data, file: bmpFile)
                allSprites.merge(sprites) { _, new in new }
            } catch {
                // Continue loading other files even if one fails
                continue
            }
        }

        // Fallback: load missing sprite sheets from the bundled base skin.
        // Collect which BMPs are needed, then extract the base ZIP once.
        if let baseURL = fallbackSkinURL {
            var missingBMPs: [SpriteDefinitions.BMPFile] = []
            if allSprites[.playlistTitleBar] == nil { missingBMPs.append(.pledit) }
            if allSprites[.eqWindowBackground] == nil { missingBMPs.append(.eqmain) }
            // EQ_EX is independent of EQMAIN — a skin can have EQMAIN but not EQ_EX
            if allSprites[.eqShadeBackground] == nil { missingBMPs.append(.eqEx) }

            if !missingBMPs.isEmpty {
                if let fallbackSprites = try? loadFallbackSprites(from: baseURL, bmpFiles: missingBMPs) {
                    for (key, value) in fallbackSprites where allSprites[key] == nil {
                        allSprites[key] = value
                    }
                }
            }
        }

        // Verify required sprites exist
        let required: [SpriteName] = [.mainWindowBackground]
        for sprite in required {
            if allSprites[sprite] == nil {
                throw SkinError.missingRequiredFile("MAIN.BMP (background sprite)")
            }
        }

        // Load pledit.txt if present
        if let pleditURL = fileMap["PLEDIT.TXT"],
           let content = try? String(contentsOf: pleditURL, encoding: .utf8) {
            let parser = INIParser(content: content)
            config = parser.extractSkinConfig()
        }

        return SkinData(sprites: allSprites, config: config)
    }
}
