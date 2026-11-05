import SwiftUI

/// Original architectural placeholder artwork; never presented as venue photography.
struct VenueArtwork: View {
    let variant: Int
    var image: BarImage?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BH.espresso
                Canvas { context, size in
                    let width = size.width
                    let height = size.height
                    for column in 0..<7 {
                        let x = CGFloat(column) * width / 6 - width / 16
                        let rect = CGRect(x: x, y: -height * 0.2, width: width / 9, height: height * 1.1)
                        context.fill(Path(roundedRect: rect, cornerRadius: width / 18),
                                     with: .color((variant == 1 ? BH.burgundy : BH.muted).opacity(0.16)))
                        let light = CGRect(x: x + width / 24, y: height * 0.2, width: 2, height: height * 0.5)
                        context.fill(Path(light), with: .color(BH.text.opacity(0.20)))
                    }
                    let bar = CGRect(x: 0, y: height * 0.74, width: width, height: height * 0.05)
                    context.fill(Path(bar), with: .color(BH.accent.opacity(0.4)))
                }
                RadialGradient(colors: [BH.accent.opacity(0.28), .clear],
                               center: variant == 2 ? .topTrailing : .topLeading,
                               startRadius: 0, endRadius: geometry.size.width)
                if let image, let url = image.url {
                    AsyncImage(url: url) { phase in
                        if case .success(let photo) = phase {
                            photo.resizable().scaledToFill()
                        }
                    }
                }
                LinearGradient(colors: [.clear, BH.background.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("BAR HOP / SF")
                            .font(.system(.caption2, design: .monospaced))
                            .tracking(3)
                            .foregroundStyle(BH.text.opacity(0.28))
                    }
                }
                .padding(20)
            }
        }
        .clipped()
        .accessibilityHidden(true)
    }
}
