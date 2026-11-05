import SwiftUI

enum BH {
    static let background = Color(hex: 0x0E0C0C)
    static let secondaryBackground = Color(hex: 0x171311)
    static let card = Color(hex: 0x241A18)
    static let espresso = Color(hex: 0x301C19)
    static let burgundy = Color(hex: 0x752824)
    static let accent = Color(hex: 0xB34837)
    static let text = Color(hex: 0xF2E9DF)
    static let muted = Color(hex: 0xA99B95)
    static let border = text.opacity(0.10)

    enum Space {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let page: CGFloat = 24
        static let section: CGFloat = 32
    }
    enum Radius {
        static let control: CGFloat = 14
        static let card: CGFloat = 24
    }
    enum TypeStyle {
        static let headline = Font.system(.largeTitle, design: .default, weight: .bold)
        static let section = Font.system(.title2, weight: .semibold)
        static let eyebrow = Font.system(.caption, weight: .semibold)
    }
    static let shadow = Color.black.opacity(0.22)
}

private extension Color {
    init(hex: UInt32) {
        self.init(.sRGB, red: Double((hex >> 16) & 255) / 255,
                  green: Double((hex >> 8) & 255) / 255,
                  blue: Double(hex & 255) / 255, opacity: 1)
    }
}

extension View {
    func barHopCard() -> some View {
        background(BH.card, in: RoundedRectangle(cornerRadius: BH.Radius.card))
            .overlay(RoundedRectangle(cornerRadius: BH.Radius.card).stroke(BH.border))
    }
}
