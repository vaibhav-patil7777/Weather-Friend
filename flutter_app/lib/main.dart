import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'core/services/language_provider.dart';
import 'core/services/location_provider.dart';
import 'features/language/language_screen.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final langProvider = LanguageProvider();
  await langProvider.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: langProvider),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const MausamSaathiApp(),
    ),
  );
}

class MausamSaathiApp extends StatelessWidget {
  const MausamSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();

    return MaterialApp(
      title: 'Mausam Saathi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: langProvider.locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],
      home: langProvider.needsLanguageSelection
          ? const LanguageScreen()
          : const HomeScreen(),
    );
  }
}