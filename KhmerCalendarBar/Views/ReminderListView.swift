import SwiftUI

struct ReminderListView: View {
    @Binding var reminders: [Reminder]
    let onDelete: (UUID) -> Void
    let onToggle: (Reminder) -> Void
    @Environment(\.calendarTheme) private var theme

    var body: some View {
        if reminders.isEmpty {
            VStack(spacing: 6) {
                Image(systemName: "bell.slash")
                    .font(.system(size: 16))
                    .foregroundStyle(.quaternary)
                Text("មិនមានការរំលឹកទេ")
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        } else {
            VStack(spacing: 6) {
                ForEach(reminders) { reminder in
                    ReminderRow(
                        reminder: reminder,
                        onDelete: { onDelete(reminder.id) },
                        onToggle: { onToggle(reminder) }
                    )
                }
            }
        }
    }
}

private struct ReminderRow: View {
    let reminder: Reminder
    let onDelete: () -> Void
    let onToggle: () -> Void
    @Environment(\.calendarTheme) private var theme
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(reminder.title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(reminder.isPast ? .tertiary : .primary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(reminder.formattedDate)
                        .font(.system(size: 9))
                        .foregroundStyle(.tertiary)

                    Text(reminder.formattedTime)
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(reminder.isPast ? AnyShapeStyle(.tertiary) : AnyShapeStyle(theme.accent))
                }
            }

            Spacer()

            if !reminder.isPast {
                Toggle("", isOn: Binding(
                    get: { reminder.isEnabled },
                    set: { _ in onToggle() }
                ))
                .toggleStyle(.switch)
                .controlSize(.mini)
                .labelsHidden()
            } else {
                Text("កន្លងហើយ")
                    .font(.system(size: 9))
                    .foregroundStyle(.quaternary)
            }

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 10))
                    .foregroundStyle(isHovered ? AnyShapeStyle(theme.coral) : AnyShapeStyle(.tertiary))
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                isHovered = hovering
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 6)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(reminder.isPast ? Color.clear : theme.accent.opacity(0.03))
        )
    }
}
