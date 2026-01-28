# KhmerCalendarBar — Promotional Content

Ready-to-post content for each channel. Copy, tweak, and post.

---

## 1. Reddit Posts

### r/Cambodia

**Title:** I built a free macOS menu bar app for the Khmer Chhankitek calendar

**Body:**

Hi everyone,

I'm a Cambodian developer and I built **KhmerCalendarBar** — a free, open-source macOS app that puts the Khmer lunisolar (Chhankitek) calendar in your menu bar.

**What it does:**
- Khmer date in your menu bar with Khmer numerals and live clock
- All Cambodian public holidays (fixed + lunar-computed)
- Moon phases (waxing/waning) for every day
- Buddhist era, 12-year animal cycle, Sak era
- Working day / holiday / weekend status
- Custom reminders with notifications
- Year overview and month navigation
- Keyboard shortcuts for fast navigation
- Right-click to copy dates in Khmer or English

**Why I built it:** I wanted to quickly check Khmer dates and upcoming holidays without opening a browser. There's no native macOS support for the Chhankitek calendar, so I made one.

**Download (free):** https://khmercalendarbar.rithytep.online
**GitHub:** https://github.com/RithyTep/KhmerCalendarBar

Requires macOS 14.0+. Works on both Apple Silicon and Intel. MIT license.

Would love feedback from the community. If you find bugs or want a feature, open an issue on GitHub!

---

### r/macapps

**Title:** KhmerCalendarBar — Free menu bar app for the Cambodian lunisolar calendar

**Body:**

Built a native SwiftUI menu bar app that shows the Khmer Chhankitek (lunisolar) calendar. Probably niche, but useful if you're Cambodian or interested in Southeast Asian calendars.

**Features:**
- Live Khmer date + time in menu bar with Khmer numerals
- Full month/year calendar grid
- All Cambodian public holidays
- Moon phases, Buddhist era, animal cycle
- Custom reminders with notifications
- Right-click to copy dates
- Keyboard shortcuts (arrows, T, Y, C, Esc)
- Digital clock view with Khmer time
- Multiple menu bar display formats

Built with SwiftUI, no Electron. Lightweight, launches at login, no account needed.

**Download:** https://khmercalendarbar.rithytep.online
**Source:** https://github.com/RithyTep/KhmerCalendarBar

macOS 14.0+ | Apple Silicon + Intel | MIT License | Free

---

### r/swift and r/SwiftUI

**Title:** [Open Source] KhmerCalendarBar — SwiftUI menu bar calendar app for macOS

**Body:**

I built an open-source macOS menu bar app using SwiftUI's `MenuBarExtra` with `.window` style. It displays the Cambodian Chhankitek lunisolar calendar.

**Tech highlights:**
- `MenuBarExtra` with `.window` style for popover
- `@MainActor` ViewModel with `@Published` state
- Timer-based live updates (menu bar + clock view)
- `UNUserNotificationCenter` for holiday + custom reminder notifications
- Custom `EnvironmentKey` for theme propagation
- `@AppStorage` + JSON-encoded `UserDefaults` for persistence
- Khmer numeral conversion engine
- Context menus with `NSPasteboard` clipboard integration
- Spring animations and keyboard event handling

The Chhankitek engine converts between Gregorian and Khmer lunisolar dates including Buddhist era, animal cycles, and lunar phases.

**GitHub:** https://github.com/RithyTep/KhmerCalendarBar

Would love code feedback! MIT licensed, contributions welcome.

---

### r/sideproject

**Title:** I built KhmerCalendarBar — a macOS menu bar app for the Cambodian calendar

**Body:**

**What:** A free macOS menu bar app that shows the Khmer Chhankitek (lunisolar) calendar, public holidays, Buddhist era, and more.

**Why:** There's no macOS support for Cambodia's traditional calendar. I'm Cambodian and wanted it accessible in one click.

**Tech:** SwiftUI, Swift Package Manager, no dependencies. The hardest part was implementing the Chhankitek calendar conversion algorithm — it's a complex lunisolar system.

**Stats:**
- 100% Swift / SwiftUI
- Zero external dependencies
- ~15 source files
- DMG installer with ad-hoc signing

