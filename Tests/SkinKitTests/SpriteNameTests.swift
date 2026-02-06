import Testing
@testable import SkinKit

@Suite("SpriteName Tests")
struct SpriteNameTests {

    @Test("SpriteName enum is CaseIterable")
    func spriteNameIsCaseIterable() {
        // Verify we can iterate all cases
        let allCases = SpriteName.allCases
        #expect(allCases.count > 50)  // Should have many sprites
    }

    @Test("SpriteName raw values are uppercase with underscores")
    func spriteNameRawValuesAreUppercase() {
        for sprite in SpriteName.allCases {
            let rawValue = sprite.rawValue
            // All raw values should be uppercase (except for digits in CHARACTER_XX)
            let letters = rawValue.filter { $0.isLetter }
            #expect(letters == letters.uppercased())
        }
    }

    @Test("Character sprite lookup works for uppercase")
    func characterSpriteLookupWorksForUppercase() {
        let aSprite = SpriteName.character("A")
        #expect(aSprite == .characterA)

        let zSprite = SpriteName.character("Z")
        #expect(zSprite == .characterZ)
    }

    @Test("Character sprite lookup works for digits")
    func characterSpriteLookupWorksForDigits() {
        let digitSprite = SpriteName.character("5")
        #expect(digitSprite == .character5)

        let zeroSprite = SpriteName.character("0")
        #expect(zeroSprite == .character0)
    }

    @Test("Character sprite lookup works for special characters")
    func characterSpriteLookupWorksForSpecialCharacters() {
        let spaceSprite = SpriteName.character(" ")
        #expect(spaceSprite == .characterSpace)

        let dotSprite = SpriteName.character(".")
        #expect(dotSprite == .characterDot)

        let dashSprite = SpriteName.character("-")
        #expect(dashSprite == .characterDash)

        let atSprite = SpriteName.character("@")
        #expect(atSprite == .characterAt)

        let hashSprite = SpriteName.character("#")
        #expect(hashSprite == .characterHash)

        let questionSprite = SpriteName.character("?")
        #expect(questionSprite == .characterQuestion)

        let asteriskSprite = SpriteName.character("*")
        #expect(asteriskSprite == .characterAsterisk)
    }

    @Test("Character sprite lookup returns nil for unsupported characters")
    func characterSpriteLookupReturnsNilForUnsupported() {
        let missingSprite = SpriteName.character("€")
        #expect(missingSprite == nil)

        let otherMissing = SpriteName.character("~")
        #expect(otherMissing == nil)
    }

    @Test("Character sprite map contains expected entries")
    func characterSpriteMapContainsExpectedEntries() {
        let map = SpriteName.characterMap

        #expect(map["A"] == .characterA)
        #expect(map["0"] == .character0)
        #expect(map[" "] == .characterSpace)
        #expect(map["@"] == .characterAt)
    }

    @Test("All character sprites have unique raw values")
    func allCharacterSpritesHaveUniqueRawValues() {
        var rawValues = Set<String>()

        for sprite in SpriteName.allCases {
            let raw = sprite.rawValue
            if raw.hasPrefix("CHARACTER_") {
                // Character sprites should have unique CHARACTER_XX identifiers
                #expect(!rawValues.contains(raw), "Duplicate raw value: \(raw)")
                rawValues.insert(raw)
            }
        }
    }

    @Test("Main button sprites exist")
    func mainButtonSpritesExist() {
        #expect(SpriteName.mainPlayButton.rawValue == "MAIN_PLAY_BUTTON")
        #expect(SpriteName.mainPlayButtonActive.rawValue == "MAIN_PLAY_BUTTON_ACTIVE")
        #expect(SpriteName.mainPauseButton.rawValue == "MAIN_PAUSE_BUTTON")
        #expect(SpriteName.mainStopButton.rawValue == "MAIN_STOP_BUTTON")
    }

    @Test("Number sprites exist")
    func numberSpritesExist() {
        #expect(SpriteName.digit0.rawValue == "DIGIT_0")
        #expect(SpriteName.digit9.rawValue == "DIGIT_9")
        #expect(SpriteName.minusSign.rawValue == "MINUS_SIGN")
    }

    @Test("Title bar sprites exist")
    func titleBarSpritesExist() {
        #expect(SpriteName.mainTitleBar.rawValue == "MAIN_TITLE_BAR")
        #expect(SpriteName.mainTitleBarSelected.rawValue == "MAIN_TITLE_BAR_SELECTED")
        #expect(SpriteName.mainCloseButton.rawValue == "MAIN_CLOSE_BUTTON")
    }

    @Test("Character sprite is sendable")
    func characterSpritesAreSendable() {
        // This test just verifies that SpriteName conforms to Sendable
        // by using it in an async context
        let sprite = SpriteName.characterA

        Task {
            _ = sprite.rawValue
        }
    }

    @Test("Playlist editor sprites exist")
    func playlistEditorSpritesExist() {
        #expect(SpriteName.playlistTitleBar.rawValue == "PLAYLIST_TITLE_BAR")
        #expect(SpriteName.playlistAddFile.rawValue == "PLAYLIST_ADD_FILE")
        #expect(SpriteName.playlistCloseSelected.rawValue == "PLAYLIST_CLOSE_SELECTED")
    }

    @Test("SpriteName total count includes PLEDIT sprites")
    func spriteNameTotalCountIncludesPleditSprites() {
        #expect(SpriteName.allCases.count == 219)
    }
}
