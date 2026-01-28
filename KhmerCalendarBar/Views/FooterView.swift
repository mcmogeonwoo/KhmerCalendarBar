import SwiftUI

struct FooterView: View {
    @Binding var showSettings: Bool
    @Binding var showClock: Bool
    @State private var isQuitHovered = false
    @State private var isSettingsHovered = false
    @State private var isClockHovered = false
    @Environment(\.calendarTheme) private var theme

    var body: some View {
        HStack {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    showSettings = true
                }
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(isSettingsHovered ? AnyShapeStyle(theme.accent) : AnyShapeStyle(.tertiary))
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                isSettingsHovered = hovering
            }
            .animation(.easeInOut(duration: 0.15), value: isSettingsHovered)
            .help("ការកំណត់")

            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    showClock = true
                }
            } label: {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(isClockHovered ? AnyShapeStyle(theme.accent) : AnyShapeStyle(.tertiary))
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                isClockHovered = hovering
            }
            .animation(.easeInOut(duration: 0.15), value: isClockHovered)
            .help("នាឡិកា (C)")

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(isQuitHovered ? .secondary : .tertiary)
            .onHover { hovering in
                isQuitHovered = hovering
            }
            .animation(.easeInOut(duration: 0.15), value: isQuitHovered)
        }
    }
}
