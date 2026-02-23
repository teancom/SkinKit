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

    /// Colors extracted from GENEX.BMP (optional).
    public let genExColors: GenExColors?

    /// True when the skin natively provides easter egg titlebar sprites.
    /// When false, the SkinLoader has loaded base skin sprites for the titlebar,
    /// and GenExColors should also use .default instead of the skin's colors.
    public let hasNativeEasterEggTitlebar: Bool

    public init(sprites: [SpriteName: CGImage], config: SkinConfig, genExColors: GenExColors? = nil, hasNativeEasterEggTitlebar: Bool = true) {
        self.sprites = sprites
        self.config = config
        self.genExColors = genExColors
        self.hasNativeEasterEggTitlebar = hasNativeEasterEggTitlebar
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

    /// The bundle to search for skin resources.
    private let bundle: Bundle

    /// URL for the fallback skin used when a skin lacks PLEDIT.BMP.
    /// Defaults to the bundled base-2.91.wsz. Can be overridden for testing.
    public var fallbackSkinURL: URL?

    public init(bundle: Bundle = .main) {
        self.bundle = bundle
        self.fallbackSkinURL = bundle.url(forResource: "base-2.91", withExtension: "wsz")
    }

    /// Create a loader with a custom fallback skin URL (for testing).
    public init(fallbackSkinURL: URL?) {
        self.bundle = .main
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

    /// Load a skin bundled with an application.
    /// - Parameters:
    ///   - bundleName: Name of the skin file (without extension)
    ///   - bundle: Bundle to search for the resource (defaults to the loader's bundle)
    /// - Returns: Extracted skin data with sprites and configuration
    /// - Throws: SkinError if loading fails
    public func load(named bundleName: String, bundle: Bundle? = nil) async throws -> SkinData {
        let searchBundle = bundle ?? self.bundle
        guard let url = searchBundle.url(forResource: bundleName, withExtension: "wsz") else {
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

    /// Load fallback GENEX colors and GEN font from the base skin.
    /// Performs a separate extraction pass for GENEX-specific data not covered by loadFallbackSprites.
    private func loadFallbackExtras(
        from url: URL,
        needsGenEx: Bool,
        needsGenFont: Bool
    ) throws -> (genExColors: GenExColors?, genImage: CGImage?) {
        guard needsGenEx || needsGenFont else { return (nil, nil) }

        let tempDir = fileManager.temporaryDirectory.appendingPathComponent("skinkit-fallback-extras-\(UUID().uuidString)")
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

        var genExColors: GenExColors? = nil
        var genImg: CGImage? = nil

        if needsGenEx,
           let genexURL = fileMap["GENEX.BMP"],
           let genexData = try? Data(contentsOf: genexURL),
           let genexImage = try? BMPLoader.load(from: genexData) {
            genExColors = try? GenExColors.extract(from: genexImage)
        }

        if needsGenFont,
           let genURL = fileMap["GEN.BMP"],
           let genData = try? Data(contentsOf: genURL) {
            genImg = try? BMPLoader.load(from: genData)
        }

        return (genExColors, genImg)
    }

    private func loadFromDirectory(_ directory: URL) async throws -> SkinData {
        var allSprites: [SpriteName: CGImage] = [:]
        var config = SkinConfig.default
        var genImage: CGImage? = nil

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

                // Capture raw GEN image for font extraction
                if bmpFile == .gen {
                    genImage = try? BMPLoader.load(from: data)
                }
            } catch {
                // Continue loading other files even if one fails
                continue
            }
        }

        // Track whether the skin has native easter egg titlebar sprites BEFORE fallback.
        // This flag is passed to SkinData so views can decide whether to use skin's
        // GenExColors (.default when false, skin's when true).
        let skinHasNativeEasterEggTitlebar = allSprites[.mainEasterEggTitleBarSelected] != nil

        // Fallback: load missing sprite sheets from the bundled base skin.
        // Collect which BMPs are needed, then extract the base ZIP once.
        //
        // All-or-nothing rule for the browse window: MB.BMP is required for a
        // properly themed browse window. If a skin lacks MB.BMP, fall back the
        // entire browse window (title bar + sides + bottom) to the base skin.
        // This avoids mixing custom GEN.BMP body sprites with base MB.BMP
        // title bar sprites, which would look jarring.
        if let baseURL = fallbackSkinURL {
            var missingBMPs: [SpriteDefinitions.BMPFile] = []
            if allSprites[.playlistTitleBar] == nil { missingBMPs.append(.pledit) }
            if allSprites[.eqWindowBackground] == nil { missingBMPs.append(.eqmain) }
            // EQ_EX is independent of EQMAIN — a skin can have EQMAIN but not EQ_EX
            if allSprites[.eqShadeBackground] == nil { missingBMPs.append(.eqEx) }

            // Browse window: all-or-nothing MB.BMP + GEN.BMP fallback
            let skinHasMB = allSprites[.mbTitleLeftSelected] != nil
            if !skinHasMB {
                missingBMPs.append(.mb)
                // Replace any custom GEN.BMP sprites with base skin versions
                // to avoid theme mixing between base MB.BMP and custom GEN.BMP
                for sprite in SpriteDefinitions.sprites(in: .gen) {
                    allSprites.removeValue(forKey: sprite)
                }
                missingBMPs.append(.gen)
            } else if allSprites[.genTopLeftSelected] == nil {
                // Skin has MB.BMP but lacks GEN.BMP — still need GEN for sides/bottom
                missingBMPs.append(.gen)
            }

            // Settings window: all-or-nothing easter egg titlebar fallback
            // Easter egg titlebar sprites come from TITLEBAR.BMP rows 5-6 (y=57, y=72).
            // If the skin's TITLEBAR.BMP is too short, these sprites will be nil.
            // When missing, fall back the ENTIRE settings window to base skin:
            // titlebar + GEN.BMP chrome + GenExColors. This mirrors the MB.BMP
            // all-or-nothing pattern (AC2.2).
            let skinHasEasterEggTitlebar = allSprites[.mainEasterEggTitleBarSelected] != nil
            if !skinHasEasterEggTitlebar {
                if !missingBMPs.contains(.titlebar) {
                    missingBMPs.append(.titlebar)
                }
                // Also force GEN.BMP fallback — remove custom GEN sprites and reload from base.
                // Same pattern as the MB.BMP fallback above (lines 388-394).
                if !skinHasMB {
                    // MB.BMP fallback already handled GEN above — skip
                } else {
                    // Skin has MB.BMP (so GEN wasn't removed above) but lacks easter egg.
                    // Remove custom GEN sprites so settings window gets base GEN chrome.
                    for sprite in SpriteDefinitions.sprites(in: .gen) {
                        allSprites.removeValue(forKey: sprite)
                    }
                    if !missingBMPs.contains(.gen) {
                        missingBMPs.append(.gen)
                    }
                }
            }

            if !missingBMPs.isEmpty {
                if let fallbackSprites = try? loadFallbackSprites(from: baseURL, bmpFiles: missingBMPs) {
                    for (key, value) in fallbackSprites where allSprites[key] == nil {
                        allSprites[key] = value
                    }
                }
            }
        }

        // Extract GENEX.BMP colors from the current skin
        // fileMap includes ALL extracted files (not just known BMPFile cases),
        // so GENEX.BMP is accessible via fileMap even though it has no BMPFile enum case.
        var genExColors: GenExColors? = nil
        if let genexURL = fileMap["GENEX.BMP"],
           let genexData = try? Data(contentsOf: genexURL),
           let genexImage = try? BMPLoader.load(from: genexData) {
            genExColors = try? GenExColors.extract(from: genexImage)
        }

        // Extract GEN font characters (variable-width, pixel-scanned)
        if let genImg = genImage {
            if let fontSprites = try? BMPLoader.extractGenFontSprites(from: genImg) {
                allSprites.merge(fontSprites) { _, new in new }
            }
        }

        // Fallback: load GENEX colors and GEN font from base skin if missing
        // Uses a single extraction pass to avoid extracting the base WSZ twice.
        if let baseURL = fallbackSkinURL {
            let needsGenEx = genExColors == nil
            let needsGenFont = genImage == nil
            if needsGenEx || needsGenFont {
                if let extras = try? loadFallbackExtras(
                    from: baseURL,
                    needsGenEx: needsGenEx,
                    needsGenFont: needsGenFont
                ) {
                    if needsGenEx, let colors = extras.genExColors {
                        genExColors = colors
                    }
                    if needsGenFont, let fallbackGenImg = extras.genImage {
                        genImage = fallbackGenImg
                        // Extract font sprites from fallback GEN image
                        if let fontSprites = try? BMPLoader.extractGenFontSprites(from: fallbackGenImg) {
                            allSprites.merge(fontSprites) { existing, _ in existing }
                        }
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

        return SkinData(sprites: allSprites, config: config, genExColors: genExColors, hasNativeEasterEggTitlebar: skinHasNativeEasterEggTitlebar)
    }
}
