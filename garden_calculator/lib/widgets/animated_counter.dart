import 'package:flutter/material.dart';

import '../core/utils/formatters.dart';

/// Smoothly tweens between numeric values — used for the big result figure so
/// changes feel alive rather than snapping.
class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    required this.style,
    this.prefix = '',
    this.compact = false,
    this.duration = const Duration(milliseconds: 550),
  });

  final double value;
  final TextStyle style;
  final String prefix;
  final bool compact;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) {
        final text =
            compact ? Formatters.compact(v) : Formatters.sheckles(v);
        return Text('$prefix$text', style: style);
      },
    );
  }
}
