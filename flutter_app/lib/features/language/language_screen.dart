import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_theme.dart';
import '../../core/services/language_provider.dart';
import '../home/home_screen.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryGreen, Color(0xFF1B5E20)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🌾', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 16),
                const Text(
                  'Mausam Saathi',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'मौसम साथी',
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 48),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Choose Language / भाषा चुनें / भाषा निवडा',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...AppConstants.supportedLanguages.map((lang) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _LanguageButton(
                            flag: lang['flag']!,
                            name: lang['name']!,
                            native: lang['native']!,
                            langCode: lang['code']!,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String flag;
  final String name;
  final String native;
  final String langCode;

  const _LanguageButton({
    required this.flag,
    required this.name,
    required this.native,
    required this.langCode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          side: const BorderSide(color: AppTheme.primaryGreen, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () async {
          await context.read<LanguageProvider>().setLanguage(langCode);
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(native,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
                Text(name,
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
