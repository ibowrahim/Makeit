import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:make_it/Screens/navigation.dart';
import 'package:make_it/Provider/Todo_Provider.dart';
import 'package:make_it/Services/notification_services.dart';
import 'package:make_it/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bildirim servisinin başlatılma süresini ölç.
  final stopwatch = Stopwatch()..start();

  await NotificationService().init();

  stopwatch.stop();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider()..load(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Uygulamanın genel tema ayarları.
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // Türkçe dil desteği.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],

      supportedLocales: const [Locale('tr', 'TR')],

      locale: const Locale('tr', 'TR'),

      // Ana navigasyon yapısı.
      home: const MainShell(),
    );
  }
}
