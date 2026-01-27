import SwiftUI

/// Adaptive theme for KhmerCalendarBar — follows system light/dark mode
struct CalendarTheme {
    let colorScheme: ColorScheme

    // MARK: - Primary Accent (Teal)
    var accent: Color { Color(red: 0.18, green: 0.58, blue: 0.58) }
    var accentLight: Color { Color(red: 0.22, green: 0.68, blue: 0.68) }
    var accentMuted: Color { accent.opacity(isDark ? 0.15 : 0.10) }

    // MARK: - Warm Amber
    var amber: Color { Color(red: 0.85, green: 0.62, blue: 0.24) }
    var amberMuted: Color { amber.opacity(isDark ? 0.12 : 0.08) }

    // MARK: - Coral (holidays)
    var coral: Color { Color(red: 0.87, green: 0.38, blue: 0.32) }
    var coralMuted: Color { coral.opacity(isDark ? 0.12 : 0.08) }

    // MARK: - Working day
    var working: Color { Color(red: 0.22, green: 0.68, blue: 0.56) }
    var workingMuted: Color { working.opacity(isDark ? 0.12 : 0.08) }

    // MARK: - Weekend
    var weekend: Color { Color(red: 0.42, green: 0.52, blue: 0.78) }
    var weekendMuted: Color { weekend.opacity(isDark ? 0.12 : 0.08) }

    // MARK: - Sunday / Saturday
    var sunday: Color { Color(red: 0.82, green: 0.30, blue: 0.30) }
    var saturday: Color { Color(red: 0.42, green: 0.55, blue: 0.82) }

    // MARK: - Surfaces
    var cardBorder: Color { isDark ? Color.white.opacity(0.08) : Color.black.opacity(0.08) }
    var hoverBg: Color { isDark ? Color.white.opacity(0.06) : Color.black.opacity(0.04) }
    var selectedBg: Color { accent.opacity(isDark ? 0.12 : 0.10) }
    var selectedBorder: Color { accent.opacity(isDark ? 0.45 : 0.35) }

    // MARK: - Today cell text
    var todayText: Color { isDark ? .white : .white }

    private var isDark: Bool { colorScheme == .dark }
}

// MARK: - Environment Key

private struct CalendarThemeKey: EnvironmentKey {
    static let defaultValue = CalendarTheme(colorScheme: .dark)
}

extension EnvironmentValues {
    var calendarTheme: CalendarTheme {
        get { self[CalendarThemeKey.self] }
        set { self[CalendarThemeKey.self] = newValue }
    }
}
