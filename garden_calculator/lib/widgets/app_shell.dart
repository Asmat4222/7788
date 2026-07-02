import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/theme_controller.dart';
import '../core/utils/responsive.dart';

/// A navigation destination in the shell.
class NavItem {
  const NavItem(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}

const List<NavItem> kNavItems = [
  NavItem('Home', Icons.dashboard_rounded, Routes.home),
  NavItem('Crop Value', Icons.calculate_rounded, Routes.calculator),
  NavItem('Mutations', Icons.auto_awesome_rounded, Routes.mutations),
  NavItem('Crop Database', Icons.grid_view_rounded, Routes.database),
  NavItem('Pet Value', Icons.pets_rounded, Routes.pet),
  NavItem('Guide', Icons.menu_book_rounded, Routes.guide),
  NavItem('About', Icons.info_outline_rounded, Routes.about),
];

/// The persistent app frame: a sidebar on desktop, a drawer + bottom bar on
/// smaller screens. Wraps every routed page.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  int get _selectedIndex {
    // Longest-prefix match so nested routes still highlight their section.
    var best = 0;
    var bestLen = -1;
    for (var i = 0; i < kNavItems.length; i++) {
      final r = kNavItems[i].route;
      final match = r == Routes.home ? location == r : location.startsWith(r);
      if (match && r.length > bestLen) {
        best = i;
        bestLen = r.length;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      drawer: isDesktop ? null : _MobileDrawer(selectedIndex: _selectedIndex),
      appBar: isDesktop
          ? null
          : AppBar(
              title: const _BrandMark(),
              actions: const [_ThemeToggle(), SizedBox(width: 8)],
            ),
      body: Row(
        children: [
          if (isDesktop)
            _Sidebar(selectedIndex: _selectedIndex),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: ref.watch(themeControllerProvider) == ThemeMode.dark
                    ? AppColors.heroGlowDark
                    : AppColors.heroGlowLight,
              ),
              child: child,
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : _MobileBottomBar(
        selectedIndex: _selectedIndex.clamp(0, 3),
      ),
    );
  }
}

class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      width: 268,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        border: Border(
            right: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 26, 22, 8),
            child: _BrandMark(large: true),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                for (var i = 0; i < kNavItems.length; i++)
                  _NavTile(
                    item: kNavItems[i],
                    selected: i == selectedIndex,
                    onTap: () => context.go(kNavItems[i].route),
                  ),
              ],
            ),
          ),
          Divider(color: theme.colorScheme.outline, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Dark mode',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const _ThemeToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile(
      {required this.item, required this.selected, required this.onTap});
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = widget.selected;
    final bg = active
        ? theme.colorScheme.primary.withValues(alpha: 0.14)
        : _hover
            ? theme.colorScheme.onSurface.withValues(alpha: 0.05)
            : Colors.transparent;
    final fg = active
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.78);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(widget.item.icon, size: 20, color: fg),
                const SizedBox(width: 13),
                Text(
                  widget.item.label,
                  style: TextStyle(
                      color: fg,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14.5),
                ),
                const Spacer(),
                if (active)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.large = false});
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 44 : 34,
          height: large ? 44 : 34,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(large ? 14 : 10),
            boxShadow: [
              BoxShadow(
                color: AppColors.emerald.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text('🌱', style: TextStyle(fontSize: large ? 22 : 17)),
          ),
        ),
        const SizedBox(width: 11),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppConstants.appName,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontSize: large ? 20 : 17)),
            if (large)
              Text(
                AppConstants.tagline,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark =
        ref.watch(themeControllerProvider) == ThemeMode.dark;
    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: () => ref.read(themeControllerProvider.notifier).toggle(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, anim) =>
            RotationTransition(turns: anim, child: child),
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          key: ValueKey(isDark),
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 12, 8, 18),
              child: _BrandMark(large: true),
            ),
            for (var i = 0; i < kNavItems.length; i++)
              _NavTile(
                item: kNavItems[i],
                selected: i == selectedIndex,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(kNavItems[i].route);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MobileBottomBar extends StatelessWidget {
  const _MobileBottomBar({required this.selectedIndex});
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Primary four destinations for the bottom bar; the rest live in the drawer.
    const items = [
      NavItem('Home', Icons.dashboard_rounded, Routes.home),
      NavItem('Value', Icons.calculate_rounded, Routes.calculator),
      NavItem('Mutations', Icons.auto_awesome_rounded, Routes.mutations),
      NavItem('Crops', Icons.grid_view_rounded, Routes.database),
    ];
    return NavigationBar(
      backgroundColor: theme.colorScheme.surface,
      selectedIndex: selectedIndex.clamp(0, items.length - 1),
      onDestinationSelected: (i) => context.go(items[i].route),
      destinations: [
        for (final it in items)
          NavigationDestination(icon: Icon(it.icon), label: it.label),
      ],
    );
  }
}
