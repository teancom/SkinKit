import Foundation

/// A unique identifier for a sprite within a Winamp skin.
///
/// Sprite names follow Winamp conventions ported from the Webamp project.
/// Each case maps to a specific region within a BMP sprite sheet.
public enum SpriteName: String, CaseIterable, Sendable {

    // MARK: - Main Window Background (MAIN.BMP)

    case mainWindowBackground = "MAIN_WINDOW_BACKGROUND"

    // MARK: - Transport Buttons (CBUTTONS.BMP)

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

    // MARK: - Title Bar (TITLEBAR.BMP)

    case mainTitleBar = "MAIN_TITLE_BAR"
    case mainTitleBarSelected = "MAIN_TITLE_BAR_SELECTED"
    case mainEasterEggTitleBar = "MAIN_EASTER_EGG_TITLE_BAR"
    case mainEasterEggTitleBarSelected = "MAIN_EASTER_EGG_TITLE_BAR_SELECTED"
    case mainOptionsButton = "MAIN_OPTIONS_BUTTON"
    case mainOptionsButtonDepressed = "MAIN_OPTIONS_BUTTON_DEPRESSED"
    case mainMinimizeButton = "MAIN_MINIMIZE_BUTTON"
    case mainMinimizeButtonDepressed = "MAIN_MINIMIZE_BUTTON_DEPRESSED"
    case mainShadeButton = "MAIN_SHADE_BUTTON"
    case mainShadeButtonDepressed = "MAIN_SHADE_BUTTON_DEPRESSED"
    case mainCloseButton = "MAIN_CLOSE_BUTTON"
    case mainCloseButtonDepressed = "MAIN_CLOSE_BUTTON_DEPRESSED"
    case mainClutterBarBackground = "MAIN_CLUTTER_BAR_BACKGROUND"
    case mainClutterBarBackgroundDisabled = "MAIN_CLUTTER_BAR_BACKGROUND_DISABLED"
    case mainClutterBarButtonOSelected = "MAIN_CLUTTER_BAR_BUTTON_O_SELECTED"
    case mainClutterBarButtonASelected = "MAIN_CLUTTER_BAR_BUTTON_A_SELECTED"
    case mainClutterBarButtonISelected = "MAIN_CLUTTER_BAR_BUTTON_I_SELECTED"
    case mainClutterBarButtonDSelected = "MAIN_CLUTTER_BAR_BUTTON_D_SELECTED"
    case mainClutterBarButtonVSelected = "MAIN_CLUTTER_BAR_BUTTON_V_SELECTED"
    case mainShadeBackground = "MAIN_SHADE_BACKGROUND"
    case mainShadeBackgroundSelected = "MAIN_SHADE_BACKGROUND_SELECTED"
    case mainShadeButtonSelected = "MAIN_SHADE_BUTTON_SELECTED"
    case mainShadeButtonSelectedDepressed = "MAIN_SHADE_BUTTON_SELECTED_DEPRESSED"
    case mainShadePositionBackground = "MAIN_SHADE_POSITION_BACKGROUND"
    case mainShadePositionThumb = "MAIN_SHADE_POSITION_THUMB"
    case mainShadePositionThumbLeft = "MAIN_SHADE_POSITION_THUMB_LEFT"
    case mainShadePositionThumbRight = "MAIN_SHADE_POSITION_THUMB_RIGHT"

    // MARK: - Position/Seek Bar (POSBAR.BMP)

    case mainPositionSliderBackground = "MAIN_POSITION_SLIDER_BACKGROUND"
    case mainPositionSliderThumb = "MAIN_POSITION_SLIDER_THUMB"
    case mainPositionSliderThumbSelected = "MAIN_POSITION_SLIDER_THUMB_SELECTED"

    // MARK: - Volume Slider (VOLUME.BMP)

    case mainVolumeBackground = "MAIN_VOLUME_BACKGROUND"
    case mainVolumeThumb = "MAIN_VOLUME_THUMB"
    case mainVolumeThumbSelected = "MAIN_VOLUME_THUMB_SELECTED"

    // MARK: - Balance Slider (BALANCE.BMP)

    case mainBalanceBackground = "MAIN_BALANCE_BACKGROUND"
    case mainBalanceThumb = "MAIN_BALANCE_THUMB"
    case mainBalanceThumbActive = "MAIN_BALANCE_THUMB_ACTIVE"

    // MARK: - Shuffle/Repeat Buttons (SHUFREP.BMP)

