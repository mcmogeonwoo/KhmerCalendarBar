import SwiftUI

struct AddReminderView: View {
    let dayInfo: DayInfo
    let onSave: (Reminder) -> Void
    let onCancel: () -> Void

    @State private var title: String = ""
    @State private var hour: Int = AppSettings.shared.defaultReminderHour
    @State private var minute: Int = AppSettings.shared.defaultReminderMinute
    @Environment(\.calendarTheme) private var theme

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onCancel) {
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

                Text("កំណត់រំលឹក")
                    .font(.system(size: 13, weight: .semibold))

                Spacer()

                Color.clear.frame(width: 60, height: 1)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 10)

            Divider()
                .padding(.horizontal, 8)

            ScrollView {
                VStack(spacing: 14) {
                    // Date info
                    VStack(spacing: 4) {
                        Text(dayInfo.khmerDate.formattedFull)
                            .font(.system(size: 12, weight: .semibold))
                        Text(formattedGregorian)
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.accent.opacity(0.05))
                    )

                    // Title field
                    VStack(alignment: .leading, spacing: 5) {
                        Text("ចំណងជើង")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.secondary)

                        TextField("បញ្ចូលចំណងជើង...", text: $title)
                            .textFieldStyle(.plain)
                            .font(.system(size: 12))
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(theme.cardBorder, lineWidth: 0.5)
                            )
                    }

                    // Time picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("ម៉ោងរំលឹក")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.secondary)

                        HStack(spacing: 4) {
                            Picker("", selection: $hour) {
                                ForEach(0..<24, id: \.self) { h in
                                    Text(String(format: "%02d", h)).tag(h)
                                }
                            }
                            .labelsHidden()
                            .frame(width: 60)

                            Text(":")
                                .font(.system(size: 12, weight: .medium))

                            Picker("", selection: $minute) {
                                ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { m in
                                    Text(String(format: "%02d", m)).tag(m)
                                }
                            }
                            .labelsHidden()
                            .frame(width: 60)

                            Spacer()
                        }
                    }

                    // Save button
                    Button {
                        let reminder = Reminder(
                            id: UUID(),
                            title: title.isEmpty ? dayInfo.khmerDate.formattedFull : title,
                            gregorianDate: dayInfo.gregorianDate,
                            khmerDateDescription: dayInfo.khmerDate.formattedFull,
                            notificationHour: hour,
                            notificationMinute: minute,
                            isEnabled: true
                        )
                        onSave(reminder)
                    } label: {
                        Text("រក្សាទុក")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(theme.accent)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
            }
        }
    }

    private var formattedGregorian: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .long
        return fmt.string(from: dayInfo.gregorianDate)
    }
}