**Link:** https://khmercalendarbar.rithytep.online
**Source:** https://github.com/RithyTep/KhmerCalendarBar

Feedback welcome!

---

## 2. Product Hunt Launch

**Tagline:** The Khmer Chhankitek calendar for your macOS menu bar

**Description:**

KhmerCalendarBar puts the Cambodian Chhankitek lunisolar calendar in your macOS menu bar. See today's Khmer date, upcoming public holidays, moon phases, and Buddhist era — all in one click.

Built for Cambodians abroad, developers, and anyone interested in Southeast Asian culture.

**Key features:**
- Khmer date and live clock with Khmer numerals in your menu bar
- All Cambodian public holidays (2024-2026+)
- Moon phases (waxing/waning) on every day
- Buddhist era, 12-year animal cycle
- Custom date reminders with notifications
- Year overview and month-by-month navigation
- Right-click to copy dates in Khmer or English
- Keyboard shortcuts for power users
- Multiple menu bar display formats
- Native SwiftUI — lightweight, no Electron, no account

Free, open-source (MIT), macOS 14.0+.

**Maker Comment:**

Hi Product Hunt! I'm Rithy, a developer from Cambodia. I built KhmerCalendarBar because there's no native macOS support for the Khmer lunisolar calendar.

The trickiest part was implementing the Chhankitek calendar conversion — it's a lunisolar system that's quite different from the Gregorian calendar. The algorithm accounts for lunar months, intercalary months, and Buddhist era calculations.

I'd love to hear feedback, especially from other Cambodians or anyone familiar with lunisolar calendars. The app is completely free and open source.

---

## 3. Hacker News (Show HN)

**Title:** Show HN: KhmerCalendarBar – macOS menu bar app for the Cambodian lunisolar calendar

**Body:**

I built a native macOS menu bar app for the Khmer Chhankitek lunisolar calendar.

Cambodia uses a lunisolar calendar alongside the Gregorian one. Public holidays, religious ceremonies, and traditional events are determined by the Chhankitek system, which tracks lunar months, waxing/waning phases, and Buddhist era years.

There's no native macOS support for this, so I built one with SwiftUI.

Features: live Khmer date/time in menu bar, all public holidays (fixed + lunar-computed), moon phases, Buddhist era, custom reminders, keyboard shortcuts, year overview.

The conversion algorithm was the interesting part — mapping Gregorian dates to the Chhankitek system with its intercalary months and lunar phase calculations.

Free, open source (MIT), macOS 14.0+.

Website: https://khmercalendarbar.rithytep.online
Source: https://github.com/RithyTep/KhmerCalendarBar

---

## 4. Dev.to Article

**Title:** Building a macOS Menu Bar App for the Khmer Lunisolar Calendar with SwiftUI

**Tags:** swift, swiftui, macos, opensource

**Body:**

I recently built **KhmerCalendarBar**, a macOS menu bar app that displays the Cambodian Chhankitek lunisolar calendar. Here's what I learned.

### Why

Cambodia uses a lunisolar calendar called Chhankitek alongside the Gregorian calendar. Public holidays like Khmer New Year, Pchum Ben, and Water Festival are determined by this system. I wanted quick access to Khmer dates without opening a browser.

### The Stack

- **SwiftUI** with `MenuBarExtra` (.window style)
- **Swift Package Manager** — zero external dependencies
- **`create-dmg`** for styled DMG installers

### Architecture

The app uses a single `CalendarViewModel` (`@MainActor`, `ObservableObject`) that manages all state. Views are composable SwiftUI components:

```
KhmerCalendarBarApp
  └─ MenuBarExtra (popover)
       └─ PopoverContentView
            ├─ TodayHeaderView
            ├─ MonthNavigationView
            ├─ CalendarGridView
            ├─ HolidayListView
            ├─ YearOverviewView
            ├─ ClockView
            ├─ SettingsView
            └─ FooterView
```

### The Hard Part: Chhankitek Conversion

The Khmer lunisolar calendar is complex:
- Months alternate between 29 and 30 days
- Intercalary months (Adhikameas) are added periodically
- The Buddhist era year differs from Gregorian by 543
- Each year has an animal cycle (like Chinese zodiac but different)
- Waxing and waning phases are tracked per day

