import Foundation
import CoreGraphics

/// Defines the location of a sprite within a BMP sprite sheet.
public struct SpriteRegion: Sendable {
    public let x: Int
    public let y: Int
    public let width: Int
    public let height: Int

    public init(x: Int, y: Int, width: Int, height: Int) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
    }

    /// Convert to CGRect for image cropping.
    public var cgRect: CGRect {
        CGRect(x: x, y: y, width: width, height: height)
    }
}

/// Maps sprite names to their BMP source file and region coordinates.
///
/// Coordinate definitions ported from Webamp project:
/// https://github.com/captbaritone/webamp/blob/master/packages/webamp/js/skinSprites.ts
public enum SpriteDefinitions {

    /// BMP file names (case-insensitive in Winamp skins).
    public enum BMPFile: String, CaseIterable, Sendable {
        case main = "MAIN"
        case cbuttons = "CBUTTONS"
        case titlebar = "TITLEBAR"
        case posbar = "POSBAR"
        case volume = "VOLUME"
        case balance = "BALANCE"
        case shufrep = "SHUFREP"
        case playpaus = "PLAYPAUS"
        case monoster = "MONOSTER"
        case numbers = "NUMBERS"
        case numsEx = "NUMS_EX"
        case text = "TEXT"
        case eqmain = "EQMAIN"
        case eqEx = "EQ_EX"
        case pledit = "PLEDIT"
        case mb = "MB"
        case gen = "GEN"

        /// Returns the filename with .bmp extension.
        public var filename: String {
            rawValue + ".BMP"
        }
    }

    /// Returns which BMP file contains the given sprite.
    public static func bmpFile(for sprite: SpriteName) -> BMPFile? {
        spriteToFile[sprite]
    }

    /// Returns the region within the BMP file for the given sprite.
    public static func region(for sprite: SpriteName) -> SpriteRegion? {
        spriteRegions[sprite]
    }

    /// All sprites that should be extracted from a given BMP file.
    public static func sprites(in file: BMPFile) -> [SpriteName] {
        fileToSprites[file] ?? []
    }

    // MARK: - Private Mappings

    private static let spriteToFile: [SpriteName: BMPFile] = {
        var map: [SpriteName: BMPFile] = [:]
        for (file, sprites) in fileToSprites {
            for sprite in sprites {
                map[sprite] = file
            }
        }
        return map
    }()

