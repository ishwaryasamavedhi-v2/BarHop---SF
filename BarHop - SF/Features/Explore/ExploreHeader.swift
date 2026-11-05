import SwiftUI

struct ExploreHeader: View {
    let showProfile: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            HStack {
                VStack(alignment: .leading, spacing: 7) {
                    Text("bar hop").font(.system(.title, weight: .heavy)).tracking(-1.5)
                    Label("San Francisco", systemImage: "location.fill")
                        .font(.caption).foregroundStyle(BH.muted)
                }
                Spacer()
                Button(action: showProfile) {
                    Image(systemName: "person.crop.circle")
                        .font(.title2)
                        .frame(width: 48, height: 48)
                        .background(BH.card, in: Circle())
                        .overlay(Circle().stroke(BH.border))
                }
                .accessibilityLabel("Open profile")
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("GOOD NIGHTS START HERE").font(BH.TypeStyle.eyebrow).tracking(2.5).foregroundStyle(BH.muted)
                Text("Your night.\nYour way.").font(BH.TypeStyle.headline).tracking(-1)
                Text("Less waiting. More nightlife.").font(.subheadline).foregroundStyle(BH.muted)
            }
        }
    }
}

struct ExploreFilters: View {
    @Bindable var model: ExploreViewModel

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundStyle(BH.muted)
                TextField("Find your next favorite spot", text: $model.query)
                    .font(.subheadline)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .accessibilityLabel("Search venues, neighborhoods, or categories")
                if !model.query.isEmpty {
                    Button { model.query = "" } label: {
                        Image(systemName: "xmark.circle.fill").frame(minWidth: 44, minHeight: 44)
                    }
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 16)
            .frame(minHeight: 54)
            .background(BH.secondaryBackground, in: RoundedRectangle(cornerRadius: BH.Radius.control))
            .overlay(RoundedRectangle(cornerRadius: BH.Radius.control).stroke(BH.border))
            .padding(.horizontal, BH.Space.page)

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    NeighborhoodChip(title: "All", selected: model.neighborhood == nil) { model.neighborhood = nil }
                    ForEach(Neighborhood.allCases) { neighborhood in
                        NeighborhoodChip(title: neighborhood.rawValue, selected: model.neighborhood == neighborhood) {
                            model.neighborhood = neighborhood
                        }
                    }
                }
                .padding(.horizontal, BH.Space.page)
            }
            .scrollIndicators(.hidden)
        }
    }
}

private struct NeighborhoodChip: View {
    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title).font(.subheadline.weight(.medium))
                .padding(.horizontal, 18).frame(minHeight: 44)
                .background(selected ? BH.text : BH.secondaryBackground, in: Capsule())
                .foregroundStyle(selected ? BH.background : BH.muted)
                .overlay(Capsule().stroke(selected ? .clear : BH.border))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}
