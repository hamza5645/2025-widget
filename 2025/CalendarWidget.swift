import WidgetKit
import SwiftUI

struct CalendarEntry: TimelineEntry {
    let date: Date
    let daysRemaining: Int
    let daysElapsed: Int
}

struct CalendarProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date(), daysRemaining: 0, daysElapsed: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> Void) {
        let entry = CalendarEntry(date: Date(), daysRemaining: calculateDaysRemaining(), daysElapsed: calculateDaysElapsed())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> Void) {
        var entries: [CalendarEntry] = []
        
        // Create a timeline entry for the current date
        let currentDate = Date()
        let entry = CalendarEntry(date: currentDate, daysRemaining: calculateDaysRemaining(), daysElapsed: calculateDaysElapsed())
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
    
    private func calculateDaysElapsed() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let year2025Start = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let year2025End = calendar.date(from: DateComponents(year: 2026, month: 1, day: 1))!
        
        if now < year2025Start {
            return 0
        } else if now >= year2025End {
            return 365
        } else {
            return (calendar.dateComponents([.day], from: year2025Start, to: now).day ?? 0) + 1
        }
    }
}

struct CalendarWidgetEntryView: View {
    var entry: CalendarEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var foregroundColor: Color {
        colorScheme == .dark ? .white : .black
    }

    var body: some View {
        switch family {
        case .systemSmall:
            smallWidget
        case .systemMedium:
            mediumWidget
        case .systemLarge:
            largeWidget
        default:
            largeWidget
        }
    }
    
    // Small widget layout
    private var smallWidget: some View {
        VStack {
            Text("\(entry.daysRemaining)")
                .font(.system(size: 32, weight: .bold))
            Text("days left")
                .font(.caption)
                .foregroundColor(foregroundColor.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(foregroundColor)
        .containerBackground(backgroundColor, for: .widget)
    }
    
    // Medium widget layout
    private var mediumWidget: some View {
        matrixPattern(columns: 22, rows: 8, dotSize: 7.5)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(foregroundColor)
            .containerBackground(backgroundColor, for: .widget)
    }
    
    // Large widget layout
    private var largeWidget: some View {
        VStack(spacing: 20) {
            Text("2025")
                .font(.system(size: 40, weight: .bold))
            
            matrixPattern(columns: 22, rows: 17, dotSize: 7)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(foregroundColor)
        .containerBackground(backgroundColor, for: .widget)
    }
    
    // Reusable matrix pattern with configurable dot size
    private func matrixPattern(columns: Int, rows: Int, dotSize: CGFloat) -> some View {
        VStack(spacing: dotSize - 1) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: dotSize - 1) {
                    ForEach(0..<columns, id: \.self) { column in
                        let index = row * columns + column
                        Circle()
                            .fill(getDotColor(for: index))
                            .frame(width: dotSize, height: dotSize)
                    }
                }
            }
        }
    }
    
    private func getDotColor(for index: Int) -> Color {
        let totalDays = 365
        
        if index >= totalDays {
            return .clear
        }
        
        let baseColor = colorScheme == .dark ? Color.white : Color.black
        
        if index < entry.daysElapsed {
            return baseColor.opacity(1.0)
        } else {
            return baseColor.opacity(0.3)
        }
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge]) // Added .systemLarge
    }
} 