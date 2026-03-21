import SwiftUI

extension Font {
    // Outfit Light - headlines, buttons, nav
    static func outfitLight(_ size: CGFloat) -> Font {
        .custom("Outfit-Light", size: size)
    }
    // Outfit ExtraLight - dish detail header
    static func outfitExtraLight(_ size: CGFloat) -> Font {
        .custom("Outfit-ExtraLight", size: size)
    }
    // Outfit Regular - coral accent headlines
    static func outfitRegular(_ size: CGFloat) -> Font {
        .custom("Outfit-Regular", size: size)
    }
    // Hanuman Medium - body text, descriptions
    static func hanumanMedium(_ size: CGFloat) -> Font {
        .custom("Hanuman-Medium", size: size)
    }

    // Semantic styles
    static var agPageTitle: Font { outfitLight(18) }
    static var agSectionTitle: Font { outfitLight(24) }
    static var agMenuItemTitle: Font { outfitLight(18) }
    static var agMenuItemDescription: Font { hanumanMedium(14) }
    static var agBody: Font { hanumanMedium(16) }
    static var agButton: Font { outfitLight(14) }
    static var agCoralHeadline: Font { outfitRegular(20) }
    static var agNavItem: Font { outfitLight(18) }
}
