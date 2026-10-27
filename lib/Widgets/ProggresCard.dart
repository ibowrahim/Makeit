import 'package:flutter/material.dart';
import 'package:make_it/Widgets/GradientProgressBar%20.dart';
import 'package:make_it/Widgets/appSvgIcon.dart';
import 'package:make_it/gen/assets.gen.dart';

class Progresscard extends StatelessWidget {
  final int total;
  final int complate;

  const Progresscard({super.key, required this.total, required this.complate});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final safeCompleted = complate.clamp(0, total);
    final ratio = total == 0 ? 0.0 : safeCompleted / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.surfaceContainer],
        ),
      ),
      child: Column(
        children: [
          _Header(ratio: ratio, total: total, complate: safeCompleted),
          const SizedBox(height: 12),
          GradientProgressBar(value: ratio),
          const SizedBox(height: 10),
          _Floot(complate: safeCompleted, total: total),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double ratio;
  final int total;
  final int complate;

  const _Header({
    required this.ratio,
    required this.total,
    required this.complate,
  });

  String get summary {
    if (total == 0) {
      return 'Bugün için görev yok';
    }

    else if (complate == total) {
      return 'Bugünü tamamladın!';
    }

   else  if (complate == 0) {
      return 'Hadi, ilk görevini tamamla!';
    }

   else  if (ratio < 0.5) {
      return 'Güzel gidiyorsun!';
    }

   else  if (ratio < 1) {
      return 'Harika ilerliyorsun!';
    }

    return 'Mükemmel iş!';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        AppSvgIcon(icon: Assets.icons.calendar, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GÜNÜN ÖZETİ', style: textTheme.labelSmall),
              const SizedBox(height: 2),
              Text(summary, style: textTheme.titleMedium),
            ],
          ),
        ),
        Text('%${(ratio * 100).round()}', style: textTheme.headlineMedium),
      ],
    );
  }
}

class _Floot extends StatelessWidget {
  final int total;
  final int complate;

  const _Floot({required this.total, required this.complate});

  @override
  Widget build(BuildContext context) {
    final remaining = total - complate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text('$total görevden $complate tanesi tamamlandı')),
        const SizedBox(width: 8),
        Text('$remaining kalan'),
      ],
    );
  }
}
