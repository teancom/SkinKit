import Foundation
import CoreGraphics

/// SkinKit provides parsing and sprite extraction for Winamp-style WSZ skin files.
///
/// The library extracts BMP sprite sheets from WSZ archives (which are ZIP files)
/// and slices them into individual CGImage sprites based on coordinate definitions
/// ported from the Webamp project.

/// A unique identifier for a sprite within a skin.
public enum SpriteName: String, CaseIterable, Sendable {
    // Main window background
    case mainWindowBackground = "MAIN_WINDOW_BACKGROUND"

    // Transport buttons
    case mainPreviousButton = "MAIN_PREVIOUS_BUTTON"
    case mainPreviousButtonActive = "MAIN_PREVIOUS_BUTTON_ACTIVE"
    case mainPlayButton = "MAIN_PLAY_BUTTON"
    case mainPlayButtonActive = "MAIN_PLAY_BUTTON_ACTIVE"
    case mainPauseButton = "MAIN_PAUSE_BUTTON"
    case mainPauseButtonActive = "MAIN_PAUSE_BUTTON_ACTIVE"
    case mainStopButton = "MAIN_STOP_BUTTON"
    case mainStopButtonActive = "MAIN_STOP_BUTTON_ACTIVE"
    case mainNextButton = "MAIN_NEXT_BUTTON"
    case mainNextButtonActive = "MAIN_NEXT_BUTTON_ACTIVE"
    case mainEjectButton = "MAIN_EJECT_BUTTON"
    case mainEjectButtonActive = "MAIN_EJECT_BUTTON_ACTIVE"

    // Placeholder - full enum will be implemented in Phase 2
}

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
}

/// Errors that can occur during skin loading.
public enum SkinError: Error, Sendable {
    case fileNotFound(String)
    case invalidArchive(String)
    case missingRequiredFile(String)
    case invalidBitmap(String)
    case invalidConfiguration(String)
}

/// Loads and parses Winamp WSZ skin files.
///
/// SkinLoader extracts WSZ archives (which are standard ZIP files), loads BMP
/// sprite sheets, and slices them into individual sprites based on Winamp's
/// coordinate definitions.
public actor SkinLoader {
    public init() {}

    /// Load a skin from a file URL.
    /// - Parameter url: URL to the WSZ skin file
    /// - Returns: Extracted skin data with sprites and configuration
    /// - Throws: SkinError if loading fails
    public func load(from url: URL) async throws -> SkinData {
        // Placeholder - full implementation in Phase 2
        fatalError("Not yet implemented")
    }

    /// Load a skin bundled with the application.
    /// - Parameter bundleName: Name of the skin file (without extension) in the app bundle
    /// - Returns: Extracted skin data with sprites and configuration
    /// - Throws: SkinError if loading fails
    public func load(named bundleName: String) async throws -> SkinData {
        // Placeholder - full implementation in Phase 2
        fatalError("Not yet implemented")
    }
}
