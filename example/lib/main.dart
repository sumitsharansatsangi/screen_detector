import 'package:example/advanced_features.dart';
import 'package:example/hinge_split.dart';
import 'package:flutter/material.dart';
import 'package:screen_detector/screen_detector.dart';

void main() {
  runApp(const ScreenProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Screen Detector Demo',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    return Scaffold(
      appBar: AppBar(title: Text("Adaptive Demo (${screen.screenType.name})")),
      body: AdaptiveNavigation(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          NavigationDestination(icon: Icon(Icons.info), label: "Info"),
          NavigationDestination(icon: Icon(Icons.science), label: "Advanced"),
        ],
        body: AdaptiveLayout(
          compact: _MobileView(index: index),
          medium: _TabletView(index: index),
          expanded: _DesktopView(index: index),
          large: _LargeView(index: index),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////
// 📱 MOBILE
//////////////////////////////////////////////////////////////

class _MobileView extends StatelessWidget {
  final int index;
  const _MobileView({required this.index});

  @override
  Widget build(BuildContext context) {
    return _Content(title: "📱 Mobile Layout", index: index);
  }
}

//////////////////////////////////////////////////////////////
// 📲 TABLET
//////////////////////////////////////////////////////////////

class _TabletView extends StatelessWidget {
  final int index;
  const _TabletView({required this.index});

  @override
  Widget build(BuildContext context) {
    return _Content(title: "📲 Tablet Layout", index: index);
  }
}

//////////////////////////////////////////////////////////////
// 🖥 DESKTOP
//////////////////////////////////////////////////////////////

class _DesktopView extends StatelessWidget {
  final int index;
  const _DesktopView({required this.index});

  @override
  Widget build(BuildContext context) {
    return _Content(title: "🖥 Desktop Layout", index: index);
  }
}
//////////////////////////////////////////////////////////////
// 📺 LARGE / TV
//////////////////////////////////////////////////////////////

class _LargeView extends StatelessWidget {
  final int index;
  const _LargeView({required this.index});

  @override
  Widget build(BuildContext context) {
    return _Content(title: "📺 Large / TV Layout", index: index);
  }
}

//////////////////////////////////////////////////////////////
// 🔁 SHARED CONTENT
//////////////////////////////////////////////////////////////

class _Content extends StatelessWidget {
  final String title;
  final int index;

  const _Content({required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    if (index == 0) {
      return _CalendarLayout(screen: screen);
    }

    if (index == 1) {
      return _InfoView(screen: screen);
    }

    return const AdvancedFeaturesPage();
  }
}

class _CalendarLayout extends StatelessWidget {
  final ScreenInfo screen;

  const _CalendarLayout({required this.screen});

  @override
  Widget build(BuildContext context) {
    final hinge = FoldableDetector.detect(context);

    // 🔥 1. TRUE FOLDABLE (UNFOLDED)
    if (hinge != null && screen.posture == DevicePosture.unfolded) {
      return HingeSplitLayout(
        left: Container(
          color: Colors.white, // 👈 important
          child: Column(
            children: const [
              _CalendarHeader(),
              Expanded(child: _MonthGrid()),
            ],
          ),
        ),
        right: Container(
          color: Color(0xFFF7F7F7), // 👈 subtle separation
          child: Column(
            children: const [
              _MiniHeader(),
              Expanded(child: _EventPanel()),
            ],
          ),
        ),
      );
    }

    // 📱 2. MOBILE
    if (screen.isMobile) {
      return Column(
        children: const [
          _EventPanel(),
          _CalendarHeader(),
          Expanded(child: _MonthGrid()),
        ],
      );
    }

    // 📲 3. TABLET (3 pane)
    if (screen.isTablet) {
      return Row(
        children: [
          const _Sidebar(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: const [
                _CalendarHeader(),
                _EventPanel(),
                Expanded(child: _MonthGrid()),
              ],
            ),
          ),
          // const SizedBox(width: 280, child: ),
        ],
      );
    }

    // 🖥 4. DESKTOP (3 pane)
    return Row(
      children: [
        const _Sidebar(),
        const VerticalDivider(width: 1),

        Expanded(
          flex: 2,
          child: Column(
            children: const [
              _CalendarHeader(),
              Expanded(child: _MonthGrid()),
            ],
          ),
        ),

        const VerticalDivider(width: 1),

        const SizedBox(width: 320, child: _EventPanel()),
      ],
    );
  }
}

class _MiniHeader extends StatelessWidget {
  const _MiniHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Events",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("📅 Calendar", style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Text("• My Calendars"),
          SizedBox(height: 8),
          Text("• Tasks"),
          SizedBox(height: 8),
          Text("• Reminders"),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // 🧠 VERY IMPORTANT: adapt to pane width
        if (width < 200) {
          // 🔥 Ultra-compact (foldable narrow pane)
          return SizedBox(
            height: 60,
            child: Row(
              children: const [
                SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 18),
              ],
            ),
          );
        }

        if (width < 400) {
          // 📱 Compact
          return SizedBox(
            height: 60,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_left),
                ),
                const Expanded(
                  child: Text("March 2026", overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          );
        }

        // 🖥 Full layout
        return SizedBox(
          height: 60,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
              ),
              const Text(
                "March 2026",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
              ),
              const Spacer(),
              const Icon(Icons.search),
            ],
          ),
        );
      },
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid();

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    // 🎯 Adaptive tuning (this is the right way)
    final padding = screen.adaptivePadding;
    final aspectRatio = screen.isMobile
        ? 1.0
        : screen.isTablet
        ? 1.2
        : 1.4;

    final fontSize = screen.isMobile
        ? 12.0
        : screen.isTablet
        ? 14.0
        : 16.0;

    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // ✅ Always 7 for calendar
        childAspectRatio: aspectRatio,
        crossAxisSpacing: padding * 0.3,
        mainAxisSpacing: padding * 0.3,
      ),
      itemCount: 30,
      itemBuilder: (_, i) {
        final isToday = i == DateTime.now().day - 1;

        return Container(
          decoration: BoxDecoration(
            color: isToday
                ? Theme.of(context).colorScheme.primary.withAlpha(39)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // 📅 Day number
              Positioned(
                top: 6,
                right: 6,
                child: Text(
                  "${i + 1}",
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ),
              ),

              // 📝 Fake event dots (visual polish)
              if (i % 5 == 0)
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EventPanel extends StatelessWidget {
  const _EventPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Events", style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text("• Meeting at 10 AM"),
          Text("• Lunch at 1 PM"),
        ],
      ),
    );
  }
}

