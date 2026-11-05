import Foundation

enum SampleBars {
    // Discovery examples only. Copy, pricing and artwork are illustrative, not live venue information.
    static let all: [Bar] = [
        make("balboa", "Balboa Cafe", .marina, .neighborhoodBar, "A classic corner. A new story every night.", 20, "Classic & convivial", 0, true),
        make("vesuvio", "Vesuvio Cafe", .northBeach, .neighborhoodBar, "An intimate evening with a little literary soul.", 15, "Bohemian & intimate", 1, true),
        make("trickdog", "Trick Dog", .mission, .cocktailBar, "For nights that begin with something unexpected.", 25, "Creative cocktails", 2, true),
        make("monaghan", "Monaghan’s", .marina, .neighborhoodBar, "Good company, easy conversation, one more round.", 15, "Relaxed & social", 0),
        make("tonyniks", "Tony Nik’s", .northBeach, .cocktailBar, "Settle into the softer side of the city.", 20, "Low-key elegance", 1),
        make("comstock", "Comstock Saloon", .northBeach, .cocktailBar, "Old San Francisco spirit, with a fresh pour.", 25, "Vintage charm", 2),
        make("elixir", "Elixir", .mission, .cocktailBar, "A neighborhood evening worth lingering over.", 20, "Warm & welcoming", 0),
        make("abv", "ABV", .mission, .cocktailBar, "A spirited stop for your next great night.", 25, "Lively & inventive", 2),
        make("novela", "Novela", .soma, .lounge, "A little drama. A beautifully unhurried evening.", 30, "Moody & polished", 1),
        make("tempest", "The Tempest", .soma, .neighborhoodBar, "An easygoing detour from the everyday.", 15, "Casual & energetic", 0),
        make("bourbon", "Bourbon & Branch", .downtown, .cocktailBar, "Let the city fade into the background.", 35, "Quiet sophistication", 1),
        make("paganidol", "Pagan Idol", .downtown, .lounge, "A change of scenery, without leaving the city.", 30, "Escapist evenings", 2),
        make("brass", "Brass Tacks", .hayesValley, .neighborhoodBar, "Meet in the neighborhood. Stay for the atmosphere.", 20, "Effortlessly social", 0),
        make("linden", "Linden Room", .hayesValley, .cocktailBar, "Small room. All the makings of a memorable night.", 30, "Intimate cocktails", 1)
    ]

    private static func make(_ id: String, _ name: String, _ neighborhood: Neighborhood,
                             _ category: VenueCategory, _ description: String, _ price: Int,
                             _ mood: String, _ variant: Int, _ featured: Bool = false) -> Bar {
        Bar(id: id, name: name, neighborhood: neighborhood, category: category,
            description: description, priceCents: price * 100, mood: mood,
            artworkVariant: variant, isFeatured: featured, image: nil)
    }
}
