import Foundation

enum Neighborhood: String, CaseIterable, Identifiable, Codable, Sendable {
    case marina = "Marina"
    case northBeach = "North Beach"
    case mission = "Mission"
    case soma = "SoMa"
    case downtown = "Downtown"
    case hayesValley = "Hayes Valley"
    var id: String { rawValue }
}

enum VenueCategory: String, Codable, Sendable {
    case cocktailBar = "Cocktail bar"
    case neighborhoodBar = "Neighborhood bar"
    case lounge = "Lounge"
    case musicClub = "Music club"
}

struct BarImage: Identifiable, Hashable, Sendable {
    let id: String
    let url: URL?
    let accessibilityDescription: String
}

struct Bar: Identifiable, Hashable, Sendable {
    // Stable seed identifiers also act as repository keys.
    let id: String
    let name: String
    let neighborhood: Neighborhood
    let category: VenueCategory
    let description: String
    let priceCents: Int
    let mood: String
    let artworkVariant: Int
    let isFeatured: Bool
    let image: BarImage?

    var formattedPrice: String {
        (Decimal(priceCents) / 100).formatted(.currency(code: "USD").precision(.fractionLength(0)))
    }
}

enum VenueFilter {
    static func apply(to bars: [Bar], query: String, neighborhood: Neighborhood?) -> [Bar] {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return bars.filter { bar in
            (neighborhood == nil || bar.neighborhood == neighborhood) &&
            (term.isEmpty || [bar.name, bar.neighborhood.rawValue, bar.category.rawValue]
                .contains { $0.localizedStandardContains(term) })
        }
    }
}
