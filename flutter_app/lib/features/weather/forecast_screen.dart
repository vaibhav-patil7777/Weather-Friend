import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_theme.dart';
import '../../core/services/location_provider.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final parts = dateStr.split('-');
      if (parts.length < 3) return dateStr;
      final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final month = int.tryParse(parts[1]) ?? 0;
      return '${parts[2]} ${months[month]}';
    } catch (_) {
      return dateStr;
    }
  }

  String _formatTime(String timeStr) {
    if (timeStr.isEmpty) return '';
    try {
      // Format: 2026-09-10T14:00
      final parts = timeStr.split('T');
      if (parts.length < 2) return timeStr;
      return parts[1].substring(0, 5);
    } catch (_) {
      return timeStr;
    }
  }

  String _dayOfWeek(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.watch<LocationProvider>();
    final forecast = locationProvider.weatherData?.forecast ?? [];
    final hourly = locationProvider.weatherData?.hourly ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forecast'),
        backgroundColor: AppTheme.skyBlue,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: '7-Day Forecast'),
            Tab(text: 'Hourly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 7-Day Forecast
          forecast.isEmpty
              ? const Center(child: Text('No forecast data'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: forecast.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final day = forecast[i];
                    final isToday = i == 0;
                    return Card(
                      color: isToday ? AppTheme.skyBlue.withOpacity(0.08) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Column(
                                children: [
                                  Text(
                                    isToday ? 'Today' : _dayOfWeek(day.date),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isToday ? AppTheme.skyBlue : null,
                                    ),
                                  ),
                                  Text(_formatDate(day.date),
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(day.emoji,
                                style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(day.description,
                                  style: const TextStyle(fontSize: 13)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${day.tempMax.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  '${day.tempMin.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Column(
                              children: [
                                const Text('🌧️',
                                    style: TextStyle(fontSize: 14)),
                                Text(
                                  '${day.rainProbability.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: day.rainProbability > 60
                                        ? Colors.blue
                                        : Colors.grey,
                                    fontWeight: day.rainProbability > 60
                                        ? FontWeight.bold
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          // Hourly Forecast
          hourly.isEmpty
              ? const Center(child: Text('No hourly data'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: hourly.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final hour = hourly[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 55,
                            child: Text(
                              _formatTime(hour.time),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                          Text(hour.emoji,
                              style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(hour.description,
                                style: const TextStyle(fontSize: 13)),
                          ),
                          Text(
                            '${hour.temperature.toStringAsFixed(0)}°C',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 45,
                            child: Text(
                              '🌧 ${hour.rainProbability.toStringAsFixed(0)}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: hour.rainProbability > 50
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