    case mainShuffleButton = "MAIN_SHUFFLE_BUTTON"
    case mainShuffleButtonDepressed = "MAIN_SHUFFLE_BUTTON_DEPRESSED"
    case mainShuffleButtonSelected = "MAIN_SHUFFLE_BUTTON_SELECTED"
    case mainShuffleButtonSelectedDepressed = "MAIN_SHUFFLE_BUTTON_SELECTED_DEPRESSED"
    case mainRepeatButton = "MAIN_REPEAT_BUTTON"
    case mainRepeatButtonDepressed = "MAIN_REPEAT_BUTTON_DEPRESSED"
    case mainRepeatButtonSelected = "MAIN_REPEAT_BUTTON_SELECTED"
    case mainRepeatButtonSelectedDepressed = "MAIN_REPEAT_BUTTON_SELECTED_DEPRESSED"
    case mainEqButton = "MAIN_EQ_BUTTON"
    case mainEqButtonSelected = "MAIN_EQ_BUTTON_SELECTED"
    case mainEqButtonDepressed = "MAIN_EQ_BUTTON_DEPRESSED"
    case mainEqButtonDepressedSelected = "MAIN_EQ_BUTTON_DEPRESSED_SELECTED"
    case mainPlaylistButton = "MAIN_PLAYLIST_BUTTON"
    case mainPlaylistButtonSelected = "MAIN_PLAYLIST_BUTTON_SELECTED"
    case mainPlaylistButtonDepressed = "MAIN_PLAYLIST_BUTTON_DEPRESSED"
    case mainPlaylistButtonDepressedSelected = "MAIN_PLAYLIST_BUTTON_DEPRESSED_SELECTED"

    // MARK: - Play/Pause Indicator (PLAYPAUS.BMP)

    case mainPlayingIndicator = "MAIN_PLAYING_INDICATOR"
    case mainPausedIndicator = "MAIN_PAUSED_INDICATOR"
    case mainStoppedIndicator = "MAIN_STOPPED_INDICATOR"
    case mainNotWorkingIndicator = "MAIN_NOT_WORKING_INDICATOR"
    case mainWorkingIndicator = "MAIN_WORKING_INDICATOR"

    // MARK: - Mono/Stereo Indicator (MONOSTER.BMP)

    case mainStereo = "MAIN_STEREO"
    case mainStereoSelected = "MAIN_STEREO_SELECTED"
    case mainMono = "MAIN_MONO"
    case mainMonoSelected = "MAIN_MONO_SELECTED"

    // MARK: - Numbers/Digits (NUMBERS.BMP)

    case noMinusSign = "NO_MINUS_SIGN"
    case minusSign = "MINUS_SIGN"
    case digit0 = "DIGIT_0"
    case digit1 = "DIGIT_1"
    case digit2 = "DIGIT_2"
    case digit3 = "DIGIT_3"
    case digit4 = "DIGIT_4"
    case digit5 = "DIGIT_5"
    case digit6 = "DIGIT_6"
    case digit7 = "DIGIT_7"
    case digit8 = "DIGIT_8"
    case digit9 = "DIGIT_9"

    // MARK: - Extended Numbers (NUMS_EX.BMP)

    case noMinusSignEx = "NO_MINUS_SIGN_EX"
    case minusSignEx = "MINUS_SIGN_EX"
    case digit0Ex = "DIGIT_0_EX"
    case digit1Ex = "DIGIT_1_EX"
    case digit2Ex = "DIGIT_2_EX"
    case digit3Ex = "DIGIT_3_EX"
    case digit4Ex = "DIGIT_4_EX"
    case digit5Ex = "DIGIT_5_EX"
    case digit6Ex = "DIGIT_6_EX"
    case digit7Ex = "DIGIT_7_EX"
    case digit8Ex = "DIGIT_8_EX"
    case digit9Ex = "DIGIT_9_EX"

    // MARK: - Character Sprites (TEXT.BMP)

    case characterA = "CHARACTER_65"   // 'A'
    case characterB = "CHARACTER_66"
    case characterC = "CHARACTER_67"
    case characterD = "CHARACTER_68"
    case characterE = "CHARACTER_69"
    case characterF = "CHARACTER_70"
    case characterG = "CHARACTER_71"
    case characterH = "CHARACTER_72"
    case characterI = "CHARACTER_73"
    case characterJ = "CHARACTER_74"
    case characterK = "CHARACTER_75"
    case characterL = "CHARACTER_76"
    case characterM = "CHARACTER_77"
    case characterN = "CHARACTER_78"
    case characterO = "CHARACTER_79"
    case characterP = "CHARACTER_80"
    case characterQ = "CHARACTER_81"
    case characterR = "CHARACTER_82"
    case characterS = "CHARACTER_83"
    case characterT = "CHARACTER_84"
    case characterU = "CHARACTER_85"
    case characterV = "CHARACTER_86"
    case characterW = "CHARACTER_87"
    case characterX = "CHARACTER_88"
    case characterY = "CHARACTER_89"
    case characterZ = "CHARACTER_90"