The conversion engine maps Gregorian dates to Khmer dates including lunar day, month name, era year, and animal cycle.

### Live Menu Bar Updates

The menu bar shows Khmer date + time. Two timers handle updates:
1. **Midnight timer** — recalculates date at day change
2. **Minute timer** — updates time display every 30 seconds

### Key Takeaways

1. `MenuBarExtra` with `.window` style gives you a proper popover
2. `@MainActor` on the ViewModel prevents threading issues
3. Timer-based updates need `[weak self]` to avoid retain cycles
4. `UNUserNotificationCenter` requires explicit authorization on macOS
5. `create-dmg` makes distribution easy without an Apple Developer account

### Try It

- **Website:** https://khmercalendarbar.rithytep.online
- **GitHub:** https://github.com/RithyTep/KhmerCalendarBar
- **License:** MIT

Contributions welcome!

---

## 5. TikTok / YouTube Shorts Script

**Duration:** 30-45 seconds

**Visual:** Screen recording of macOS with KhmerCalendarBar

**Script (voiceover in Khmer or English):**

> "If you use a Mac, you need this app."
>
> [Show menu bar with Khmer date]
> "KhmerCalendarBar shows the Khmer date right in your menu bar — with Khmer numerals and live clock."
>
> [Click to open popover]
> "Click to see the full calendar. Every day shows the Chhankitek lunar date."
>
> [Show holidays highlighted]
> "All Cambodian public holidays are highlighted. See what's coming up."
>
> [Show year view]
> "Press Y for the year overview. Press C for the digital clock."
>
> [Show clock view]
> "Khmer time, Buddhist era, everything in one place."
>
> [Show settings]
> "Choose your menu bar format. Set custom reminders."
>
> [End screen]
> "Free and open source. Link in bio."
> "KhmerCalendarBar dot rithytep dot online"

**Caption:** Free Khmer calendar app for Mac! Chhankitek dates, holidays, Buddhist era, and Khmer numerals in your menu bar. #khmer #cambodia #macos #app #developer #chhankitek #khmercalendar

---

## 6. Sabay / Khmertimes Pitch Email

**Subject:** Cambodian developer builds free Khmer calendar app for macOS

**Body:**

Hi [Editor name],

I'm Rithy Tep, a Cambodian software developer. I recently built and released **KhmerCalendarBar**, a free open-source macOS app that brings the Khmer Chhankitek lunisolar calendar to the Mac menu bar.

The app displays:
- Today's Khmer date with Khmer numerals
- All Cambodian public holidays (including lunar-computed ones like Pchum Ben and Water Festival)
- Buddhist era year and 12-year animal cycle
- Moon phases (waxing/waning)
- A digital clock with Khmer time
- Custom reminder notifications

I built this because there's no native macOS support for the Cambodian calendar, and many Cambodians abroad rely on web-based tools. KhmerCalendarBar gives instant access from the menu bar.

The app is free, requires no account, and is open source under the MIT license. It's built entirely with Swift and SwiftUI.

**Website:** https://khmercalendarbar.rithytep.online
**GitHub:** https://github.com/RithyTep/KhmerCalendarBar

I'd love to share this with your readers. Happy to provide screenshots, a demo video, or answer any questions.

Best regards,
Rithy Tep
GitHub: https://github.com/RithyTep

---

## 7. GitHub Repo Description

**Description:** Khmer Chhankitek lunisolar calendar for macOS menu bar — holidays, Buddhist era, moon phases, Khmer numerals, reminders

**Website:** https://khmercalendarbar.rithytep.online

---

## SEO Tips

1. **Submit sitemap** to Google Search Console: https://search.google.com/search-console
2. **Submit to Bing Webmaster Tools**: https://www.bing.com/webmasters
3. **Backlinks**: Each Reddit/HN/Dev.to post creates a backlink
4. **GitHub README** links to website (already done)
5. **Consistent naming**: Always use "KhmerCalendarBar" and "Chhankitek" for searchability
6. **Khmer language keywords** in meta tags help Cambodian users find it via Google.com.kh
