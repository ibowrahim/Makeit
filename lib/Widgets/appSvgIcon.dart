import 'package:flutter/material.dart';
import 'package:make_it/gen/assets.gen.dart';

class AppSvgIcon extends StatelessWidget {
  final SvgGenImage icon;
  final double size;

  const AppSvgIcon({super.key, required this.icon, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return icon.svg(width: size, height: size);
  }
}
