import Foundation

enum EventKind: String, CaseIterable, Identifiable {
    case djSet = "DJ sets"
    case event = "Events"
    var id: String { rawValue }
}

struct NightlifeEvent: Identifiable, Hashable {
    let id: String
    let title: String
    let performer: String
    let neighborhood: Neighborhood
    let kind: EventKind
    let genre: String
    let schedule: String
    let description: String
    let imageAsset: String
}

enum SampleEvents {
    // Fictional editorial listings, not an announcement of real artists or bookings.
    static let all: [NightlifeEvent] = [
        NightlifeEvent(id: "afterhours", title: "After Hours", performer: "DJ Solstice",
                       neighborhood: .soma, kind: .djSet, genre: "House · Electronic",
                       schedule: "Sample Friday · 9 PM–late",
                       description: "A sample late-night set of warm house and deep electronic cuts.",
                       imageAsset: "NightlifeDJ"),
        NightlifeEvent(id: "vinyl", title: "Vinyl Social", performer: "The Listening Room",
                       neighborhood: .mission, kind: .event, genre: "Soul · Disco",
                       schedule: "Sample Saturday · 7–11 PM",
                       description: "A sample listening party built around records, conversation, and classic soul.",
                       imageAsset: "NightlifeInterior"),
        NightlifeEvent(id: "golden", title: "Golden Hour Sessions", performer: "DJ Coast",
                       neighborhood: .marina, kind: .djSet, genre: "Disco · Funk",
                       schedule: "Sample Saturday · 6–10 PM",
                       description: "A sample sunset soundtrack moving from laid-back grooves into disco.",
                       imageAsset: "NightlifeDJ"),
        NightlifeEvent(id: "cocktail", title: "Cocktail Club", performer: "Bar Hop Sessions",
                       neighborhood: .hayesValley, kind: .event, genre: "Cocktails · Social",
                       schedule: "Sample Sunday · 5–8 PM",
                       description: "A sample social evening for discovering new flavors and meeting good company.",
                       imageAsset: "NightlifeCocktail")
    ]
}
