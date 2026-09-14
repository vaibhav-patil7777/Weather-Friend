import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_theme.dart';
import '../../core/models/crop_model.dart';
import '../../core/services/language_provider.dart';
import '../../core/services/location_provider.dart';
import '../advisory/advisory_screen.dart';

class CropsScreen extends StatelessWidget {
  const CropsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final lang = context.watch<LanguageProvider>().langCode;
    final cropsData = locationProvider.cropsData;
    final isLoading = locationProvider.isLoadingCrops;
    final weather = locationProvider.weatherData?.current;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌱 Crops & Advisory'),
        backgroundColor: AppTheme.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => locationProvider.fetchCrops(lang),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cropsData == null
              ? const Center(child: Text('No crop data available'))
              : Column(
                  children: [
                    // Season Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      child: Row(
                        children: [
                          const Text('🌾', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Current Season',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(
                                cropsData.seasonDisplay,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryGreen),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (cropsData.district.isNotEmpty)
                            Text(
                              cropsData.district,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Tap a crop to get weather-based advisory',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: cropsData.crops.isEmpty
                          ? const Center(
                              child: Text(
                                  'No crops found for this region and season.'))
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              itemCount: cropsData.crops.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, i) {
                                final crop = cropsData.crops[i];
                                return _CropCard(
                                  crop: crop,
                                  weather: weather,
                                  lang: lang,
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

class _CropCard extends StatelessWidget {
  final CropItem crop;
  final dynamic weather;
  final String lang;

  const _CropCard(
      {required this.crop, required this.weather, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AdvisoryScreen(
                crop: crop,
                weather: weather,
                lang: lang,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child:
                      Text(crop.emoji, style: const TextStyle(fontSize: 30)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(crop.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    if (crop.description.isNotEmpty)
                      Text(crop.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const Column(
                children: [
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: AppTheme.primaryGreen),
                  SizedBox(height: 4),
                  Text('Advisory',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.primaryGreen)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