    case character0 = "CHARACTER_48"   // '0'
    case character1 = "CHARACTER_49"
    case character2 = "CHARACTER_50"
    case character3 = "CHARACTER_51"
    case character4 = "CHARACTER_52"
    case character5 = "CHARACTER_53"
    case character6 = "CHARACTER_54"
    case character7 = "CHARACTER_55"
    case character8 = "CHARACTER_56"
    case character9 = "CHARACTER_57"

    case characterSpace = "CHARACTER_32"   // ' '
    case characterQuote = "CHARACTER_34"   // '"'
    case characterAt = "CHARACTER_64"      // '@'
    case characterDot = "CHARACTER_46"     // '.'
    case characterColon = "CHARACTER_58"   // ':'
    case characterOpenParen = "CHARACTER_40"   // '('
    case characterCloseParen = "CHARACTER_41"  // ')'
    case characterDash = "CHARACTER_45"    // '-'
    case characterApostrophe = "CHARACTER_39"  // '\''
    case characterExclamation = "CHARACTER_33" // '!'
    case characterUnderscore = "CHARACTER_95"  // '_'
    case characterPlus = "CHARACTER_43"    // '+'
    case characterBackslash = "CHARACTER_92"   // '\\'
    case characterSlash = "CHARACTER_47"   // '/'
    case characterOpenBracket = "CHARACTER_91" // '['
    case characterCloseBracket = "CHARACTER_93" // ']'
    case characterCaret = "CHARACTER_94"   // '^'
    case characterAmpersand = "CHARACTER_38"   // '&'
    case characterPercent = "CHARACTER_37"     // '%'
    case characterComma = "CHARACTER_44"   // ','
    case characterEquals = "CHARACTER_61"  // '='
    case characterDollar = "CHARACTER_36"  // '$'
    case characterHash = "CHARACTER_35"    // '#'
    case characterQuestion = "CHARACTER_63"    // '?'
    case characterAsterisk = "CHARACTER_42"    // '*'

    // MARK: - Playlist Editor (PLEDIT.BMP)

