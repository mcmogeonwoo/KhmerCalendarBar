import SwiftUI

struct ClockView: View {
    let onBack: () -> Void
    @Environment(\.calendarTheme) private var theme
    @State private var currentTime = Date()

    private let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11, weight: .medium))
                        Text("ថយក្រោយ")
                            .font(.system(size: 11))
                    }
                    .foregroundStyle(theme.accent)
                }
                .buttonStyle(ScaleButtonStyle())

                Spacer()

                Text("នាឡិកា")
                    .font(.system(size: 13, weight: .semibold))

                Spacer()

                Color.clear.frame(width: 60, height: 1)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)

            Divider()
                .padding(.horizontal, 8)

            VStack(spacing: 16) {
                Spacer().frame(height: 12)

                // Large Khmer time
                Text(khmerTimeString)
                    .font(.system(size: 42, weight: .light, design: .rounded))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: khmerTimeString)

                // Gregorian time
                Text(gregorianTimeString)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(.tertiary)

                // Khmer period
                Text(khmerPeriod)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(theme.accent)

                Spacer().frame(height: 4)

                Divider()
                    .padding(.horizontal, 20)

                // Date section
                VStack(spacing: 6) {
                    Text(khmerDateString)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.primary)

                    Text(gregorianDateString)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }

                Spacer().frame(height: 4)

                // Info card
                HStack(spacing: 16) {
                    InfoItem(
                        label: "ពុទ្ធសករាជ",
                        value: KhmerNumeralService.toKhmer(buddhistYear),
                        color: theme.accent
                    )

                    Rectangle()
                        .fill(theme.cardBorder)
                        .frame(width: 0.5, height: 28)

                    InfoItem(
                        label: khmerPeriodLabel,
                        value: khmerPeriod,
                        color: theme.amber
                    )
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(theme.cardBorder, lineWidth: 0.5)
                )

                Spacer().frame(height: 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    // MARK: - Computed Properties

    private var calendar: Calendar { Calendar.current }

    private var hour: Int { calendar.component(.hour, from: currentTime) }
    private var minute: Int { calendar.component(.minute, from: currentTime) }
    private var second: Int { calendar.component(.second, from: currentTime) }

    private var khmerTimeString: String {
        "\(padKhmer(hour)):\(padKhmer(minute)):\(padKhmer(second))"
    }

    private var gregorianTimeString: String {
        String(format: "%02d:%02d:%02d", hour, minute, second)
    }

    private var khmerPeriod: String {
        if hour < 6 { return "ព្រលឹម" }       // Dawn
        if hour < 12 { return "ព្រឹក" }       // Morning
        if hour < 13 { return "ថ្ងៃត្រង់" }    // Noon
        if hour < 18 { return "រសៀល" }       // Afternoon
        return "យប់"                          // Night
    }

    private var khmerPeriodLabel: String {
        if hour < 12 { return "ព្រឹក / ល្ងាច" }
        return "ព្រឹក / ល្ងាច"
    }

    private var buddhistYear: Int {
        calendar.component(.year, from: currentTime) + 543
    }

    private var khmerDateString: String {
        let dow = calendar.component(.weekday, from: currentTime) - 1
        let day = calendar.component(.day, from: currentTime)
        let month = calendar.component(.month, from: currentTime)
        let weekday = CalendarConstants.weekdayNames[dow]
        let monthName = CalendarConstants.solarMonthNames[month - 1]
        let year = calendar.component(.year, from: currentTime)
        return "ថ្ងៃ\(weekday) \(KhmerNumeralService.toKhmer(day)) \(monthName) \(KhmerNumeralService.toKhmer(year))"
    }

    private var gregorianDateString: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEEE, MMMM d, yyyy"
        return fmt.string(from: currentTime)
    }

    private func padKhmer(_ n: Int) -> String {
        let padded = String(format: "%02d", n)
        return String(padded.map { char in
            CalendarConstants.khmerNumeralMap[char] ?? char
        })
    }
}

// MARK: - Info Item

private struct InfoItem: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 9))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
    }
}
