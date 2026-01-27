import SwiftUI

@main
struct KhmerCalendarBarApp: App {
    @StateObject private var viewModel = CalendarViewModel()

    init() {
        NSApp.appearance = NSAppearance(named: .darkAqua)
    }

    var body: some Scene {
        MenuBarExtra {
            PopoverContentView(viewModel: viewModel)
                .frame(width: 340)
        } label: {
            Text(viewModel.menuBarText)
        }
        .menuBarExtraStyle(.window)
    }
}
