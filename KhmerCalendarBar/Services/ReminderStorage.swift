import Foundation

final class ReminderStorage {
    static let shared = ReminderStorage()

    private let key = "customReminders"
    private let defaults = UserDefaults.standard

    private init() {}

    func loadAll() -> [Reminder] {
        guard let data = defaults.data(forKey: key) else { return [] }
        do {
            return try JSONDecoder().decode([Reminder].self, from: data)
        } catch {
            print("[ReminderStorage] Failed to decode reminders: \(error)")
            return []
        }
    }

    func save(_ reminders: [Reminder]) {
        do {
            let data = try JSONEncoder().encode(reminders)
            defaults.set(data, forKey: key)
        } catch {
            print("[ReminderStorage] Failed to encode reminders: \(error)")
        }
    }

    func add(_ reminder: Reminder) {
        var all = loadAll()
        all.append(reminder)
        save(all)
    }

    func remove(id: UUID) {
        var all = loadAll()
        all.removeAll { $0.id == id }
        save(all)
    }

    func update(_ reminder: Reminder) {
        var all = loadAll()
        if let index = all.firstIndex(where: { $0.id == reminder.id }) {
            all[index] = reminder
        }
        save(all)
    }
}
