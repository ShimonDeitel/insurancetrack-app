import SwiftUI

enum Theme {
    static let accent = Color(red: 0.09,0.32,0.55)
    static let accent2 = Color(red: 0.60,0.65,0.70)
    static let background = Color(red: 0.04,0.06,0.09)

    static let largeTitle = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let headline = Font.system(.headline, design: .rounded)
    static let body = Font.system(.body, design: .default)
    static let caption = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 14
}
