import SwiftUI

struct SaveBarButton: View {
    let bar: Bar
    let model: ExploreViewModel

    var body: some View {
        Button {
            model.toggleFavorite(bar)
        } label: {
            Image(systemName: model.favorites.contains(bar.id) ? "heart.fill" : "heart")
                .font(.body.weight(.semibold))
                .foregroundStyle(BH.text)
                .frame(width: 44, height: 44)
                .background(BH.background.opacity(0.7), in: Circle())
                .overlay(Circle().stroke(BH.border))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(model.favorites.contains(bar.id) ? "Unsave \(bar.name)" : "Save \(bar.name)")
        .sensoryFeedback(.selection, trigger: model.favorites.contains(bar.id))
    }
}

struct FeaturedVenueCard: View {
    let bar: Bar
    let model: ExploreViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink(value: bar) {
                ZStack(alignment: .bottomLeading) {
                    VenueArtwork(variant: bar.artworkVariant, image: bar.image)
                        .frame(height: 208)
                    VStack(alignment: .leading, spacing: 7) {
                        Text(bar.neighborhood.rawValue).font(BH.TypeStyle.eyebrow).foregroundStyle(BH.text.opacity(0.8))
                        Text(bar.name).font(.system(.title, weight: .bold)).foregroundStyle(BH.text)
                    }
                    .padding(20)
                }
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 16) {
                Text(bar.description).font(.subheadline).foregroundStyle(BH.muted).fixedSize(horizontal: false, vertical: true)
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("DEMO PRIORITY ENTRY").font(.caption2.weight(.semibold)).tracking(1).foregroundStyle(BH.muted)
                        Text("From \(bar.formattedPrice)").font(.headline)
                    }
                    Spacer()
                    NavigationLink(value: bar) {
                        Image(systemName: "arrow.up.right")
                            .font(.headline)
                            .frame(width: 44, height: 44)
                            .background(BH.accent, in: Circle())
                    }
                    .accessibilityLabel("View \(bar.name) details")
                }
            }
            .padding(20)
        }
        .background(BH.card)
        .clipShape(RoundedRectangle(cornerRadius: BH.Radius.card))
        .overlay(alignment: .topTrailing) {
            SaveBarButton(bar: bar, model: model).padding(14)
        }
        .overlay(RoundedRectangle(cornerRadius: BH.Radius.card).stroke(BH.border))
        .shadow(color: BH.shadow, radius: 12, y: 6)
    }
}

struct VenueRow: View {
    let bar: Bar
    let model: ExploreViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            NavigationLink(value: bar) {
                VenueArtwork(variant: bar.artworkVariant, image: bar.image)
                    .frame(width: 78, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: BH.Radius.control))
            }
            .accessibilityLabel("View \(bar.name)")
            NavigationLink(value: bar) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(bar.name).font(.headline).foregroundStyle(BH.text)
                    Text("\(bar.neighborhood.rawValue) · \(bar.category.rawValue)")
                        .font(.caption).foregroundStyle(BH.muted)
                    Text("Demo entry from \(bar.formattedPrice)")
                        .font(.caption.weight(.medium)).foregroundStyle(BH.text)
                    Text("View details ↗").font(.caption).foregroundStyle(BH.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            SaveBarButton(bar: bar, model: model)
        }
        .padding(14)
        .barHopCard()
    }
}

struct DemoDisclosure: View {
    var body: some View {
        Label("Discovery demo · 21+\nVenues are examples, not partners. Prices and availability are illustrative. Artwork is not venue photography.",
              systemImage: "info.circle")
            .font(.caption)
            .foregroundStyle(BH.muted)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct DiscoveryEmptyState: View {
    let title: LocalizedStringResource
    let message: LocalizedStringResource
    let symbol: String
    let actionTitle: LocalizedStringResource
    let action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: symbol).font(.largeTitle).foregroundStyle(BH.muted)
            Text(title).font(.title2.bold())
            Text(message).font(.subheadline).foregroundStyle(BH.muted).multilineTextAlignment(.center)
            Button(action: action) { Text(actionTitle).font(.headline).padding(8) }
                .buttonStyle(.borderedProminent).tint(BH.burgundy)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
    }
}