    private static let fileToSprites: [BMPFile: [SpriteName]] = [
        .main: [
            .mainWindowBackground,
        ],
        .cbuttons: [
            .mainPreviousButton, .mainPreviousButtonActive,
            .mainPlayButton, .mainPlayButtonActive,
            .mainPauseButton, .mainPauseButtonActive,
            .mainStopButton, .mainStopButtonActive,
            .mainNextButton, .mainNextButtonActive,
            .mainEjectButton, .mainEjectButtonActive,
        ],
        .titlebar: [
            .mainTitleBar, .mainTitleBarSelected,
            .mainEasterEggTitleBar, .mainEasterEggTitleBarSelected,
            .mainOptionsButton, .mainOptionsButtonDepressed,
            .mainMinimizeButton, .mainMinimizeButtonDepressed,
            .mainShadeButton, .mainShadeButtonDepressed,
            .mainCloseButton, .mainCloseButtonDepressed,
            .mainClutterBarBackground, .mainClutterBarBackgroundDisabled,
            .mainClutterBarButtonOSelected, .mainClutterBarButtonASelected,
            .mainClutterBarButtonISelected, .mainClutterBarButtonDSelected,
            .mainClutterBarButtonVSelected,
            .mainShadeBackground, .mainShadeBackgroundSelected,
            .mainShadeButtonSelected, .mainShadeButtonSelectedDepressed,
            .mainShadePositionBackground, .mainShadePositionThumb,
            .mainShadePositionThumbLeft, .mainShadePositionThumbRight,
        ],
        .posbar: [
            .mainPositionSliderBackground,
            .mainPositionSliderThumb, .mainPositionSliderThumbSelected,
        ],
        .volume: [
            .mainVolumeBackground,
            .mainVolumeThumb, .mainVolumeThumbSelected,
        ],
        .balance: [
            .mainBalanceBackground,
            .mainBalanceThumb, .mainBalanceThumbActive,
        ],
        .shufrep: [
            .mainShuffleButton, .mainShuffleButtonDepressed,
            .mainShuffleButtonSelected, .mainShuffleButtonSelectedDepressed,
            .mainRepeatButton, .mainRepeatButtonDepressed,
            .mainRepeatButtonSelected, .mainRepeatButtonSelectedDepressed,
            .mainEqButton, .mainEqButtonSelected,
            .mainEqButtonDepressed, .mainEqButtonDepressedSelected,
            .mainPlaylistButton, .mainPlaylistButtonSelected,
            .mainPlaylistButtonDepressed, .mainPlaylistButtonDepressedSelected,
        ],
        .playpaus: [
            .mainPlayingIndicator, .mainPausedIndicator,
            .mainStoppedIndicator, .mainNotWorkingIndicator,
            .mainWorkingIndicator,
        ],
        .monoster: [
            .mainStereo, .mainStereoSelected,
            .mainMono, .mainMonoSelected,
        ],
        .numbers: [
            .noMinusSign, .minusSign,
            .digit0, .digit1, .digit2, .digit3, .digit4,
            .digit5, .digit6, .digit7, .digit8, .digit9,
        ],
        .numsEx: [
            .noMinusSignEx, .minusSignEx,
            .digit0Ex, .digit1Ex, .digit2Ex, .digit3Ex, .digit4Ex,
            .digit5Ex, .digit6Ex, .digit7Ex, .digit8Ex, .digit9Ex,
        ],
        .text: characterSprites(),
        .pledit: [
            .playlistTopTile, .playlistTopLeftCorner,
            .playlistTitleBar, .playlistTopRightCorner,
            .playlistTopTileSelected, .playlistTopLeftSelected,
            .playlistTitleBarSelected, .playlistTopRightCornerSelected,
            .playlistLeftTile, .playlistRightTile,
            .playlistBottomTile, .playlistBottomLeftCorner,
            .playlistBottomRightCorner, .playlistVisualizerBackground,
            .playlistShadeBackground, .playlistShadeBackgroundLeft,
            .playlistShadeBackgroundRight, .playlistShadeBackgroundRightSelected,
            .playlistScrollHandleSelected, .playlistScrollHandle,
            .playlistAddUrl, .playlistAddUrlSelected,
            .playlistAddDir, .playlistAddDirSelected,
            .playlistAddFile, .playlistAddFileSelected,
            .playlistRemoveAll, .playlistRemoveAllSelected,
            .playlistCrop, .playlistCropSelected,
            .playlistRemoveSelected, .playlistRemoveSelectedSelected,
            .playlistRemoveMisc, .playlistRemoveMiscSelected,
            .playlistInvertSelection, .playlistInvertSelectionSelected,
            .playlistSelectZero, .playlistSelectZeroSelected,
            .playlistSelectAll, .playlistSelectAllSelected,
            .playlistSortList, .playlistSortListSelected,
            .playlistFileInfo, .playlistFileInfoSelected,
            .playlistMiscOptions, .playlistMiscOptionsSelected,
            .playlistNewList, .playlistNewListSelected,
            .playlistSaveList, .playlistSaveListSelected,
            .playlistLoadList, .playlistLoadListSelected,
            .playlistAddMenuBar, .playlistRemoveMenuBar,
            .playlistSelectMenuBar, .playlistMiscMenuBar,
            .playlistListBar,
            .playlistCloseSelected, .playlistCollapseSelected,
            .playlistExpandSelected,
        ],
        .eqmain: [
            .eqWindowBackground, .eqTitleBar, .eqTitleBarSelected,
            .eqSliderBackground, .eqSliderThumb, .eqSliderThumbSelected,
            .eqCloseButton, .eqCloseButtonActive,
            .eqMaximizeButtonActiveFallback,
            .eqOnButton, .eqOnButtonDepressed,
            .eqOnButtonSelected, .eqOnButtonSelectedDepressed,
            .eqAutoButton, .eqAutoButtonDepressed,
            .eqAutoButtonSelected, .eqAutoButtonSelectedDepressed,
            .eqGraphBackground, .eqGraphLineColors,
            .eqPresetsButton, .eqPresetsButtonSelected,
            .eqPreampLine,
        ],
        .eqEx: [
            .eqShadeBackgroundSelected, .eqShadeBackground,
            .eqShadeVolumeSliderLeft, .eqShadeVolumeSliderCenter,
            .eqShadeVolumeSliderRight,
            .eqShadeBalanceSliderLeft, .eqShadeBalanceSliderCenter,
            .eqShadeBalanceSliderRight,
            .eqMaximizeButtonActive, .eqMinimizeButtonActive,
            .eqShadeCloseButton, .eqShadeCloseButtonActive,
        ],
        .mb: [
            .mbTitleLeftSelected, .mbTitleMiddleSelected,
            .mbTitleFillSelected, .mbTitleRightSelected,
            .mbTitleLeft, .mbTitleMiddle,
            .mbTitleFill, .mbTitleRight,
        ],
        .gen: [
            .genTopLeftSelected, .genTopLeftEndSelected,
            .genTopCenterFillSelected, .genTopRightEndSelected,
            .genTopLeftRightFillSelected, .genTopRightSelected,
            .genTopLeft, .genTopLeftEnd,
            .genTopCenterFill, .genTopRightEnd,
            .genTopLeftRightFill, .genTopRight,
            .genBottomLeft, .genBottomRight, .genBottomFill,
            .genMiddleLeft, .genMiddleLeftBottom,
            .genMiddleRight, .genMiddleRightBottom,
            .genCloseSelected,
        ],
    ]

