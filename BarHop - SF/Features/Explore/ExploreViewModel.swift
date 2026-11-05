import Foundation
import Observation

@MainActor
@Observable
final class ExploreViewModel {
    var query = ""
    var neighborhood: Neighborhood?
    private(set) var bars: [Bar] = []
    private(set) var favorites: Set<String>
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var toast: String?
    private let barRepository: any BarRepository
    private let favoritesRepository: any FavoritesRepository

    init(barRepository: any BarRepository, favoritesRepository: any FavoritesRepository) {
        self.barRepository = barRepository
        self.favoritesRepository = favoritesRepository
        favorites = favoritesRepository.load()
    }

    var filteredBars: [Bar] { VenueFilter.apply(to: bars, query: query, neighborhood: neighborhood) }
    var featuredBars: [Bar] { filteredBars.filter(\.isFeatured) }
    var recommendedBars: [Bar] { Array(filteredBars.filter { !$0.isFeatured }.prefix(3)) }
    var savedBars: [Bar] { bars.filter { favorites.contains($0.id) } }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            bars = try await barRepository.fetchBars()
        } catch is CancellationError {
            return
        } catch {
            errorMessage = "We couldn’t load the venues. Please try again."
        }
    }

    func toggleFavorite(_ bar: Bar) {
        if favorites.contains(bar.id) {
            favorites.remove(bar.id)
            toast = "Removed from saved bars"
        } else {
            favorites.insert(bar.id)
            toast = "Saved for your next night out"
        }
        favoritesRepository.save(favorites)
    }

    func clearToast() { toast = nil }

    func resetFilters() {
        query = ""
        neighborhood = nil
    }
}
