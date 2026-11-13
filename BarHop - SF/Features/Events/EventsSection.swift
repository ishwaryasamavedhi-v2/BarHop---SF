import SwiftUI

struct EventsSection: View {
    let neighborhood: Neighborhood?
    @State private var kind: EventKind?
    @State private var selectedEvent: NightlifeEvent?

    private var events: [NightlifeEvent] {
        SampleEvents.all.filter {
            (neighborhood == nil || $0.neighborhood == neighborhood) &&
            (kind == nil || $0.kind == kind)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("DJs & events").font(BH.TypeStyle.section)
                    Spacer()
                    Text("DEMO").font(.caption2.bold()).tracking(1).foregroundStyle(BH.orange)
                }
                Text("Sets, sessions, and a reason to go out.")
                    .font(.caption).foregroundStyle(BH.muted)
                Picker("Event category", selection: $kind) {
                    Text("All").tag(Optional<EventKind>.none)
                    ForEach(EventKind.allCases) { kind in
                        Text(kind.rawValue).tag(Optional(kind))
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 8)
            }
            .padding(.horizontal, BH.Space.page)
            if events.isEmpty {
                Text("No sample events in this neighborhood. Choose All above to explore more.")
                    .font(.subheadline).foregroundStyle(BH.muted)
                    .padding(.horizontal, BH.Space.page)
            } else {
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 16) {
                        ForEach(events) { event in
                            Button { selectedEvent = event } label: {
                                EventCard(event: event)
                                    .containerRelativeFrame(.horizontal) { width, _ in min(width - 70, 360) }
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Opens sample event details")
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, BH.Space.page)
                }
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
            }
        }
        .sheet(item: $selectedEvent) { event in
            EventDetailView(event: event)
                .preferredColorScheme(.dark)
        }
    }
}

private struct EventCard: View {
    let event: NightlifeEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            EventPhoto(asset: event.imageAsset).frame(height: 170)
                .overlay(alignment: .topLeading) {
                    Text(event.kind == .djSet ? "DJ SET" : "EVENT")
                        .font(.caption2.bold()).tracking(1)
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(BH.background.opacity(0.85), in: Capsule())
                        .padding(12)
                }
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title).font(.title3.bold())
                Text(event.performer).font(.subheadline).foregroundStyle(BH.orange)
                Text("\(event.neighborhood.rawValue) · \(event.genre)").font(.caption).foregroundStyle(BH.muted)
                HStack(alignment: .firstTextBaseline) {
                    Text(event.schedule).font(.caption)
                    Spacer()
                    Image(systemName: "arrow.up.right").font(.caption)
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 18)
        }
        .foregroundStyle(BH.text)
        .background(BH.card)
        .clipShape(RoundedRectangle(cornerRadius: BH.Radius.card))
        .overlay(RoundedRectangle(cornerRadius: BH.Radius.card).stroke(BH.border))
    }
}

private struct EventPhoto: View {
    let asset: String

    var body: some View {
        GeometryReader { geometry in
            Image(asset)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .overlay(LinearGradient(colors: [.clear, .black.opacity(0.35)], startPoint: .center, endPoint: .bottom))
        }
        .accessibilityHidden(true)
    }
}

private struct EventDetailView: View {
    let event: NightlifeEvent
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    EventPhoto(asset: event.imageAsset)
                        .frame(height: 260)
                        .clipShape(RoundedRectangle(cornerRadius: BH.Radius.card))
                    Text("SAMPLE EVENT").font(.caption.bold()).tracking(2).foregroundStyle(BH.orange)
                    Text(event.title).font(BH.TypeStyle.headline)
                    Text(event.performer).font(.title2).foregroundStyle(BH.orange)
                    Label(event.schedule, systemImage: "calendar")
                    Label(event.neighborhood.rawValue, systemImage: "mappin.and.ellipse")
                    Label(event.genre, systemImage: "music.note")
                    Text(event.description).foregroundStyle(BH.muted)
                    Text("This event and performer are fictional demo content. Photos are illustrative. No tickets, confirmed venue, or reservations are available.")
                        .font(.footnote).foregroundStyle(BH.muted)
                        .padding(20).barHopCard()
                }
                .padding(24)
            }
            .background(BH.background)
            .foregroundStyle(BH.text)
            .navigationTitle("Event details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
            .tint(BH.text)
        }
    }
}