class _InfoView extends StatelessWidget {
  final ScreenInfo screen;

  const _InfoView({required this.screen});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Platform: ${screen.platform.name}\n"
        "Device Type: ${screen.deviceType.name}\n"
        "Category: ${screen.category.name}\n"
        "Screen Type: ${screen.screenType.name}\n"
        "Posture: ${screen.posture.name}\n"
        "Orientation: ${screen.orientation.name}\n"
        "Input Type: ${screen.inputType.name}\n"
        "Is Hybrid Input: ${screen.isHybridInput}\n"
        "Supports Touch: ${screen.supportsTouch}\n"
        "Supports Mouse/Keyboard: ${screen.supportsMouseKeyboard}\n"
        "Resolution: ${screen.width.toInt()} x ${screen.height.toInt()}\n"
        "Aspect Ratio: ${screen.aspectRatio.toStringAsFixed(2)}\n"
        "Aspect Type: ${screen.aspectType.name}\n"
        "Pixel Ratio: ${screen.devicePixelRatio.toStringAsFixed(1)}\n"
        "Density: ${screen.densityType.name}\n"
        "Is Mobile: ${screen.isMobile}\n"
        "Is Tablet: ${screen.isTablet}\n"
        "Is Desktop: ${screen.isDesktop}\n"
        "Is Watch: ${screen.isWatch}\n"
        "Is TV: ${screen.isTV}\n"
        "Is Foldable: ${screen.isFoldable}\n"
        "Is Wearable: ${screen.isWearable}\n"
        "Is Wide: ${screen.isWide}\n"
        "Is Tiny Screen: ${screen.isTinyScreen}\n"
        "Is Minimal UI: ${screen.isMinimalUI}\n"
        "Adaptive Padding: ${screen.adaptivePadding}\n"
        "Adaptive Icon Size: ${screen.adaptiveIconSize}\n"
        "Adaptive Button Height: ${screen.adaptiveButtonHeight}",
        textAlign: TextAlign.center,
      ),
    );
  }
}
