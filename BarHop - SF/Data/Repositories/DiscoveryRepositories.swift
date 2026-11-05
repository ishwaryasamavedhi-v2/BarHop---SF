import Foundation

protocol BarRepository: Sendable {
    func fetchBars() async throws -> [Bar]
}

struct MockBarRepository: BarRepository {
    func fetchBars() async throws -> [Bar] {
        try await Task.sleep(for: .milliseconds(250))
        return SampleBars.all
    }
}

@MainActor
protocol FavoritesRepository {
    func load() -> Set<String>
    func save(_ identifiers: Set<String>)
}

@MainActor
struct LocalFavoritesRepository: FavoritesRepository {
    let defaults: UserDefaults
    private let key = "barhop.demo.favoriteVenueIDs"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> Set<String> {
        Set(defaults.stringArray(forKey: key) ?? [])
    }

    func save(_ identifiers: Set<String>) {
        defaults.set(identifiers.sorted(), forKey: key)
    }
}
