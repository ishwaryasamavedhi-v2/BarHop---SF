import SwiftUI

struct ContentView: View {
    @State private var model = ExploreViewModel(
        barRepository: MockBarRepository(),
        favoritesRepository: LocalFavoritesRepository()
    )

    var body: some View {
        MainTabView(model: model)
            .preferredColorScheme(.dark)
    }
}

#Preview("Bar Hop · Explore") {
    ContentView()
}

#Preview("Bar Hop · Larger text") {
    ContentView()
        .environment(\.dynamicTypeSize, .accessibility1)
}
