import SwiftUI

/// Adaptive theme for KhmerCalendarBar — follows system light/dark mode
struct CalendarTheme {
    let colorScheme: ColorScheme

    // MARK: - Primary Accent (Teal)
    var accent: Color {
        isDark ? Color(red: 0.18, green: 0.58, blue: 0.58)
               : Color(red: 0.12, green: 0.45, blue: 0.45)
    }
    var accentLight: Color {
        isDark ? Color(red: 0.22, green: 0.68, blue: 0.68)
               : Color(red: 0.15, green: 0.52, blue: 0.52)
    }
    var accentMuted: Color { accent.opacity(isDark ? 0.15 : 0.10) }

    // MARK: - Warm Amber
    var amber: Color {
        isDark ? Color(red: 0.85, green: 0.62, blue: 0.24)
               : Color(red: 0.72, green: 0.50, blue: 0.12)
    }
    var amberMuted: Color { amber.opacity(isDark ? 0.12 : 0.10) }

    // MARK: - Coral (holidays)
    var coral: Color {
        isDark ? Color(red: 0.87, green: 0.38, blue: 0.32)
               : Color(red: 0.78, green: 0.28, blue: 0.22)
    }
    var coralMuted: Color { coral.opacity(isDark ? 0.12 : 0.10) }

    // MARK: - Working day
    var working: Color {
        isDark ? Color(red: 0.22, green: 0.68, blue: 0.56)
               : Color(red: 0.15, green: 0.52, blue: 0.42)
    }
    var workingMuted: Color { working.opacity(isDark ? 0.12 : 0.10) }

    // MARK: - Weekend
    var weekend: Color {
        isDark ? Color(red: 0.42, green: 0.52, blue: 0.78)
               : Color(red: 0.32, green: 0.40, blue: 0.68)
    }
    var weekendMuted: Color { weekend.opacity(isDark ? 0.12 : 0.10) }

    // MARK: - Sunday / Saturday
    var sunday: Color {
        isDark ? Color(red: 0.82, green: 0.30, blue: 0.30)
               : Color(red: 0.72, green: 0.20, blue: 0.20)
    }
    var saturday: Color {
        isDark ? Color(red: 0.42, green: 0.55, blue: 0.82)
               : Color(red: 0.25, green: 0.38, blue: 0.72)
    }

    // MARK: - Surfaces
    var cardBorder: Color { isDark ? Color.white.opacity(0.08) : Color.black.opacity(0.10) }
    var hoverBg: Color { isDark ? Color.white.opacity(0.06) : Color.black.opacity(0.05) }
    var selectedBg: Color { accent.opacity(isDark ? 0.12 : 0.10) }
    var selectedBorder: Color { accent.opacity(isDark ? 0.45 : 0.40) }

    // MARK: - Today cell text
    var todayText: Color { .white }

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
