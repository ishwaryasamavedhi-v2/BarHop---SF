import SwiftUI
import MapKit

struct VenueMapView: View {
    let model: ExploreViewModel
    @State private var savedOnly = false
    @State private var query = ""
    @State private var selectedID: String?
    @State private var camera: MapCameraPosition = .automatic

    private var visibleBars: [Bar] {
        VenueFilter.apply(to: savedOnly ? model.savedBars : model.bars, query: query, neighborhood: nil)
    }

    var body: some View {
        Map(position: $camera, selection: $selectedID) {
            ForEach(visibleBars) { bar in
                Marker(bar.name, systemImage: model.favorites.contains(bar.id) ? "heart.fill" : "wineglass.fill",
                       coordinate: bar.location.coordinate)
                    .tint(model.favorites.contains(bar.id) ? BH.burgundy : BH.orange)
                    .tag(bar.id)
            }
        }
        .mapStyle(.standard(elevation: .flat, pointsOfInterest: .excludingAll))
        .mapControls { MapCompass() }
        .safeAreaInset(edge: .top, spacing: 0) {
            MapFilterHeader(query: $query, savedOnly: $savedOnly, count: visibleBars.count) {
                selectedID = nil
                camera = .automatic
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            MapResultsTray(bars: visibleBars, selectedID: selectedID, savedOnly: savedOnly,
                           isLoading: model.isLoading, errorMessage: model.errorMessage, model: model) {
                query = ""
                savedOnly = false
            }
        }
        .onChange(of: visibleBars.map(\.id)) { _, ids in
            if let selectedID, !ids.contains(selectedID) { self.selectedID = nil }
            camera = ids.isEmpty ? .region(Self.cityRegion) : .automatic
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .background(BH.background)
    }

    private static let cityRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.783, longitude: -122.420),
        span: MKCoordinateSpan(latitudeDelta: 0.065, longitudeDelta: 0.065)
    )
}

private struct MapFilterHeader: View {
    @Binding var query: String
    @Binding var savedOnly: Bool
    let count: Int
    let resetCamera: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Find your spot").font(.title2.bold())
                Spacer()
                Button(action: resetCamera) {
                    Image(systemName: "viewfinder").frame(width: 44, height: 44)
                }
                .accessibilityLabel("Show all filtered bars on map")
            }
            HStack {
                Image(systemName: "magnifyingglass").foregroundStyle(BH.muted)
                TextField("Search bars or neighborhoods", text: $query)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                if !query.isEmpty {
                    Button { query = "" } label: {
                        Image(systemName: "xmark.circle.fill").frame(width: 44, height: 44)
                    }
                    .accessibilityLabel("Clear map search")
                }
            }
            .font(.subheadline)
            .padding(.horizontal, 14)
            .frame(minHeight: 48)
            .background(BH.card, in: RoundedRectangle(cornerRadius: BH.Radius.control))
            Picker("Map filter", selection: $savedOnly) {
                Text("All bars").tag(false)
                Text("Saved").tag(true)
            }
            .pickerStyle(.segmented)
            HStack {
                Text("\(count) bars")
                Spacer()
                Text("Approximate demo locations")
            }
            .font(.caption).foregroundStyle(BH.muted)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(BH.background)
    }
}

private struct MapResultsTray: View {
    let bars: [Bar]
    let selectedID: String?
    let savedOnly: Bool
    let isLoading: Bool
    let errorMessage: String?
    let model: ExploreViewModel
    let clearFilters: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isLoading && bars.isEmpty {
                ProgressView("Loading bars").padding(20)
            } else if let errorMessage {
                Text(errorMessage).font(.subheadline).padding(.horizontal, 20)
                Button("Try again") { Task { await model.load() } }.padding(.horizontal, 20)
            } else if bars.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(savedOnly ? "No saved bars here yet" : "No matching bars").font(.headline)
                    Text("Save a venue with its heart, or try another search.")
                        .font(.caption).foregroundStyle(BH.muted)
                    Button("Show all bars", action: clearFilters).font(.subheadline.bold())
                        .frame(minHeight: 44).tint(BH.orange)
                }
                .padding(.horizontal, 20)
            } else if let selectedID, let bar = bars.first(where: { $0.id == selectedID }) {
                VenueRow(bar: bar, model: model).padding(.horizontal, 16)
            } else {
                Text("Tap a pin or explore the cards below")
                    .font(.caption).foregroundStyle(BH.muted).padding(.horizontal, 20)
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(bars) { bar in
                            VenueRow(bar: bar, model: model)
                                .containerRelativeFrame(.horizontal) { width, _ in min(width - 40, 420) }
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, 16)
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            }
        }
        .padding(.vertical, 12)
        .background(BH.background)
    }
}
