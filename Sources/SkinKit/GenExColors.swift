import CoreGraphics

/// Colors extracted from GENEX.BMP's top pixel row (y=0).
/// Each color is sampled at a specific x-coordinate.
/// Used to style general-purpose window content (browse window).
public struct GenExColors: Sendable {
    public let itemBackground: CGColor          // x=48
    public let itemForeground: CGColor          // x=50
    public let windowBackground: CGColor        // x=52
    public let buttonText: CGColor              // x=54
    public let windowText: CGColor              // x=56
    public let divider: CGColor                 // x=58
    public let playlistSelection: CGColor       // x=60
    public let listHeaderBackground: CGColor    // x=62
    public let listHeaderText: CGColor          // x=64
    public let listHeaderFrameTopAndLeft: CGColor     // x=66
    public let listHeaderFrameBottomAndRight: CGColor // x=68
    public let listHeaderFramePressed: CGColor  // x=70
    public let listHeaderDeadArea: CGColor      // x=72
    public let scrollbarOne: CGColor            // x=74
    public let scrollbarTwo: CGColor            // x=76
    public let pressedScrollbarOne: CGColor     // x=78
    public let pressedScrollbarTwo: CGColor     // x=80
    public let scrollbarDeadArea: CGColor       // x=82
    public let listTextHighlighted: CGColor     // x=84
    public let listTextHighlightedBackground: CGColor // x=86
    public let listTextSelected: CGColor        // x=88
    public let listTextSelectedBackground: CGColor    // x=90

    public init(
        itemBackground: CGColor,
        itemForeground: CGColor,
        windowBackground: CGColor,
        buttonText: CGColor,
        windowText: CGColor,
        divider: CGColor,
        playlistSelection: CGColor,
        listHeaderBackground: CGColor,
        listHeaderText: CGColor,
        listHeaderFrameTopAndLeft: CGColor,
        listHeaderFrameBottomAndRight: CGColor,
        listHeaderFramePressed: CGColor,
        listHeaderDeadArea: CGColor,
        scrollbarOne: CGColor,
        scrollbarTwo: CGColor,
        pressedScrollbarOne: CGColor,
        pressedScrollbarTwo: CGColor,
        scrollbarDeadArea: CGColor,
        listTextHighlighted: CGColor,
        listTextHighlightedBackground: CGColor,
        listTextSelected: CGColor,
        listTextSelectedBackground: CGColor
    ) {
        self.itemBackground = itemBackground
        self.itemForeground = itemForeground
        self.windowBackground = windowBackground
        self.buttonText = buttonText
        self.windowText = windowText
        self.divider = divider
        self.playlistSelection = playlistSelection
        self.listHeaderBackground = listHeaderBackground
        self.listHeaderText = listHeaderText
        self.listHeaderFrameTopAndLeft = listHeaderFrameTopAndLeft
        self.listHeaderFrameBottomAndRight = listHeaderFrameBottomAndRight
        self.listHeaderFramePressed = listHeaderFramePressed
        self.listHeaderDeadArea = listHeaderDeadArea
        self.scrollbarOne = scrollbarOne
        self.scrollbarTwo = scrollbarTwo
        self.pressedScrollbarOne = pressedScrollbarOne
        self.pressedScrollbarTwo = pressedScrollbarTwo
        self.scrollbarDeadArea = scrollbarDeadArea
        self.listTextHighlighted = listTextHighlighted
        self.listTextHighlightedBackground = listTextHighlightedBackground
        self.listTextSelected = listTextSelected
        self.listTextSelectedBackground = listTextSelectedBackground
    }

    /// The x-coordinates for each color property, in order.
    /// Used by the extraction method to sample pixels from GENEX.BMP y=0 row.
    static let xCoordinates: [Int] = [
        48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68,
        70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90,
    ]

    /// Extract colors from a GENEX.BMP image by sampling y=0 pixels.
    public static func extract(from image: CGImage) throws -> GenExColors {
        let colors = try xCoordinates.map { x in
            try BMPLoader.readPixelColor(from: image, x: x, y: 0)
        }
        return GenExColors(
            itemBackground: colors[0],
            itemForeground: colors[1],
            windowBackground: colors[2],
            buttonText: colors[3],
            windowText: colors[4],
            divider: colors[5],
            playlistSelection: colors[6],
            listHeaderBackground: colors[7],
            listHeaderText: colors[8],
            listHeaderFrameTopAndLeft: colors[9],
            listHeaderFrameBottomAndRight: colors[10],
            listHeaderFramePressed: colors[11],
            listHeaderDeadArea: colors[12],
            scrollbarOne: colors[13],
            scrollbarTwo: colors[14],
            pressedScrollbarOne: colors[15],
            pressedScrollbarTwo: colors[16],
            scrollbarDeadArea: colors[17],
            listTextHighlighted: colors[18],
            listTextHighlightedBackground: colors[19],
            listTextSelected: colors[20],
            listTextSelectedBackground: colors[21]
        )
    }

    /// Default Winamp classic colors (green on black, matching base-2.91.wsz).
    public static let `default` = GenExColors(
        itemBackground: CGColor(gray: 0, alpha: 1),
        itemForeground: CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1),
        windowBackground: CGColor(gray: 0, alpha: 1),
        buttonText: CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1),
        windowText: CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1),
        divider: CGColor(gray: 0.3, alpha: 1),
        playlistSelection: CGColor(srgbRed: 0, green: 0, blue: 0.5, alpha: 1),
        listHeaderBackground: CGColor(gray: 0.3, alpha: 1),
        listHeaderText: CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1),
        listHeaderFrameTopAndLeft: CGColor(gray: 0.5, alpha: 1),
        listHeaderFrameBottomAndRight: CGColor(gray: 0.2, alpha: 1),
        listHeaderFramePressed: CGColor(gray: 0.4, alpha: 1),
        listHeaderDeadArea: CGColor(gray: 0.3, alpha: 1),
        scrollbarOne: CGColor(gray: 0.3, alpha: 1),
        scrollbarTwo: CGColor(gray: 0.3, alpha: 1),
        pressedScrollbarOne: CGColor(gray: 0.4, alpha: 1),
        pressedScrollbarTwo: CGColor(gray: 0.4, alpha: 1),
        scrollbarDeadArea: CGColor(gray: 0.2, alpha: 1),
        listTextHighlighted: CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1),
        listTextHighlightedBackground: CGColor(srgbRed: 0, green: 0, blue: 0.5, alpha: 1),
        listTextSelected: CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1),
        listTextSelectedBackground: CGColor(srgbRed: 0, green: 0, blue: 0.5, alpha: 1)
    )
}
