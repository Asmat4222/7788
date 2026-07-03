/// App-wide constants: names, routes, breakpoints and copy.
class AppConstants {
  AppConstants._();

  static const String appName = 'GrowVault';
  static const String tagline = 'Grow a Garden Calculator Suite';
  static const String appVersion = '1.0.0';

  // Responsive breakpoints (logical pixels).
  static const double mobileBreakpoint = 640;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static const double maxContentWidth = 1180;
}

/// Named route paths used by GoRouter.
class Routes {
  Routes._();

  static const String home = '/';
  static const String calculator = '/calculator';
  static const String mutations = '/mutations';
  static const String database = '/database';
  static const String pet = '/pet';
  static const String guide = '/guide';
  static const String about = '/about';
}
