import SwiftUI

struct PopoverContentView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.colorScheme) private var colorScheme
    @State private var showSettings = false
    @State private var showClock = false

    private var theme: CalendarTheme { CalendarTheme(colorScheme: colorScheme) }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.showAddReminder, let targetDay = viewModel.reminderTargetDay {
                AddReminderView(
                    dayInfo: targetDay,
                    onSave: { reminder in
                        viewModel.addReminder(reminder)
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            viewModel.showAddReminder = false
                            viewModel.reminderTargetDay = nil
                        }
                    },
                    onCancel: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                            viewModel.showAddReminder = false
                            viewModel.reminderTargetDay = nil
                        }
                    }
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else if showClock {
                ClockView(onBack: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        showClock = false
                    }
                })
                .transition(.move(edge: .trailing).combined(with: .opacity))
            } else if showSettings {
                SettingsView(showSettings: $showSettings, viewModel: viewModel)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                mainContent
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .padding(8)
        .environment(\.calendarTheme, CalendarTheme(colorScheme: colorScheme))
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showSettings)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showClock)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.showAddReminder)
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: viewModel.selectedDayInfo?.id)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.monthKey)
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: viewModel.viewMode)
        .onAppear {
            viewModel.goToToday()
        }
        .onKeyPress(.leftArrow) {
            guard !showSettings && !showClock else { return .ignored }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.navigateMonth(offset: -1)
            }
            return .handled
        }
        .onKeyPress(.rightArrow) {
            guard !showSettings && !showClock else { return .ignored }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.navigateMonth(offset: 1)
            }
            return .handled
        }
        .onKeyPress(characters: CharacterSet(charactersIn: "tT")) { _ in
            guard !showSettings && !showClock else { return .ignored }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                viewModel.goToToday()
                viewModel.selectedDayInfo = nil
            }
            return .handled
        }
        .onKeyPress(.escape) {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                if viewModel.showAddReminder {
                    viewModel.showAddReminder = false
                    viewModel.reminderTargetDay = nil
                } else if showClock {
                    showClock = false
                } else if showSettings {
                    showSettings = false
                } else if viewModel.viewMode == .year {
                    viewModel.viewMode = .month
                } else {
                    viewModel.selectedDayInfo = nil
                }
            }
            return .handled
        }
        .onKeyPress(characters: CharacterSet(charactersIn: "yY")) { _ in
            guard !showSettings && !showClock else { return .ignored }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                viewModel.viewMode = viewModel.viewMode == .month ? .year : .month
            }
            return .handled
        }
        .onKeyPress(characters: CharacterSet(charactersIn: "cC")) { _ in
            guard !showSettings else { return .ignored }
            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                showClock.toggle()
            }
            return .handled
        }
    }

    @ViewBuilder
    private var mainContent: some View {
        // Today Header + View Toggle
        HStack(alignment: .top, spacing: 6) {
            TodayHeaderView(viewModel: viewModel)

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    viewModel.viewMode = viewModel.viewMode == .month ? .year : .month
                }
            } label: {
                Image(systemName: viewModel.viewMode == .month ? "square.grid.3x3" : "calendar")
                    .font(.system(size: 11))
                    .foregroundStyle(theme.accent)
                    .frame(width: 26, height: 26)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(theme.accentMuted)
                    )
            }
            .buttonStyle(ScaleButtonStyle())
            .help(viewModel.viewMode == .month ? "ទិដ្ឋភាពឆ្នាំ (Y)" : "ទិដ្ឋភាពខែ (Y)")
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 10)

        Divider()
            .padding(.horizontal, 8)

        if viewModel.viewMode == .month {
            // Month Navigation
            MonthNavigationView(viewModel: viewModel)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)

            // Calendar Grid
            CalendarGridView(viewModel: viewModel)
                .padding(.horizontal, 8)

            // Selected Day Detail
            if let selected = viewModel.selectedDayInfo {
                SelectedDayDetailView(dayInfo: selected)
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .transition(
                        .asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .scale(scale: 0.95).combined(with: .opacity)
                        )
                    )
            }

            Divider()
                .padding(.horizontal, 8)
                .padding(.top, 8)

            // Holiday List
            HolidayListView(holidays: viewModel.monthHolidays)
                .padding(.horizontal, 8)
                .padding(.top, 8)
                .transition(.scale(scale: 0.95).combined(with: .opacity))
        } else {
            // Year Overview
            YearOverviewView(viewModel: viewModel)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .transition(.scale(scale: 1.05).combined(with: .opacity))
        }

        Divider()
            .padding(.horizontal, 8)
            .padding(.top, 8)

        // Footer
        FooterView(showSettings: $showSettings, showClock: $showClock)
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
    }
}

