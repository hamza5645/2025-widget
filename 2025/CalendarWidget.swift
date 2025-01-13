import WidgetKit
import SwiftUI

struct CalendarEntry: TimelineEntry {
    let date: Date
    let daysRemaining: Int
}

struct CalendarProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), daysRemaining: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> Void) {
        let entry = CalendarEntry(date: Date(), daysRemaining: calculateDaysRemaining())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> Void) {
        var entries: [CalendarEntry] = []
        
        // Create a timeline entry for the current date
        let currentDate = Date()
        let entry = CalendarEntry(date: currentDate, daysRemaining: calculateDaysRemaining())
        entries.append(entry)

        // Create a timeline with a refresh after 1 hour
        let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(3600)))
        completion(timeline)
    }
    
    private func calculateDaysRemaining() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let year2026Start = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        let daysRemaining = calendar.dateComponents([.day], from: now, to: year2026Start).day ?? 0
        return daysRemaining
    }
}

struct CalendarWidgetEntryView: View {
    var entry: CalendarEntry

    var body: some View {
        VStack {
            Text("Days Remaining")
                .font(.headline)
            Text("\(entry.daysRemaining)")
                .font(.largeTitle)
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
    }
}

struct CalendarWidget: Widget {
    let kind: String = "CalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalendarProvider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Days Remaining in 2025")
        .description("Shows the number of days remaining in the year 2025.")
    }
} 