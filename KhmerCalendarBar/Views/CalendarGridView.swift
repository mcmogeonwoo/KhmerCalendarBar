import SwiftUI
import AppKit

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.calendarTheme) private var theme

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 3), count: 7)

    var body: some View {
        VStack(spacing: 4) {
            // Weekday headers
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(Array(CalendarConstants.weekdayNamesShort.enumerated()), id: \.offset) { index, name in
                    Text(name)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(weekdayHeaderColor(index: index))
                        .frame(maxWidth: .infinity)
                }
            }

            Divider()
                .opacity(0.4)

            // Day grid with slide transition
            LazyVGrid(columns: columns, spacing: 3) {
                ForEach(viewModel.gridDays) { dayInfo in
                    DayCellView(
                        dayInfo: dayInfo,
                        isSelected: viewModel.selectedDayInfo?.id == dayInfo.id
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                            if viewModel.selectedDayInfo?.id == dayInfo.id {
                                viewModel.selectedDayInfo = nil
                            } else {
                                viewModel.selectedDayInfo = dayInfo
                            }
                        }
                    }
                    .contextMenu {
                        Button("ចម្លង ថ្ងៃខ្មែរ") {
                            copyToClipboard(dayInfo.khmerDate.formattedFull)
                        }
                        Button("ចម្លង ថ្ងៃសកល") {
                            copyToClipboard(gregorianString(for: dayInfo))
                        }
                        Divider()
                        Button("ចម្លង ព័ត៌មានទាំងអស់") {
                            copyToClipboard(fullInfoString(for: dayInfo))
                        }
                        if !dayInfo.holidays.isEmpty {
                            Divider()
                            ForEach(dayInfo.holidays) { holiday in
                                Button("ចម្លង: \(holiday.khmerName)") {
                                    copyToClipboard(holiday.khmerName)
                                }
                            }
                        }
                        Divider()
                        Button("កំណត់រំលឹក") {
                            viewModel.openAddReminder(for: dayInfo)
                        }
                    }
                }
            }
            .id(viewModel.monthKey)
            .transition(monthTransition)
        }
    }

    private var monthTransition: AnyTransition {
        switch viewModel.navigationDirection {
        case .forward:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .backward:
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        case .none:
            return .opacity
        }
    }

    private func weekdayHeaderColor(index: Int) -> Color {
        if index == 0 { return theme.sunday }
        if index == 6 { return theme.saturday }
        return theme.accent.opacity(0.85)
    }

    private func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    private func gregorianString(for dayInfo: DayInfo) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .long
        return fmt.string(from: dayInfo.gregorianDate)
    }

    private func fullInfoString(for dayInfo: DayInfo) -> String {
        let dowIndex = dayInfo.dayOfWeek - 1
        let weekday = CalendarConstants.weekdayNames[dowIndex]
        var text = "ថ្ងៃ\(weekday)\n"
        text += dayInfo.khmerDate.formattedFull + "\n"
        text += gregorianString(for: dayInfo)
        for holiday in dayInfo.holidays {
            text += "\n\(holiday.khmerName)"
            if !holiday.englishName.isEmpty {
                text += " — \(holiday.englishName)"
            }
        }
        return text
    }
}