// MARK: - Selected Day Detail

struct SelectedDayDetailView: View {
    let dayInfo: DayInfo
    @Environment(\.calendarTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Weekday + status
            HStack(spacing: 6) {
                let dowIndex = dayInfo.dayOfWeek - 1
                Text("ថ្ងៃ\(CalendarConstants.weekdayNames[dowIndex])")
                    .font(.system(size: 11, weight: .semibold))

                Spacer()

                if dayInfo.isPublicHoliday {
                    DayStatusPill(text: "ថ្ងៃឈប់សម្រាក", color: theme.coral, bgColor: theme.coralMuted)
                } else if dayInfo.isWeekend {
                    DayStatusPill(text: "ចុងសប្តាហ៍", color: theme.weekend, bgColor: theme.weekendMuted)
                } else {
                    DayStatusPill(text: "ថ្ងៃធ្វើការ", color: theme.working, bgColor: theme.workingMuted)
                }
            }

            Text(dayInfo.khmerDate.formattedFull)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.secondary)

            Text(formattedGregorian)
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)

            if !dayInfo.holidays.isEmpty {
                ForEach(dayInfo.holidays) { holiday in
                    HStack(spacing: 5) {
                        Circle()
                            .fill(holiday.isPublicHoliday ? theme.coral : theme.amber)
                            .frame(width: 5, height: 5)
                        Text(holiday.khmerName)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(holiday.isPublicHoliday ? theme.coral : .primary)
                        if !holiday.englishName.isEmpty {
                            Text("(\(holiday.englishName))")
                                .font(.system(size: 9))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(theme.accent.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(theme.accent.opacity(0.12), lineWidth: 0.5)
        )
    }

    private var formattedGregorian: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .long
        return fmt.string(from: dayInfo.gregorianDate)
    }
}

// MARK: - Day Status Pill

private struct DayStatusPill: View {
    let text: String
    let color: Color
    let bgColor: Color

    var body: some View {
        Text(text)
            .font(.system(size: 9, weight: .medium))
            .foregroundStyle(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Capsule().fill(bgColor))
    }
}

// MARK: - Monthly Summary

struct MonthlySummaryView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Environment(\.calendarTheme) private var theme

    var body: some View {
        HStack(spacing: 8) {
            SummaryBadge(
                icon: "briefcase.fill",
                label: "ថ្ងៃធ្វើការ",
                value: KhmerNumeralService.toKhmer(viewModel.workingDaysCount),
                color: theme.working,
                bgColor: theme.workingMuted
            )

            SummaryBadge(
                icon: "star.fill",
                label: "ថ្ងៃបុណ្យ",
                value: KhmerNumeralService.toKhmer(viewModel.publicHolidayDaysCount),
                color: theme.coral,
                bgColor: theme.coralMuted
            )

            SummaryBadge(
                icon: "sun.max.fill",
                label: "ចុងសប្តាហ៍",
                value: KhmerNumeralService.toKhmer(viewModel.weekendDaysCount),
                color: theme.amber,
                bgColor: theme.amberMuted
            )
        }
    }
}

private struct SummaryBadge: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    let bgColor: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 9))
                    .foregroundStyle(color)
                Text(value)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(color)
                    .contentTransition(.numericText())
            }
            Text(label)
                .font(.system(size: 9))
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(bgColor)
        )
    }
}
