import 'package:flutter/material.dart';

class GradientProgressBar extends StatelessWidget {
  final double value;

  const GradientProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(8),
      child: Container(
        height: 10,
        alignment: .centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scheme.primary, scheme.tertiary],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
