import Foundation

struct Reminder: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var gregorianDate: Date
    var khmerDateDescription: String
    var notificationHour: Int
    var notificationMinute: Int
    var isEnabled: Bool

    var notificationDate: Date? {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: gregorianDate)
        comps.hour = notificationHour
        comps.minute = notificationMinute
        return Calendar.current.date(from: comps)
    }

    var formattedTime: String {
        String(format: "%02d:%02d", notificationHour, notificationMinute)
    }

    var formattedDate: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt.string(from: gregorianDate)
    }

    var isPast: Bool {
        guard let notifDate = notificationDate else { return true }
        return notifDate < Date()
    }
}
