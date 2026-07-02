import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';

/// Constrains page content to a comfortable reading width and applies
/// responsive padding. Every screen wraps its body in this.
class PageContainer extends StatelessWidget {
  const PageContainer({
    super.key,
    required this.child,
    this.maxWidth = AppConstants.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width < 640 ? 16.0 : (width < 1024 ? 28.0 : 40.0);
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 48),
            child: child,
          ),
        ),
      ),
    );
  }
}
