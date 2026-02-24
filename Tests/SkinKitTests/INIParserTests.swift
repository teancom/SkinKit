import Testing
import CoreGraphics
@testable import SkinKit

@Suite("INIParser Tests")
struct INIParserTests {

    // MARK: - Basic Parsing

    @Test("Parses simple key-value pairs")
    func parsesSimpleKeyValuePairs() {
        let content = """
        [Section]
        Key1=Value1
        Key2=Value2
        """

        let parser = INIParser(content: content)

        #expect(parser.value(forKey: "Key1", inSection: "Section") == "Value1")
        #expect(parser.value(forKey: "Key2", inSection: "Section") == "Value2")
    }

    @Test("Parses multiple sections")
    func parsesMultipleSections() {
        let content = """
        [First]
        A=1

        [Second]
        B=2
        """

        let parser = INIParser(content: content)

        #expect(parser.value(forKey: "A", inSection: "First") == "1")
        #expect(parser.value(forKey: "B", inSection: "Second") == "2")
    }

    @Test("Handles empty lines and whitespace")
    func handlesEmptyLinesAndWhitespace() {
        let content = """

        [Section]

        Key = Value With Spaces

        """

        let parser = INIParser(content: content)

        #expect(parser.value(forKey: "Key", inSection: "Section") == "Value With Spaces")
    }

    @Test("Ignores comment lines")
    func ignoresCommentLines() {
        let content = """
        [Section]
        ; This is a comment
        # This is also a comment
        Key=Value
        """

        let parser = INIParser(content: content)

        #expect(parser.value(forKey: "Key", inSection: "Section") == "Value")
        #expect(parser.sections["Section"]?.count == 1)
    }

    @Test("Returns nil for missing keys")
    func returnsNilForMissingKeys() {
        let content = """
        [Section]
        Key=Value
        """

        let parser = INIParser(content: content)

        #expect(parser.value(forKey: "Missing", inSection: "Section") == nil)
        #expect(parser.value(forKey: "Key", inSection: "Missing") == nil)
    }

    // MARK: - Color Parsing

    @Test("Parses 6-digit hex color with hash")
    func parsesSixDigitHexColorWithHash() {
        let color = INIParser.parseColor("#00FF00")

        #expect(color != nil)
    }

    @Test("Parses 6-digit hex color without hash")
    func parsesSixDigitHexColorWithoutHash() {
        let color = INIParser.parseColor("FF0000")

        #expect(color != nil)
    }

    @Test("Parses 3-digit hex color")
    func parsesThreeDigitHexColor() {
        let color = INIParser.parseColor("#F00")

        #expect(color != nil)
    }

    @Test("Returns nil for invalid hex color")
    func returnsNilForInvalidHexColor() {
        #expect(INIParser.parseColor("invalid") == nil)
        #expect(INIParser.parseColor("#GGG") == nil)
        #expect(INIParser.parseColor("#12345") == nil)
    }

    // MARK: - Skin Config Extraction

    @Test("Extracts skin config from pledit.txt format")
    func extractsSkinConfigFromPleditFormat() {
        let content = """
        [Text]
        Normal=#00FF00
        Current=#FFFFFF
        NormalBG=#000000
        SelectedBG=#000080
        Font=Arial
        """

        let parser = INIParser(content: content)
        let config = parser.extractSkinConfig()

        #expect(config.fontName == "Arial")
    }

    @Test("Uses defaults for missing pledit values")
    func usesDefaultsForMissingPleditValues() {
        let content = """
        [Text]
        Font=Helvetica
        """

        let parser = INIParser(content: content)
        let config = parser.extractSkinConfig()

        #expect(config.fontName == "Helvetica")
        // Colors should be defaults (green on black)
        let _ = config.normalTextColor  // Non-optional CGColor, just verify it exists
    }

    @Test("Uses all defaults for empty content")
    func usesAllDefaultsForEmptyContent() {
        let parser = INIParser(content: "")
        let config = parser.extractSkinConfig()

        #expect(config.fontName == "Arial")
    }
}
