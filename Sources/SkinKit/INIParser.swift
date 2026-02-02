import Foundation
import CoreGraphics

/// Parses Windows INI-style configuration files.
///
/// Used primarily for parsing pledit.txt which contains playlist editor colors.
public struct INIParser: Sendable {

    /// Parsed sections from the INI file.
    public let sections: [String: [String: String]]

    /// Initialize with INI file contents.
    /// - Parameter content: The raw string content of the INI file.
    public init(content: String) {
        var sections: [String: [String: String]] = [:]
        var currentSection = ""

        for line in content.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Skip empty lines and comments
            if trimmed.isEmpty || trimmed.hasPrefix(";") || trimmed.hasPrefix("#") {
                continue
            }

            // Section header [SectionName]
            if trimmed.hasPrefix("[") && trimmed.hasSuffix("]") {
                currentSection = String(trimmed.dropFirst().dropLast())
                if sections[currentSection] == nil {
                    sections[currentSection] = [:]
                }
                continue
            }

            // Key=Value pair
            if let equalsIndex = trimmed.firstIndex(of: "=") {
                let key = String(trimmed[..<equalsIndex]).trimmingCharacters(in: .whitespaces)
                let value = String(trimmed[trimmed.index(after: equalsIndex)...]).trimmingCharacters(in: .whitespaces)
                sections[currentSection, default: [:]][key] = value
            }
        }

        self.sections = sections
    }

    /// Get a value from a specific section.
    /// - Parameters:
    ///   - key: The key to look up.
    ///   - section: The section name.
    /// - Returns: The value if found, nil otherwise.
    public func value(forKey key: String, inSection section: String) -> String? {
        sections[section]?[key]
    }

    /// Get all values in a section.
    /// - Parameter section: The section name.
    /// - Returns: Dictionary of key-value pairs, or empty dictionary if section not found.
    public func values(inSection section: String) -> [String: String] {
        sections[section] ?? [:]
    }
}

// MARK: - Color Parsing

public extension INIParser {
    /// Parse a hex color string to CGColor.
    /// Supports formats: #RRGGBB, #RGB, RRGGBB, RGB
    /// - Parameter hexString: The hex color string.
    /// - Returns: CGColor if parsing succeeds, nil otherwise.
    static func parseColor(_ hexString: String) -> CGColor? {
        var hex = hexString.trimmingCharacters(in: .whitespaces)

        // Remove # prefix if present
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }

        // Expand short form (RGB -> RRGGBB)
        if hex.count == 3 {
            hex = hex.map { "\($0)\($0)" }.joined()
        }

        guard hex.count == 6 else { return nil }

        var rgb: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&rgb) else { return nil }

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        return CGColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - Skin Configuration Extraction

public extension INIParser {
    /// Extract skin configuration from a parsed pledit.txt file.
    /// - Returns: SkinConfig with colors and font settings.
    func extractSkinConfig() -> SkinConfig {
        let textSection = values(inSection: "Text")

        // Default Winamp colors (green text on black)
        let defaultNormal = CGColor(red: 0, green: 1, blue: 0, alpha: 1)
        let defaultCurrent = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        let defaultNormalBG = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        let defaultSelectedBG = CGColor(red: 0, green: 0, blue: 0.5, alpha: 1)

        return SkinConfig(
            normalTextColor: textSection["Normal"].flatMap(Self.parseColor) ?? defaultNormal,
            currentTextColor: textSection["Current"].flatMap(Self.parseColor) ?? defaultCurrent,
            normalBackgroundColor: textSection["NormalBG"].flatMap(Self.parseColor) ?? defaultNormalBG,
            selectedBackgroundColor: textSection["SelectedBG"].flatMap(Self.parseColor) ?? defaultSelectedBG,
            fontName: textSection["Font"] ?? "Arial"
        )
    }
}