    private static func characterSprites() -> [SpriteName] {
        [
            .characterA, .characterB, .characterC, .characterD, .characterE,
            .characterF, .characterG, .characterH, .characterI, .characterJ,
            .characterK, .characterL, .characterM, .characterN, .characterO,
            .characterP, .characterQ, .characterR, .characterS, .characterT,
            .characterU, .characterV, .characterW, .characterX, .characterY,
            .characterZ,
            .character0, .character1, .character2, .character3, .character4,
            .character5, .character6, .character7, .character8, .character9,
            .characterSpace, .characterQuote, .characterAt, .characterDot,
            .characterColon, .characterOpenParen, .characterCloseParen,
            .characterDash, .characterApostrophe, .characterExclamation,
            .characterUnderscore, .characterPlus, .characterBackslash,
            .characterSlash, .characterOpenBracket, .characterCloseBracket,
            .characterCaret, .characterAmpersand, .characterPercent,
            .characterComma, .characterEquals, .characterDollar,
            .characterHash, .characterQuestion, .characterAsterisk,
        ]
    }

    // MARK: - Sprite Regions (coordinates from Webamp)

    private static let spriteRegions: [SpriteName: SpriteRegion] = [
        // MAIN.BMP
        .mainWindowBackground: SpriteRegion(x: 0, y: 0, width: 275, height: 116),

        // CBUTTONS.BMP (136x36, buttons are 23x18)
        .mainPreviousButton: SpriteRegion(x: 0, y: 0, width: 23, height: 18),
        .mainPreviousButtonActive: SpriteRegion(x: 0, y: 18, width: 23, height: 18),
        .mainPlayButton: SpriteRegion(x: 23, y: 0, width: 23, height: 18),
        .mainPlayButtonActive: SpriteRegion(x: 23, y: 18, width: 23, height: 18),
        .mainPauseButton: SpriteRegion(x: 46, y: 0, width: 23, height: 18),
        .mainPauseButtonActive: SpriteRegion(x: 46, y: 18, width: 23, height: 18),
        .mainStopButton: SpriteRegion(x: 69, y: 0, width: 23, height: 18),
        .mainStopButtonActive: SpriteRegion(x: 69, y: 18, width: 23, height: 18),
        .mainNextButton: SpriteRegion(x: 92, y: 0, width: 22, height: 18),
        .mainNextButtonActive: SpriteRegion(x: 92, y: 18, width: 22, height: 18),
        .mainEjectButton: SpriteRegion(x: 114, y: 0, width: 22, height: 16),
        .mainEjectButtonActive: SpriteRegion(x: 114, y: 16, width: 22, height: 16),

        // TITLEBAR.BMP
        .mainTitleBar: SpriteRegion(x: 27, y: 15, width: 275, height: 14),
        .mainTitleBarSelected: SpriteRegion(x: 27, y: 0, width: 275, height: 14),
        .mainEasterEggTitleBar: SpriteRegion(x: 27, y: 72, width: 275, height: 14),
        .mainEasterEggTitleBarSelected: SpriteRegion(x: 27, y: 57, width: 275, height: 14),
        .mainOptionsButton: SpriteRegion(x: 0, y: 0, width: 9, height: 9),
        .mainOptionsButtonDepressed: SpriteRegion(x: 0, y: 9, width: 9, height: 9),
        .mainMinimizeButton: SpriteRegion(x: 9, y: 0, width: 9, height: 9),
        .mainMinimizeButtonDepressed: SpriteRegion(x: 9, y: 9, width: 9, height: 9),
        .mainShadeButton: SpriteRegion(x: 0, y: 18, width: 9, height: 9),
        .mainShadeButtonDepressed: SpriteRegion(x: 9, y: 18, width: 9, height: 9),
        .mainCloseButton: SpriteRegion(x: 18, y: 0, width: 9, height: 9),
        .mainCloseButtonDepressed: SpriteRegion(x: 18, y: 9, width: 9, height: 9),
        .mainClutterBarBackground: SpriteRegion(x: 304, y: 0, width: 8, height: 43),
        .mainClutterBarBackgroundDisabled: SpriteRegion(x: 312, y: 0, width: 8, height: 43),
        .mainClutterBarButtonOSelected: SpriteRegion(x: 304, y: 47, width: 8, height: 8),
        .mainClutterBarButtonASelected: SpriteRegion(x: 312, y: 55, width: 8, height: 7),
        .mainClutterBarButtonISelected: SpriteRegion(x: 320, y: 62, width: 8, height: 7),
        .mainClutterBarButtonDSelected: SpriteRegion(x: 328, y: 69, width: 8, height: 8),
        .mainClutterBarButtonVSelected: SpriteRegion(x: 336, y: 77, width: 8, height: 7),
        .mainShadeBackground: SpriteRegion(x: 27, y: 42, width: 275, height: 14),
        .mainShadeBackgroundSelected: SpriteRegion(x: 27, y: 29, width: 275, height: 14),
        .mainShadeButtonSelected: SpriteRegion(x: 0, y: 27, width: 9, height: 9),
        .mainShadeButtonSelectedDepressed: SpriteRegion(x: 9, y: 27, width: 9, height: 9),
        .mainShadePositionBackground: SpriteRegion(x: 0, y: 36, width: 17, height: 7),
        .mainShadePositionThumb: SpriteRegion(x: 20, y: 36, width: 3, height: 7),
        .mainShadePositionThumbLeft: SpriteRegion(x: 17, y: 36, width: 3, height: 7),
        .mainShadePositionThumbRight: SpriteRegion(x: 23, y: 36, width: 3, height: 7),

        // POSBAR.BMP
        .mainPositionSliderBackground: SpriteRegion(x: 0, y: 0, width: 248, height: 10),
        .mainPositionSliderThumb: SpriteRegion(x: 248, y: 0, width: 29, height: 10),
        .mainPositionSliderThumbSelected: SpriteRegion(x: 278, y: 0, width: 29, height: 10),

        // VOLUME.BMP
        .mainVolumeBackground: SpriteRegion(x: 0, y: 0, width: 68, height: 420),
        .mainVolumeThumb: SpriteRegion(x: 15, y: 422, width: 14, height: 11),
        .mainVolumeThumbSelected: SpriteRegion(x: 0, y: 422, width: 14, height: 11),

        // BALANCE.BMP
        .mainBalanceBackground: SpriteRegion(x: 9, y: 0, width: 38, height: 420),
        .mainBalanceThumb: SpriteRegion(x: 15, y: 422, width: 14, height: 11),
        .mainBalanceThumbActive: SpriteRegion(x: 0, y: 422, width: 14, height: 11),

        // SHUFREP.BMP
        .mainShuffleButton: SpriteRegion(x: 28, y: 0, width: 47, height: 15),
        .mainShuffleButtonDepressed: SpriteRegion(x: 28, y: 15, width: 47, height: 15),
        .mainShuffleButtonSelected: SpriteRegion(x: 28, y: 30, width: 47, height: 15),
        .mainShuffleButtonSelectedDepressed: SpriteRegion(x: 28, y: 45, width: 47, height: 15),
        .mainRepeatButton: SpriteRegion(x: 0, y: 0, width: 28, height: 15),
        .mainRepeatButtonDepressed: SpriteRegion(x: 0, y: 15, width: 28, height: 15),
        .mainRepeatButtonSelected: SpriteRegion(x: 0, y: 30, width: 28, height: 15),
        .mainRepeatButtonSelectedDepressed: SpriteRegion(x: 0, y: 45, width: 28, height: 15),
        .mainEqButton: SpriteRegion(x: 0, y: 61, width: 23, height: 12),
        .mainEqButtonSelected: SpriteRegion(x: 0, y: 73, width: 23, height: 12),
        .mainEqButtonDepressed: SpriteRegion(x: 46, y: 61, width: 23, height: 12),
        .mainEqButtonDepressedSelected: SpriteRegion(x: 46, y: 73, width: 23, height: 12),
        .mainPlaylistButton: SpriteRegion(x: 23, y: 61, width: 23, height: 12),
        .mainPlaylistButtonSelected: SpriteRegion(x: 23, y: 73, width: 23, height: 12),
        .mainPlaylistButtonDepressed: SpriteRegion(x: 69, y: 61, width: 23, height: 12),
        .mainPlaylistButtonDepressedSelected: SpriteRegion(x: 69, y: 73, width: 23, height: 12),

        // PLAYPAUS.BMP
        .mainPlayingIndicator: SpriteRegion(x: 0, y: 0, width: 9, height: 9),
        .mainPausedIndicator: SpriteRegion(x: 9, y: 0, width: 9, height: 9),
        .mainStoppedIndicator: SpriteRegion(x: 18, y: 0, width: 9, height: 9),
        .mainNotWorkingIndicator: SpriteRegion(x: 27, y: 0, width: 9, height: 9),
        .mainWorkingIndicator: SpriteRegion(x: 36, y: 0, width: 9, height: 9),

        // MONOSTER.BMP
        .mainStereo: SpriteRegion(x: 0, y: 12, width: 29, height: 12),
        .mainStereoSelected: SpriteRegion(x: 0, y: 0, width: 29, height: 12),
        .mainMono: SpriteRegion(x: 29, y: 12, width: 27, height: 12),
        .mainMonoSelected: SpriteRegion(x: 29, y: 0, width: 27, height: 12),

        // NUMBERS.BMP (digits are 9x13)
        .noMinusSign: SpriteRegion(x: 9, y: 6, width: 5, height: 1),
        .minusSign: SpriteRegion(x: 20, y: 6, width: 5, height: 1),
        .digit0: SpriteRegion(x: 0, y: 0, width: 9, height: 13),
        .digit1: SpriteRegion(x: 9, y: 0, width: 9, height: 13),
        .digit2: SpriteRegion(x: 18, y: 0, width: 9, height: 13),
        .digit3: SpriteRegion(x: 27, y: 0, width: 9, height: 13),
        .digit4: SpriteRegion(x: 36, y: 0, width: 9, height: 13),
        .digit5: SpriteRegion(x: 45, y: 0, width: 9, height: 13),
        .digit6: SpriteRegion(x: 54, y: 0, width: 9, height: 13),
        .digit7: SpriteRegion(x: 63, y: 0, width: 9, height: 13),
        .digit8: SpriteRegion(x: 72, y: 0, width: 9, height: 13),
        .digit9: SpriteRegion(x: 81, y: 0, width: 9, height: 13),

        // NUMS_EX.BMP
        .noMinusSignEx: SpriteRegion(x: 90, y: 0, width: 9, height: 13),
        .minusSignEx: SpriteRegion(x: 99, y: 0, width: 9, height: 13),
        .digit0Ex: SpriteRegion(x: 0, y: 0, width: 9, height: 13),
        .digit1Ex: SpriteRegion(x: 9, y: 0, width: 9, height: 13),
        .digit2Ex: SpriteRegion(x: 18, y: 0, width: 9, height: 13),
        .digit3Ex: SpriteRegion(x: 27, y: 0, width: 9, height: 13),
        .digit4Ex: SpriteRegion(x: 36, y: 0, width: 9, height: 13),
        .digit5Ex: SpriteRegion(x: 45, y: 0, width: 9, height: 13),
        .digit6Ex: SpriteRegion(x: 54, y: 0, width: 9, height: 13),
        .digit7Ex: SpriteRegion(x: 63, y: 0, width: 9, height: 13),
        .digit8Ex: SpriteRegion(x: 72, y: 0, width: 9, height: 13),
        .digit9Ex: SpriteRegion(x: 81, y: 0, width: 9, height: 13),

        // TEXT.BMP (characters are 5x6, arranged in rows)
        // Row 0: A-Z, ", @, (unused), (unused), space
        // Row 1: 0-9, ellipsis, ., :, (, ), -, ', !, _, +, \, /, [, ], ^, &, %, ,, =, $, #
        // Row 2: Å, Ö, Ä, ?, *
        .characterA: SpriteRegion(x: 0, y: 0, width: 5, height: 6),
        .characterB: SpriteRegion(x: 5, y: 0, width: 5, height: 6),
        .characterC: SpriteRegion(x: 10, y: 0, width: 5, height: 6),
        .characterD: SpriteRegion(x: 15, y: 0, width: 5, height: 6),
        .characterE: SpriteRegion(x: 20, y: 0, width: 5, height: 6),
        .characterF: SpriteRegion(x: 25, y: 0, width: 5, height: 6),
        .characterG: SpriteRegion(x: 30, y: 0, width: 5, height: 6),
        .characterH: SpriteRegion(x: 35, y: 0, width: 5, height: 6),
        .characterI: SpriteRegion(x: 40, y: 0, width: 5, height: 6),
        .characterJ: SpriteRegion(x: 45, y: 0, width: 5, height: 6),
        .characterK: SpriteRegion(x: 50, y: 0, width: 5, height: 6),
        .characterL: SpriteRegion(x: 55, y: 0, width: 5, height: 6),
        .characterM: SpriteRegion(x: 60, y: 0, width: 5, height: 6),
        .characterN: SpriteRegion(x: 65, y: 0, width: 5, height: 6),
        .characterO: SpriteRegion(x: 70, y: 0, width: 5, height: 6),
        .characterP: SpriteRegion(x: 75, y: 0, width: 5, height: 6),
        .characterQ: SpriteRegion(x: 80, y: 0, width: 5, height: 6),
        .characterR: SpriteRegion(x: 85, y: 0, width: 5, height: 6),
        .characterS: SpriteRegion(x: 90, y: 0, width: 5, height: 6),
        .characterT: SpriteRegion(x: 95, y: 0, width: 5, height: 6),
        .characterU: SpriteRegion(x: 100, y: 0, width: 5, height: 6),
        .characterV: SpriteRegion(x: 105, y: 0, width: 5, height: 6),
        .characterW: SpriteRegion(x: 110, y: 0, width: 5, height: 6),
        .characterX: SpriteRegion(x: 115, y: 0, width: 5, height: 6),
        .characterY: SpriteRegion(x: 120, y: 0, width: 5, height: 6),
        .characterZ: SpriteRegion(x: 125, y: 0, width: 5, height: 6),
        .characterQuote: SpriteRegion(x: 130, y: 0, width: 5, height: 6),
        .characterAt: SpriteRegion(x: 135, y: 0, width: 5, height: 6),
        .characterSpace: SpriteRegion(x: 150, y: 0, width: 5, height: 6),

        // Row 1 (y: 6)
        .character0: SpriteRegion(x: 0, y: 6, width: 5, height: 6),
        .character1: SpriteRegion(x: 5, y: 6, width: 5, height: 6),
        .character2: SpriteRegion(x: 10, y: 6, width: 5, height: 6),
        .character3: SpriteRegion(x: 15, y: 6, width: 5, height: 6),
        .character4: SpriteRegion(x: 20, y: 6, width: 5, height: 6),
        .character5: SpriteRegion(x: 25, y: 6, width: 5, height: 6),
        .character6: SpriteRegion(x: 30, y: 6, width: 5, height: 6),
        .character7: SpriteRegion(x: 35, y: 6, width: 5, height: 6),
        .character8: SpriteRegion(x: 40, y: 6, width: 5, height: 6),
        .character9: SpriteRegion(x: 45, y: 6, width: 5, height: 6),
        // ellipsis at 50, we skip it
        .characterDot: SpriteRegion(x: 55, y: 6, width: 5, height: 6),
        .characterColon: SpriteRegion(x: 60, y: 6, width: 5, height: 6),
        .characterOpenParen: SpriteRegion(x: 65, y: 6, width: 5, height: 6),
        .characterCloseParen: SpriteRegion(x: 70, y: 6, width: 5, height: 6),
        .characterDash: SpriteRegion(x: 75, y: 6, width: 5, height: 6),
        .characterApostrophe: SpriteRegion(x: 80, y: 6, width: 5, height: 6),
        .characterExclamation: SpriteRegion(x: 85, y: 6, width: 5, height: 6),
        .characterUnderscore: SpriteRegion(x: 90, y: 6, width: 5, height: 6),
        .characterPlus: SpriteRegion(x: 95, y: 6, width: 5, height: 6),
        .characterBackslash: SpriteRegion(x: 100, y: 6, width: 5, height: 6),
        .characterSlash: SpriteRegion(x: 105, y: 6, width: 5, height: 6),
        .characterOpenBracket: SpriteRegion(x: 110, y: 6, width: 5, height: 6),
        .characterCloseBracket: SpriteRegion(x: 115, y: 6, width: 5, height: 6),
        .characterCaret: SpriteRegion(x: 120, y: 6, width: 5, height: 6),
        .characterAmpersand: SpriteRegion(x: 125, y: 6, width: 5, height: 6),
        .characterPercent: SpriteRegion(x: 130, y: 6, width: 5, height: 6),
        .characterComma: SpriteRegion(x: 135, y: 6, width: 5, height: 6),
        .characterEquals: SpriteRegion(x: 140, y: 6, width: 5, height: 6),
        .characterDollar: SpriteRegion(x: 145, y: 6, width: 5, height: 6),
        .characterHash: SpriteRegion(x: 150, y: 6, width: 5, height: 6),

        // Row 2 (y: 12) - special chars
        .characterQuestion: SpriteRegion(x: 15, y: 12, width: 5, height: 6),
        .characterAsterisk: SpriteRegion(x: 20, y: 12, width: 5, height: 6),

        // PLEDIT.BMP
        .playlistTopTile: SpriteRegion(x: 127, y: 21, width: 25, height: 20),
        .playlistTopLeftCorner: SpriteRegion(x: 0, y: 21, width: 25, height: 20),
        .playlistTitleBar: SpriteRegion(x: 26, y: 21, width: 100, height: 20),
        .playlistTopRightCorner: SpriteRegion(x: 153, y: 21, width: 25, height: 20),
        .playlistTopTileSelected: SpriteRegion(x: 127, y: 0, width: 25, height: 20),
        .playlistTopLeftSelected: SpriteRegion(x: 0, y: 0, width: 25, height: 20),
        .playlistTitleBarSelected: SpriteRegion(x: 26, y: 0, width: 100, height: 20),
        .playlistTopRightCornerSelected: SpriteRegion(x: 153, y: 0, width: 25, height: 20),
        .playlistLeftTile: SpriteRegion(x: 0, y: 42, width: 12, height: 29),
        .playlistRightTile: SpriteRegion(x: 31, y: 42, width: 20, height: 29),
        .playlistBottomTile: SpriteRegion(x: 179, y: 0, width: 25, height: 38),
        .playlistBottomLeftCorner: SpriteRegion(x: 0, y: 72, width: 125, height: 38),
        .playlistBottomRightCorner: SpriteRegion(x: 126, y: 72, width: 150, height: 38),
        .playlistVisualizerBackground: SpriteRegion(x: 205, y: 0, width: 75, height: 38),
        .playlistShadeBackground: SpriteRegion(x: 72, y: 57, width: 25, height: 14),
        .playlistShadeBackgroundLeft: SpriteRegion(x: 72, y: 42, width: 25, height: 14),
        .playlistShadeBackgroundRight: SpriteRegion(x: 99, y: 57, width: 50, height: 14),
        .playlistShadeBackgroundRightSelected: SpriteRegion(x: 99, y: 42, width: 50, height: 14),
        .playlistScrollHandleSelected: SpriteRegion(x: 61, y: 53, width: 8, height: 18),
        .playlistScrollHandle: SpriteRegion(x: 52, y: 53, width: 8, height: 18),
        .playlistAddUrl: SpriteRegion(x: 0, y: 111, width: 22, height: 18),
        .playlistAddUrlSelected: SpriteRegion(x: 23, y: 111, width: 22, height: 18),
        .playlistAddDir: SpriteRegion(x: 0, y: 130, width: 22, height: 18),
        .playlistAddDirSelected: SpriteRegion(x: 23, y: 130, width: 22, height: 18),
        .playlistAddFile: SpriteRegion(x: 0, y: 149, width: 22, height: 18),
        .playlistAddFileSelected: SpriteRegion(x: 23, y: 149, width: 22, height: 18),
        .playlistRemoveAll: SpriteRegion(x: 54, y: 111, width: 22, height: 18),
        .playlistRemoveAllSelected: SpriteRegion(x: 77, y: 111, width: 22, height: 18),
        .playlistCrop: SpriteRegion(x: 54, y: 130, width: 22, height: 18),
        .playlistCropSelected: SpriteRegion(x: 77, y: 130, width: 22, height: 18),
        .playlistRemoveSelected: SpriteRegion(x: 54, y: 149, width: 22, height: 18),
        .playlistRemoveSelectedSelected: SpriteRegion(x: 77, y: 149, width: 22, height: 18),
        .playlistRemoveMisc: SpriteRegion(x: 54, y: 168, width: 22, height: 18),
        .playlistRemoveMiscSelected: SpriteRegion(x: 77, y: 168, width: 22, height: 18),
        .playlistInvertSelection: SpriteRegion(x: 104, y: 111, width: 22, height: 18),
        .playlistInvertSelectionSelected: SpriteRegion(x: 127, y: 111, width: 22, height: 18),
        .playlistSelectZero: SpriteRegion(x: 104, y: 130, width: 22, height: 18),
        .playlistSelectZeroSelected: SpriteRegion(x: 127, y: 130, width: 22, height: 18),
        .playlistSelectAll: SpriteRegion(x: 104, y: 149, width: 22, height: 18),
        .playlistSelectAllSelected: SpriteRegion(x: 127, y: 149, width: 22, height: 18),
        .playlistSortList: SpriteRegion(x: 154, y: 111, width: 22, height: 18),
        .playlistSortListSelected: SpriteRegion(x: 177, y: 111, width: 22, height: 18),
        .playlistFileInfo: SpriteRegion(x: 154, y: 130, width: 22, height: 18),
        .playlistFileInfoSelected: SpriteRegion(x: 177, y: 130, width: 22, height: 18),
        .playlistMiscOptions: SpriteRegion(x: 154, y: 149, width: 22, height: 18),
        .playlistMiscOptionsSelected: SpriteRegion(x: 177, y: 149, width: 22, height: 18),
        .playlistNewList: SpriteRegion(x: 204, y: 111, width: 22, height: 18),
        .playlistNewListSelected: SpriteRegion(x: 227, y: 111, width: 22, height: 18),
        .playlistSaveList: SpriteRegion(x: 204, y: 130, width: 22, height: 18),
        .playlistSaveListSelected: SpriteRegion(x: 227, y: 130, width: 22, height: 18),
        .playlistLoadList: SpriteRegion(x: 204, y: 149, width: 22, height: 18),
        .playlistLoadListSelected: SpriteRegion(x: 227, y: 149, width: 22, height: 18),
        .playlistAddMenuBar: SpriteRegion(x: 48, y: 111, width: 3, height: 54),
        .playlistRemoveMenuBar: SpriteRegion(x: 100, y: 111, width: 3, height: 72),
        .playlistSelectMenuBar: SpriteRegion(x: 150, y: 111, width: 3, height: 54),
        .playlistMiscMenuBar: SpriteRegion(x: 200, y: 111, width: 3, height: 54),
        .playlistListBar: SpriteRegion(x: 250, y: 111, width: 3, height: 54),
        .playlistCloseSelected: SpriteRegion(x: 52, y: 42, width: 9, height: 9),
        .playlistCollapseSelected: SpriteRegion(x: 62, y: 42, width: 9, height: 9),
        .playlistExpandSelected: SpriteRegion(x: 150, y: 42, width: 9, height: 9),

        // EQMAIN.BMP
        .eqWindowBackground: SpriteRegion(x: 0, y: 0, width: 275, height: 116),
        .eqTitleBar: SpriteRegion(x: 0, y: 149, width: 275, height: 14),
        .eqTitleBarSelected: SpriteRegion(x: 0, y: 134, width: 275, height: 14),
        .eqSliderBackground: SpriteRegion(x: 13, y: 164, width: 209, height: 129),
        .eqSliderThumb: SpriteRegion(x: 0, y: 164, width: 11, height: 11),
        .eqSliderThumbSelected: SpriteRegion(x: 0, y: 176, width: 11, height: 11),
        .eqCloseButton: SpriteRegion(x: 0, y: 116, width: 9, height: 9),
        .eqCloseButtonActive: SpriteRegion(x: 0, y: 125, width: 9, height: 9),
        .eqMaximizeButtonActiveFallback: SpriteRegion(x: 254, y: 152, width: 9, height: 9),
        .eqOnButton: SpriteRegion(x: 10, y: 119, width: 26, height: 12),
        .eqOnButtonDepressed: SpriteRegion(x: 128, y: 119, width: 26, height: 12),
        .eqOnButtonSelected: SpriteRegion(x: 69, y: 119, width: 26, height: 12),
        .eqOnButtonSelectedDepressed: SpriteRegion(x: 187, y: 119, width: 26, height: 12),
        .eqAutoButton: SpriteRegion(x: 36, y: 119, width: 32, height: 12),
        .eqAutoButtonDepressed: SpriteRegion(x: 154, y: 119, width: 32, height: 12),
        .eqAutoButtonSelected: SpriteRegion(x: 95, y: 119, width: 32, height: 12),
        .eqAutoButtonSelectedDepressed: SpriteRegion(x: 213, y: 119, width: 32, height: 12),
        .eqGraphBackground: SpriteRegion(x: 0, y: 294, width: 113, height: 19),
        .eqGraphLineColors: SpriteRegion(x: 115, y: 294, width: 1, height: 19),
        .eqPresetsButton: SpriteRegion(x: 224, y: 164, width: 44, height: 12),
        .eqPresetsButtonSelected: SpriteRegion(x: 224, y: 176, width: 44, height: 12),
        .eqPreampLine: SpriteRegion(x: 0, y: 314, width: 113, height: 1),

        // EQ_EX.BMP
        .eqShadeBackgroundSelected: SpriteRegion(x: 0, y: 0, width: 275, height: 14),
        .eqShadeBackground: SpriteRegion(x: 0, y: 15, width: 275, height: 14),
        .eqShadeVolumeSliderLeft: SpriteRegion(x: 1, y: 30, width: 3, height: 7),
        .eqShadeVolumeSliderCenter: SpriteRegion(x: 4, y: 30, width: 3, height: 7),
        .eqShadeVolumeSliderRight: SpriteRegion(x: 7, y: 30, width: 3, height: 7),
        .eqShadeBalanceSliderLeft: SpriteRegion(x: 11, y: 30, width: 3, height: 7),
        .eqShadeBalanceSliderCenter: SpriteRegion(x: 14, y: 30, width: 3, height: 7),
        .eqShadeBalanceSliderRight: SpriteRegion(x: 17, y: 30, width: 3, height: 7),
        .eqMaximizeButtonActive: SpriteRegion(x: 1, y: 38, width: 9, height: 9),
        .eqMinimizeButtonActive: SpriteRegion(x: 1, y: 47, width: 9, height: 9),
        .eqShadeCloseButton: SpriteRegion(x: 11, y: 38, width: 9, height: 9),
        .eqShadeCloseButtonActive: SpriteRegion(x: 11, y: 47, width: 9, height: 9),

        // MB.BMP — Browser title bar (selected, y=0)
        .mbTitleLeftSelected: SpriteRegion(x: 0, y: 0, width: 25, height: 20),
        .mbTitleMiddleSelected: SpriteRegion(x: 26, y: 0, width: 100, height: 20),
        .mbTitleFillSelected: SpriteRegion(x: 127, y: 0, width: 25, height: 20),
        .mbTitleRightSelected: SpriteRegion(x: 153, y: 0, width: 25, height: 20),

        // MB.BMP — Browser title bar (unselected, y=21)
        .mbTitleLeft: SpriteRegion(x: 0, y: 21, width: 25, height: 20),
        .mbTitleMiddle: SpriteRegion(x: 26, y: 21, width: 100, height: 20),
        .mbTitleFill: SpriteRegion(x: 127, y: 21, width: 25, height: 20),
        .mbTitleRight: SpriteRegion(x: 153, y: 21, width: 25, height: 20),

        // GEN.BMP — Title bar (selected)
        .genTopLeftSelected: SpriteRegion(x: 0, y: 0, width: 25, height: 20),
        .genTopLeftEndSelected: SpriteRegion(x: 26, y: 0, width: 25, height: 20),
        .genTopCenterFillSelected: SpriteRegion(x: 52, y: 0, width: 25, height: 20),
        .genTopRightEndSelected: SpriteRegion(x: 78, y: 0, width: 25, height: 20),
        .genTopLeftRightFillSelected: SpriteRegion(x: 104, y: 0, width: 25, height: 20),
        .genTopRightSelected: SpriteRegion(x: 130, y: 0, width: 25, height: 20),

        // GEN.BMP — Title bar (unselected)
        .genTopLeft: SpriteRegion(x: 0, y: 21, width: 25, height: 20),
        .genTopLeftEnd: SpriteRegion(x: 26, y: 21, width: 25, height: 20),
        .genTopCenterFill: SpriteRegion(x: 52, y: 21, width: 25, height: 20),
        .genTopRightEnd: SpriteRegion(x: 78, y: 21, width: 25, height: 20),
        .genTopLeftRightFill: SpriteRegion(x: 104, y: 21, width: 25, height: 20),
        .genTopRight: SpriteRegion(x: 130, y: 21, width: 25, height: 20),

        // GEN.BMP — Bottom bar, edges, close button
        .genBottomLeft: SpriteRegion(x: 0, y: 42, width: 125, height: 14),
        .genBottomRight: SpriteRegion(x: 0, y: 57, width: 125, height: 14),
        .genBottomFill: SpriteRegion(x: 127, y: 72, width: 25, height: 14),
        .genMiddleLeft: SpriteRegion(x: 127, y: 42, width: 11, height: 29),
        .genMiddleLeftBottom: SpriteRegion(x: 158, y: 42, width: 11, height: 24),
        .genMiddleRight: SpriteRegion(x: 139, y: 42, width: 8, height: 29),
        .genMiddleRightBottom: SpriteRegion(x: 170, y: 42, width: 8, height: 24),
        .genCloseSelected: SpriteRegion(x: 148, y: 42, width: 9, height: 9),
    ]
}
