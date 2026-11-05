import SwiftUI

/// Phase 1 discovery destination. Inventory and checkout arrive in subsequent phases.
struct VenuePreviewView: View {
    let bar: Bar
    let model: ExploreViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VenueArtwork(variant: bar.artworkVariant, image: bar.image)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: BH.Radius.card))
                VStack(alignment: .leading, spacing: 12) {
                    Text(bar.neighborhood.rawValue).font(.subheadline).foregroundStyle(BH.muted)
                    Text(bar.name).font(BH.TypeStyle.headline)
                    Text(bar.description).font(.title3).foregroundStyle(BH.muted)
                }
                Label(bar.category.rawValue, systemImage: "wineglass")
                Label(bar.mood, systemImage: "sparkles")
                VStack(alignment: .leading, spacing: 12) {
                    Text("A better way into your night.").font(.title2.bold())
                    Text("Illustrative priority entry from \(bar.formattedPrice). Pass selection and demo checkout will be available in a later phase.")
                        .font(.subheadline).foregroundStyle(BH.muted)
                }
                .padding(24).barHopCard()
                DemoDisclosure()
            }
            .padding(BH.Space.page)
        }
        .background(BH.background)
        .navigationTitle(bar.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) { SaveBarButton(bar: bar, model: model) }
        }
    }
}
