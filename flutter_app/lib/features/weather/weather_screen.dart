import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_theme.dart';
import '../../core/services/language_provider.dart';
import '../../core/services/location_provider.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final location = locationProvider.selectedLocation;
    final weather = locationProvider.weatherData?.current;
    final isLoading = locationProvider.isLoadingWeather;

    return Scaffold(
      appBar: AppBar(
        title: Text(location?.name ?? 'Weather'),
        backgroundColor: AppTheme.skyBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => locationProvider.fetchWeather(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : weather == null
              ? const Center(child: Text('No weather data available'))
              : RefreshIndicator(
                  onRefresh: () => locationProvider.fetchWeather(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main weather card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.skyBlue, Color(0xFF0D47A1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${weather.temperature.toStringAsFixed(1)}°C',
                                        style: const TextStyle(
                                          fontSize: 56,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        weather.description,
                                        style: const TextStyle(
                                            fontSize: 18, color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                  Text(weather.emoji,
                                      style: const TextStyle(fontSize: 70)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                location?.displayName ?? '',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white60),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Stats grid
                        const Text('Details',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                          children: [
                            _StatCard(
                              icon: '💧',
                              label: 'Humidity',
                              value: '${weather.humidity.toStringAsFixed(0)}%',
                              color: Colors.blue.shade50,
                            ),
                            _StatCard(
                              icon: '🌧️',
                              label: 'Rain Chance',
                              value: '${weather.rainProbability.toStringAsFixed(0)}%',
                              color: Colors.indigo.shade50,
                              highlight: weather.rainProbability > 60,
                            ),
                            _StatCard(
                              icon: '💨',
                              label: 'Wind Speed',
                              value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
                              color: Colors.cyan.shade50,
                            ),
                            _StatCard(
                              icon: '☁️',
                              label: 'Cloud Cover',
                              value: '${weather.cloudCover.toStringAsFixed(0)}%',
                              color: Colors.grey.shade100,
                            ),
                            _StatCard(
                              icon: '🌧️',
                              label: 'Precipitation',
                              value: '${weather.precipitation.toStringAsFixed(1)} mm',
                              color: Colors.teal.shade50,
                            ),
                            _StatCard(
                              icon: '🌡️',
                              label: 'Feels Like',
                              value: '${weather.temperature.toStringAsFixed(0)}°C',
                              color: Colors.orange.shade50,
                            ),
                          ],
                        ),

                        // Rain alert
                        if (weather.rainProbability >= 70) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              children: [
                                const Text('⚠️', style: TextStyle(fontSize: 28)),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'High rain probability. Check Crops tab for specific advisory.',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;
  final bool highlight;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: highlight ? Border.all(color: Colors.orange, width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
