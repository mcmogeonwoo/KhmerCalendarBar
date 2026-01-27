import SwiftUI

struct YearOverviewView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.calendarTheme) private var theme

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 4)

    var body: some View {
        VStack(spacing: 10) {
            // Year navigation
            HStack {
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        viewModel.displayedYear -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(theme.accent)
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(ScaleButtonStyle())

                Spacer()

                Text(KhmerNumeralService.toKhmer(viewModel.displayedYear))
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())

                Text("(\(String(viewModel.displayedYear)))")
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        viewModel.displayedYear += 1
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(theme.accent)
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(ScaleButtonStyle())
            }

            // 4x3 month grid
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(viewModel.buildYearOverview()) { month in
                    MiniMonthView(data: month, theme: theme, isCurrentMonth: isCurrentDisplayMonth(month.id)) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                            viewModel.displayedMonth = month.id
                            viewModel.viewMode = .month
                            viewModel.navigationDirection = .none
                            viewModel.buildGrid()
                        }
                    }
                }
            }
        }
    }

    private func isCurrentDisplayMonth(_ month: Int) -> Bool {
        let now = Date()
        let currentYear = Calendar.current.component(.year, from: now)
        let currentMonth = Calendar.current.component(.month, from: now)
        return viewModel.displayedYear == currentYear && month == currentMonth
    }
}

// MARK: - Mini Month

private struct MiniMonthView: View {
    let data: CalendarViewModel.MiniMonthData
    let theme: CalendarTheme
    let isCurrentMonth: Bool
    let onTap: () -> Void

    @State private var isHovered = false

    private let dayColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        VStack(spacing: 3) {
            // Month name
            Text(data.name)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(isCurrentMonth ? theme.accent : .secondary)
                .lineLimit(1)

            // Day grid
            LazyVGrid(columns: dayColumns, spacing: 1) {
                // Empty cells before first day
                ForEach(0..<(data.firstWeekday - 1), id: \.self) { _ in
                    Color.clear.frame(height: 11)
                }

                // Day numbers
                ForEach(1...data.totalDays, id: \.self) { day in
                    ZStack {
                        if day == data.todayDay {
                            Circle()
                                .fill(theme.accent)
                                .frame(width: 11, height: 11)
                        }

                        Text("\(day)")
                            .font(.system(size: 7, weight: day == data.todayDay ? .bold : .regular))
                            .foregroundStyle(dayColor(day: day))
                    }
                    .frame(height: 11)
                }
            }
        }
        .padding(.horizontal, 3)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isHovered ? theme.hoverBg : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(isCurrentMonth ? theme.accent.opacity(0.25) : Color.clear, lineWidth: 0.5)
        )
        .onTapGesture(perform: onTap)
        .onHover { hovering in
            isHovered = hovering
        }
    }

    private func dayColor(day: Int) -> Color {
        if day == data.todayDay { return .white }
        if data.holidayDays.contains(day) { return theme.coral }

        // Determine weekday: (firstWeekday - 1 + day - 1) % 7 gives 0=Sun
        let weekdayIndex = (data.firstWeekday - 1 + day - 1) % 7
        if weekdayIndex == 0 { return theme.sunday.opacity(0.7) }
        if weekdayIndex == 6 { return theme.saturday.opacity(0.6) }
        return .primary.opacity(0.6)
    }
}