    case playlistTopTile = "PLAYLIST_TOP_TILE"
    case playlistTopLeftCorner = "PLAYLIST_TOP_LEFT_CORNER"
    case playlistTitleBar = "PLAYLIST_TITLE_BAR"
    case playlistTopRightCorner = "PLAYLIST_TOP_RIGHT_CORNER"
    case playlistTopTileSelected = "PLAYLIST_TOP_TILE_SELECTED"
    case playlistTopLeftSelected = "PLAYLIST_TOP_LEFT_SELECTED"
    case playlistTitleBarSelected = "PLAYLIST_TITLE_BAR_SELECTED"
    case playlistTopRightCornerSelected = "PLAYLIST_TOP_RIGHT_CORNER_SELECTED"
    case playlistLeftTile = "PLAYLIST_LEFT_TILE"
    case playlistRightTile = "PLAYLIST_RIGHT_TILE"
    case playlistBottomTile = "PLAYLIST_BOTTOM_TILE"
    case playlistBottomLeftCorner = "PLAYLIST_BOTTOM_LEFT_CORNER"
    case playlistBottomRightCorner = "PLAYLIST_BOTTOM_RIGHT_CORNER"
    case playlistVisualizerBackground = "PLAYLIST_VISUALIZER_BACKGROUND"
    case playlistShadeBackground = "PLAYLIST_SHADE_BACKGROUND"
    case playlistShadeBackgroundLeft = "PLAYLIST_SHADE_BACKGROUND_LEFT"
    case playlistShadeBackgroundRight = "PLAYLIST_SHADE_BACKGROUND_RIGHT"
    case playlistShadeBackgroundRightSelected = "PLAYLIST_SHADE_BACKGROUND_RIGHT_SELECTED"
    case playlistScrollHandleSelected = "PLAYLIST_SCROLL_HANDLE_SELECTED"
    case playlistScrollHandle = "PLAYLIST_SCROLL_HANDLE"
    case playlistAddUrl = "PLAYLIST_ADD_URL"
    case playlistAddUrlSelected = "PLAYLIST_ADD_URL_SELECTED"
    case playlistAddDir = "PLAYLIST_ADD_DIR"
    case playlistAddDirSelected = "PLAYLIST_ADD_DIR_SELECTED"
    case playlistAddFile = "PLAYLIST_ADD_FILE"
    case playlistAddFileSelected = "PLAYLIST_ADD_FILE_SELECTED"
    case playlistRemoveAll = "PLAYLIST_REMOVE_ALL"
    case playlistRemoveAllSelected = "PLAYLIST_REMOVE_ALL_SELECTED"
    case playlistCrop = "PLAYLIST_CROP"
    case playlistCropSelected = "PLAYLIST_CROP_SELECTED"
    case playlistRemoveSelected = "PLAYLIST_REMOVE_SELECTED"
    case playlistRemoveSelectedSelected = "PLAYLIST_REMOVE_SELECTED_SELECTED"
    case playlistRemoveMisc = "PLAYLIST_REMOVE_MISC"
    case playlistRemoveMiscSelected = "PLAYLIST_REMOVE_MISC_SELECTED"
    case playlistInvertSelection = "PLAYLIST_INVERT_SELECTION"
    case playlistInvertSelectionSelected = "PLAYLIST_INVERT_SELECTION_SELECTED"
    case playlistSelectZero = "PLAYLIST_SELECT_ZERO"
    case playlistSelectZeroSelected = "PLAYLIST_SELECT_ZERO_SELECTED"
    case playlistSelectAll = "PLAYLIST_SELECT_ALL"
    case playlistSelectAllSelected = "PLAYLIST_SELECT_ALL_SELECTED"
    case playlistSortList = "PLAYLIST_SORT_LIST"
    case playlistSortListSelected = "PLAYLIST_SORT_LIST_SELECTED"
    case playlistFileInfo = "PLAYLIST_FILE_INFO"
    case playlistFileInfoSelected = "PLAYLIST_FILE_INFO_SELECTED"
    case playlistMiscOptions = "PLAYLIST_MISC_OPTIONS"
    case playlistMiscOptionsSelected = "PLAYLIST_MISC_OPTIONS_SELECTED"
    case playlistNewList = "PLAYLIST_NEW_LIST"
    case playlistNewListSelected = "PLAYLIST_NEW_LIST_SELECTED"
    case playlistSaveList = "PLAYLIST_SAVE_LIST"
    case playlistSaveListSelected = "PLAYLIST_SAVE_LIST_SELECTED"
    case playlistLoadList = "PLAYLIST_LOAD_LIST"
    case playlistLoadListSelected = "PLAYLIST_LOAD_LIST_SELECTED"
    case playlistAddMenuBar = "PLAYLIST_ADD_MENU_BAR"
    case playlistRemoveMenuBar = "PLAYLIST_REMOVE_MENU_BAR"
    case playlistSelectMenuBar = "PLAYLIST_SELECT_MENU_BAR"
    case playlistMiscMenuBar = "PLAYLIST_MISC_MENU_BAR"
    case playlistListBar = "PLAYLIST_LIST_BAR"
    case playlistCloseSelected = "PLAYLIST_CLOSE_SELECTED"
    case playlistCollapseSelected = "PLAYLIST_COLLAPSE_SELECTED"
    case playlistExpandSelected = "PLAYLIST_EXPAND_SELECTED"

    // MARK: - Equalizer Window (EQMAIN.BMP)

    case eqWindowBackground = "EQ_WINDOW_BACKGROUND"
    case eqTitleBar = "EQ_TITLE_BAR"
    case eqTitleBarSelected = "EQ_TITLE_BAR_SELECTED"
    case eqSliderBackground = "EQ_SLIDER_BACKGROUND"
    case eqSliderThumb = "EQ_SLIDER_THUMB"
    case eqSliderThumbSelected = "EQ_SLIDER_THUMB_SELECTED"
    case eqCloseButton = "EQ_CLOSE_BUTTON"
    case eqCloseButtonActive = "EQ_CLOSE_BUTTON_ACTIVE"
    case eqMaximizeButtonActiveFallback = "EQ_MAXIMIZE_BUTTON_ACTIVE_FALLBACK"
    case eqOnButton = "EQ_ON_BUTTON"
    case eqOnButtonDepressed = "EQ_ON_BUTTON_DEPRESSED"
    case eqOnButtonSelected = "EQ_ON_BUTTON_SELECTED"
    case eqOnButtonSelectedDepressed = "EQ_ON_BUTTON_SELECTED_DEPRESSED"
    case eqAutoButton = "EQ_AUTO_BUTTON"
    case eqAutoButtonDepressed = "EQ_AUTO_BUTTON_DEPRESSED"
    case eqAutoButtonSelected = "EQ_AUTO_BUTTON_SELECTED"
    case eqAutoButtonSelectedDepressed = "EQ_AUTO_BUTTON_SELECTED_DEPRESSED"
    case eqGraphBackground = "EQ_GRAPH_BACKGROUND"
    case eqGraphLineColors = "EQ_GRAPH_LINE_COLORS"
    case eqPresetsButton = "EQ_PRESETS_BUTTON"
    case eqPresetsButtonSelected = "EQ_PRESETS_BUTTON_SELECTED"
    case eqPreampLine = "EQ_PREAMP_LINE"

