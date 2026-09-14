import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_theme.dart';
import '../../core/services/language_provider.dart';
import '../../core/services/location_provider.dart';
import '../location/location_search_screen.dart';
import '../weather/weather_screen.dart';
import '../crops/crops_screen.dart';
import '../weather/forecast_screen.dart';
import '../language/language_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().loadLastLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>().langCode;
    final locationProvider = context.watch<LocationProvider>();
    final hasLocation = locationProvider.selectedLocation != null;

    final pages = [
      const _HomePage(),
      hasLocation ? const WeatherScreen() : const _NoLocationWidget(),
      hasLocation ? const CropsScreen() : const _NoLocationWidget(),
      hasLocation ? const ForecastScreen() : const _NoLocationWidget(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: AppTheme.primaryGreen.withOpacity(0.15),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppTheme.primaryGreen), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.cloud_outlined), selectedIcon: Icon(Icons.cloud, color: AppTheme.primaryGreen), label: 'Weather'),
          NavigationDestination(icon: Icon(Icons.grass_outlined), selectedIcon: Icon(Icons.grass, color: AppTheme.primaryGreen), label: 'Crops'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today, color: AppTheme.primaryGreen), label: 'Forecast'),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final langProvider = context.watch<LanguageProvider>();
    final lang = langProvider.langCode;
    final weather = locationProvider.weatherData?.current;
    final location = locationProvider.selectedLocation;
    final crops = locationProvider.cropsData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌾 Mausam Saathi'),
        backgroundColor: AppTheme.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            tooltip: 'Change Language',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguageScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (location != null) {
            await locationProvider.fetchWeather();
            await locationProvider.fetchCrops(lang);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LocationSearchScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppTheme.primaryGreen),
                      const SizedBox(width: 12),
                      Text(
                        location != null ? location.name : 'Search village / city...',
                        style: TextStyle(
                          fontSize: 16,
                          color: location != null ? Colors.black87 : Colors.grey,
                        ),
                      ),
                      const Spacer(),
                      if (location != null)
                        const Icon(Icons.edit_location_alt_outlined,
                            color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (location == null) ...[
                _WelcomeCard(),
              ] else ...[
                // Location header
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.primaryGreen, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Weather summary card
                if (locationProvider.isLoadingWeather)
                  const Center(child: CircularProgressIndicator())
                else if (weather != null)
                  _WeatherSummaryCard(weather: weather)
                else if (locationProvider.error != null)
                  _ErrorCard(message: locationProvider.error!),

                const SizedBox(height: 16),

                // Season + Crops
                if (crops != null) ...[
                  _SeasonCard(season: crops.seasonDisplay),
                  const SizedBox(height: 12),
                  _CropsSummaryCard(crops: crops.crops.map((c) => '${c.emoji} ${c.name}').toList()),
                ] else if (locationProvider.isLoadingCrops)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  )),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('🌾', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Mausam Saathi',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search your village or city above to get weather and crop advisory.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LocationSearchScreen()),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('Search Location'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherSummaryCard extends StatelessWidget {
  final dynamic weather;
  const _WeatherSummaryCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weather.emoji,
                        style: const TextStyle(fontSize: 48)),
                    Text(
                      weather.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                Text(
                  '${weather.temperature.toStringAsFixed(0)}°C',
                  style: const TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.skyBlue,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherStat(icon: '💧', label: 'Humidity', value: '${weather.humidity.toStringAsFixed(0)}%'),
                _WeatherStat(icon: '🌧️', label: 'Rain', value: '${weather.rainProbability.toStringAsFixed(0)}%'),
                _WeatherStat(icon: '💨', label: 'Wind', value: '${weather.windSpeed.toStringAsFixed(0)} km/h'),
                _WeatherStat(icon: '☁️', label: 'Cloud', value: '${weather.cloudCover.toStringAsFixed(0)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _WeatherStat({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _SeasonCard extends StatelessWidget {
  final String season;
  const _SeasonCard({required this.season});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('🌾', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Season', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(season,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CropsSummaryCard extends StatelessWidget {
  final List<String> crops;
  const _CropsSummaryCard({required this.crops});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Common Crops This Season',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: crops.map((crop) {
                return Chip(
                  label: Text(crop),
                  backgroundColor: AppTheme.backgroundLight,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            const Text(
              'Go to Crops tab for advisory →',
              style: TextStyle(color: AppTheme.primaryGreen, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}

class _NoLocationWidget extends StatelessWidget {
  const _NoLocationWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📍', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text('No location selected.',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LocationSearchScreen()),
                );
              },
              child: const Text('Search Location'),
            ),
          ],
        ),
      ),
    );
  }
}
