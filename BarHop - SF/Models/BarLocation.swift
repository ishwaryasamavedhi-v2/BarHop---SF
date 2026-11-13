import Foundation
import CoreLocation

struct BarLocation: Hashable, Sendable {
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

/// Approximate discovery pins; not surveyed entrances or live business data.
enum SampleBarLocations {
    static let all: [String: BarLocation] = [
        "balboa": .init(latitude: 37.7980, longitude: -122.4359),
        "vesuvio": .init(latitude: 37.7975, longitude: -122.4066),
        "trickdog": .init(latitude: 37.7602, longitude: -122.4113),
        "monaghan": .init(latitude: 37.8002, longitude: -122.4382),
        "tonyniks": .init(latitude: 37.8003, longitude: -122.4090),
        "comstock": .init(latitude: 37.7969, longitude: -122.4054),
        "elixir": .init(latitude: 37.7640, longitude: -122.4226),
        "abv": .init(latitude: 37.7648, longitude: -122.4239),
        "novela": .init(latitude: 37.7872, longitude: -122.4004),
        "tempest": .init(latitude: 37.7817, longitude: -122.4074),
        "bourbon": .init(latitude: 37.7855, longitude: -122.4129),
        "paganidol": .init(latitude: 37.7904, longitude: -122.4036),
        "brass": .init(latitude: 37.7765, longitude: -122.4246),
        "linden": .init(latitude: 37.7763, longitude: -122.4227)
    ]
}