    // MARK: - Equalizer Windowshade (EQ_EX.BMP)

    case eqShadeBackgroundSelected = "EQ_SHADE_BACKGROUND_SELECTED"
    case eqShadeBackground = "EQ_SHADE_BACKGROUND"
    case eqShadeVolumeSliderLeft = "EQ_SHADE_VOLUME_SLIDER_LEFT"
    case eqShadeVolumeSliderCenter = "EQ_SHADE_VOLUME_SLIDER_CENTER"
    case eqShadeVolumeSliderRight = "EQ_SHADE_VOLUME_SLIDER_RIGHT"
    case eqShadeBalanceSliderLeft = "EQ_SHADE_BALANCE_SLIDER_LEFT"
    case eqShadeBalanceSliderCenter = "EQ_SHADE_BALANCE_SLIDER_CENTER"
    case eqShadeBalanceSliderRight = "EQ_SHADE_BALANCE_SLIDER_RIGHT"
    case eqMaximizeButtonActive = "EQ_MAXIMIZE_BUTTON_ACTIVE"
    case eqMinimizeButtonActive = "EQ_MINIMIZE_BUTTON_ACTIVE"
    case eqShadeCloseButton = "EQ_SHADE_CLOSE_BUTTON"
    case eqShadeCloseButtonActive = "EQ_SHADE_CLOSE_BUTTON_ACTIVE"
}

// MARK: - Character Sprite Lookup

/// Character codes for text display sprites.
/// These are generated from the TEXT.BMP sprite sheet.
public extension SpriteName {
    /// Returns the SpriteName for a character, if available.
    static func character(_ char: Character) -> SpriteName? {
        characterMap[char]
    }

    /// All available character sprites.
    static let characterMap: [Character: SpriteName] = {
        var map: [Character: SpriteName] = [:]
        for (char, sprite) in characterSprites {
            map[char] = sprite
        }
        return map
    }()

    private static let characterSprites: [(Character, SpriteName)] = [
        ("A", .characterA), ("B", .characterB), ("C", .characterC),
        ("D", .characterD), ("E", .characterE), ("F", .characterF),
        ("G", .characterG), ("H", .characterH), ("I", .characterI),
        ("J", .characterJ), ("K", .characterK), ("L", .characterL),
        ("M", .characterM), ("N", .characterN), ("O", .characterO),
        ("P", .characterP), ("Q", .characterQ), ("R", .characterR),
        ("S", .characterS), ("T", .characterT), ("U", .characterU),
        ("V", .characterV), ("W", .characterW), ("X", .characterX),
        ("Y", .characterY), ("Z", .characterZ),
        ("0", .character0), ("1", .character1), ("2", .character2),
        ("3", .character3), ("4", .character4), ("5", .character5),
        ("6", .character6), ("7", .character7), ("8", .character8),
        ("9", .character9),
        (" ", .characterSpace), (".", .characterDot), (":", .characterColon),
        ("-", .characterDash), ("(", .characterOpenParen),
        (")", .characterCloseParen), ("\"", .characterQuote),
        ("@", .characterAt), ("'", .characterApostrophe),
        ("!", .characterExclamation), ("_", .characterUnderscore),
        ("+", .characterPlus), ("\\", .characterBackslash),
        ("/", .characterSlash), ("[", .characterOpenBracket),
        ("]", .characterCloseBracket), ("^", .characterCaret),
        ("&", .characterAmpersand), ("%", .characterPercent),
        (",", .characterComma), ("=", .characterEquals),
        ("$", .characterDollar), ("#", .characterHash),
        ("?", .characterQuestion), ("*", .characterAsterisk),
    ]
}
