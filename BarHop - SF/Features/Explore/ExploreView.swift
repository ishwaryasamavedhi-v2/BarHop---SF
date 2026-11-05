import SwiftUI

struct ExploreView: View {
    let model: ExploreViewModel
    let showProfile: () -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: BH.Space.section) {
                ExploreHeader(showProfile: showProfile).padding(.horizontal, BH.Space.page)
                ExploreFilters(model: model)
                if model.isLoading && model.bars.isEmpty {
                    DiscoverySkeleton()
                } else if let error = model.errorMessage {
                    DiscoveryEmptyState(title: "A brief intermission", message: LocalizedStringResource(stringLiteral: error),
                                        symbol: "wifi.exclamationmark", actionTitle: "Try again") {
                        Task { await model.load() }
                    }
                } else if model.filteredBars.isEmpty {
                    DiscoveryEmptyState(title: "A different kind of night?", message: "Try another neighborhood or a broader search.",
                                        symbol: "magnifyingglass", actionTitle: "Clear filters") { model.resetFilters() }
                } else {
                    if !model.featuredBars.isEmpty {
                        FeaturedSection(bars: model.featuredBars, model: model)
                    }
                    VenueListSection(title: "Explore bars", subtitle: "\(model.filteredBars.count) places to make a night of it",
                                     bars: model.filteredBars, model: model)
                    if !model.recommendedBars.isEmpty {
                        VenueListSection(title: "A little more your style", subtitle: "Recommended for you · demo picks",
                                         bars: model.recommendedBars, model: model)
                    }
                }
                DemoDisclosure().padding(.horizontal, BH.Space.page)
            }
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(BH.background)
        .scrollDismissesKeyboard(.interactively)
        .refreshable { await model.load() }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct FeaturedSection: View {
    let bars: [Bar]
    let model: ExploreViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Featured tonight").font(BH.TypeStyle.section)
                Spacer()
                Text("THE EDIT").font(.caption2.weight(.semibold)).tracking(1.5).foregroundStyle(BH.muted)
            }
            .padding(.horizontal, BH.Space.page)
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(bars) { bar in
                        FeaturedVenueCard(bar: bar, model: model)
                            .containerRelativeFrame(.horizontal) { width, _ in min(width - 58, 390) }
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, BH.Space.page)
                .padding(.bottom, 12)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
    }
}

struct VenueListSection: View {
    let title: LocalizedStringResource
    let subtitle: String
    let bars: [Bar]
    let model: ExploreViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(BH.TypeStyle.section)
                Text(subtitle).font(.caption).foregroundStyle(BH.muted)
            }
            ForEach(bars) { bar in VenueRow(bar: bar, model: model) }
        }
        .padding(.horizontal, BH.Space.page)
    }
}

private struct DiscoverySkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Finding your next night").font(.title2.bold())
            RoundedRectangle(cornerRadius: BH.Radius.card).fill(BH.card).frame(height: 320)
            ProgressView("Loading venues").tint(BH.text)
        }
        .padding(.horizontal, BH.Space.page)
        .accessibilityLabel("Loading venues")
    }
}
