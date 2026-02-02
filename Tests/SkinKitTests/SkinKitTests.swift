import Testing
import CoreGraphics
@testable import SkinKit

@Suite("SkinKit Tests")
struct SkinKitTests {
    @Test("SpriteName enum has expected cases")
    func spriteNameEnumHasExpectedCases() {
        // Verify key sprite names exist
        #expect(SpriteName.mainWindowBackground.rawValue == "MAIN_WINDOW_BACKGROUND")
        #expect(SpriteName.mainPlayButton.rawValue == "MAIN_PLAY_BUTTON")
        #expect(SpriteName.mainPauseButton.rawValue == "MAIN_PAUSE_BUTTON")
    }

    @Test("SkinConfig initializes with all parameters")
    func skinConfigInitializes() {
        let config = SkinConfig(
            normalTextColor: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
            currentTextColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1),
            normalBackgroundColor: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
            selectedBackgroundColor: CGColor(red: 0, green: 0, blue: 0.5, alpha: 1),
            fontName: "Arial"
        )

        #expect(config.fontName == "Arial")
    }

    @Test("SkinData initializes with sprites and config")
    func skinDataInitializes() {
        let config = SkinConfig(
            normalTextColor: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
            currentTextColor: CGColor(red: 1, green: 1, blue: 1, alpha: 1),
            normalBackgroundColor: CGColor(red: 0, green: 0, blue: 0, alpha: 1),
            selectedBackgroundColor: CGColor(red: 0, green: 0, blue: 0.5, alpha: 1),
            fontName: "Arial"
        )

        let skinData = SkinData(sprites: [:], config: config)

        #expect(skinData.sprites.isEmpty)
        #expect(skinData.config.fontName == "Arial")
    }

    @Test("SkinError cases are distinct")
    func skinErrorCases() {
        let error1 = SkinError.fileNotFound("test.wsz")
        let error2 = SkinError.invalidArchive("corrupt.wsz")
        let error3 = SkinError.missingRequiredFile("MAIN.BMP")
        let error4 = SkinError.invalidBitmap("bad.bmp")
        let error5 = SkinError.invalidConfiguration("pledit.txt")

        // Just verify they can be created - pattern matching would be better
        // but this confirms the enum cases exist
        switch error1 {
        case .fileNotFound: break
        default: fatalError("Unexpected error type")
        }

        switch error2 {
        case .invalidArchive: break
        default: fatalError("Unexpected error type")
        }

        switch error3 {
        case .missingRequiredFile: break
        default: fatalError("Unexpected error type")
        }

        switch error4 {
        case .invalidBitmap: break
        default: fatalError("Unexpected error type")
        }

        switch error5 {
        case .invalidConfiguration: break
        default: fatalError("Unexpected error type")
        }
    }
}
