import Foundation
import UserNotifications

@MainActor
final class NotificationService {
    static let shared = NotificationService()

    private let center = UNUserNotificationCenter.current()
    private var isAuthorized = false

    private init() {}

    func requestAuthorization() async -> Bool {
        do {
            isAuthorized = try await center.requestAuthorization(options: [.alert, .sound])
            return isAuthorized
        } catch {
            print("[Notification] Authorization failed: \(error)")
            return false
        }
    }

    func scheduleHolidayNotifications(year: Int) async {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }

        // Remove only holiday notifications, not custom reminders
        let pending = await center.pendingNotificationRequests()
        let holidayIds = pending
            .map(\.identifier)
            .filter { $0.hasPrefix("holiday-") }
        center.removePendingNotificationRequests(withIdentifiers: holidayIds)

        let holidays = HolidayService.holidays(forYear: year)
            .filter { $0.isPublicHoliday }

        let cal = Calendar.current
        let now = Date()

        for holiday in holidays {
            guard let holidayDate = holiday.gregorianDate,
                  let notifyDate = cal.date(byAdding: .day, value: -1, to: holidayDate),
                  notifyDate > now else {
                continue
            }

            var comps = cal.dateComponents([.year, .month, .day], from: notifyDate)
            comps.hour = 18
            comps.minute = 0

            let content = UNMutableNotificationContent()
            content.title = "ថ្ងៃបុណ្យស្អែក"
            content.body = "\(holiday.khmerName) — \(holiday.englishName)"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
            let request = UNNotificationRequest(
                identifier: "holiday-\(holiday.id)",
                content: content,
                trigger: trigger
            )

            do {
                try await center.add(request)
            } catch {
                print("[Notification] Failed to schedule \(holiday.englishName): \(error)")
            }
        }
    }

    // MARK: - Custom Reminders

    func scheduleReminderNotification(_ reminder: Reminder) async {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized else { return }

        guard let notifDate = reminder.notificationDate, notifDate > Date() else { return }

        let comps = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: notifDate
        )

        let content = UNMutableNotificationContent()
        content.title = "កំណត់រំលឹក"
        content.body = reminder.title
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(
            identifier: "reminder-\(reminder.id.uuidString)",
            content: content,
            trigger: trigger
        )

        do {
            try await center.add(request)
        } catch {
            print("[Notification] Failed to schedule reminder: \(error)")
        }
    }

    func cancelReminderNotification(id: UUID) {
        center.removePendingNotificationRequests(
            withIdentifiers: ["reminder-\(id.uuidString)"]
        )
    }

    func rescheduleAllReminders(_ reminders: [Reminder]) async {
        // Remove all existing reminder notifications
        let pending = await center.pendingNotificationRequests()
        let reminderIds = pending
            .map(\.identifier)
            .filter { $0.hasPrefix("reminder-") }
        center.removePendingNotificationRequests(withIdentifiers: reminderIds)

        // Re-schedule enabled reminders
        for reminder in reminders where reminder.isEnabled {
            await scheduleReminderNotification(reminder)
        }
    }
}
