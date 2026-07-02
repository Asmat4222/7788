import 'package:flutter/widgets.dart';

import '../constants/app_constants.dart';

enum DeviceType { mobile, tablet, desktop }

/// Small helper for responsive layout decisions.
class Responsive {
  Responsive._();

  static DeviceType of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppConstants.mobileBreakpoint) return DeviceType.mobile;
    if (width < AppConstants.tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < AppConstants.mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= AppConstants.mobileBreakpoint &&
        w < AppConstants.tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= AppConstants.tabletBreakpoint;

  /// Column count for responsive grids.
  static int gridColumns(BuildContext context,
      {int mobile = 1, int tablet = 2, int desktop = 3}) {
    switch (of(context)) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.desktop:
        return desktop;
    }
  }
}
