import SwiftUI

enum AppTab: Hashable {
    case explore, saved, passes, profile
}

struct MainTabView: View {
    let model: ExploreViewModel
    @State private var selectedTab: AppTab = .explore

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ExploreView(model: model) { selectedTab = .profile }
                    .navigationDestination(for: Bar.self) { bar in VenuePreviewView(bar: bar, model: model) }
            }
            .tabItem { Label("Explore", systemImage: "safari") }.tag(AppTab.explore)

            NavigationStack {
                SavedDiscoveryView(model: model) { selectedTab = .explore }
                    .navigationDestination(for: Bar.self) { bar in VenuePreviewView(bar: bar, model: model) }
            }
            .tabItem { Label("Saved", systemImage: "heart") }.tag(AppTab.saved)

            NavigationStack {
                DiscoveryEmptyState(title: "Good nights ahead", message: "Your entry passes will live here. Demo checkout is coming in Phase 4.",
                                    symbol: "ticket", actionTitle: "Explore bars") { selectedTab = .explore }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BH.background)
                    .navigationTitle("My passes")
            }
            .tabItem { Label("Passes", systemImage: "ticket") }.tag(AppTab.passes)

            NavigationStack {
                DemoProfileView { selectedTab = $0 }
            }
            .tabItem { Label("Profile", systemImage: "person.crop.circle") }.tag(AppTab.profile)
        }
        .tint(BH.text)
        .foregroundStyle(BH.text)
        .toolbarBackground(BH.secondaryBackground, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .overlay(alignment: .top) {
            if let toast = model.toast {
                Text(toast)
                    .font(.subheadline.weight(.medium))
                    .padding(16)
                    .background(BH.espresso, in: Capsule())
                    .overlay(Capsule().stroke(BH.border))
                    .padding(.top, 8)
                    .allowsHitTesting(false)
                    .task(id: toast) {
                        do {
                            try await Task.sleep(for: .seconds(2))
                            model.clearToast()
                        } catch { }
                    }
            }
        }
        .task { if model.bars.isEmpty { await model.load() } }
    }
}

private struct SavedDiscoveryView: View {
    let model: ExploreViewModel
    let explore: () -> Void

    var body: some View {
        ScrollView {
            if model.savedBars.isEmpty {
                DiscoveryEmptyState(title: "Keep a good night in mind",
                                    message: "Tap a heart to build your shortlist. Your saved spots will be waiting here.",
                                    symbol: "heart", actionTitle: "Explore bars", action: explore)
                    .padding(.top, 60)
            } else {
                VenueListSection(title: "Your shortlist", subtitle: "Great nights, kept close.",
                                 bars: model.savedBars, model: model).padding(.vertical, 24)
            }
        }
        .background(BH.background)
        .navigationTitle("Saved bars")
    }
}

private struct DemoProfileView: View {
    let navigate: (AppTab) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle").font(.largeTitle)
                        .frame(width: 72, height: 72).background(BH.espresso, in: Circle())
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Your next great night").font(.title2.bold())
                        Text("Browsing in demo mode").font(.subheadline).foregroundStyle(BH.muted)
                    }
                }
                VStack(spacing: 0) {
                    Button { navigate(.passes) } label: {
                        Label("My passes", systemImage: "ticket").frame(maxWidth: .infinity, alignment: .leading).padding(20)
                    }
                    Divider().overlay(BH.border)
                    Button { navigate(.saved) } label: {
                        Label("Saved bars", systemImage: "heart").frame(maxWidth: .infinity, alignment: .leading).padding(20)
                    }
                }
                .barHopCard()
                VStack(alignment: .leading, spacing: 12) {
                    Label("BAR HOP PLUS", systemImage: "sparkle").font(.caption.weight(.bold)).tracking(2)
                    Text("The night has more in store.").font(.title2.bold())
                    Text("Coming soon").font(.subheadline).foregroundStyle(BH.muted)
                }
                .frame(maxWidth: .infinity, alignment: .leading).padding(24).barHopCard()
                Text("Account creation and sign-in arrive in Phase 2. No account or payment is required to explore this demo.")
                    .font(.subheadline).foregroundStyle(BH.muted)
                DemoDisclosure()
            }
            .padding(24)
        }
        .background(BH.background)
        .navigationTitle("Profile")
    }
}
