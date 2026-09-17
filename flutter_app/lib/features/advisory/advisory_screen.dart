import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../core/models/crop_model.dart';
import '../../core/services/api_service.dart';

class AdvisoryScreen extends StatefulWidget {
  final CropItem crop;
  final dynamic weather;
  final String lang;

  const AdvisoryScreen(
      {super.key, required this.crop, required this.weather, required this.lang});

  @override
  State<AdvisoryScreen> createState() => _AdvisoryScreenState();
}

class _AdvisoryScreenState extends State<AdvisoryScreen> {
  AdvisoryResponse? _advisory;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAdvisory();
  }

  Future<void> _fetchAdvisory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final w = widget.weather;
    final result = await ApiService().getAdvisory(
      cropNameEn: widget.crop.nameEn,
      rain: w?.rainProbability ?? 0,
      humidity: w?.humidity ?? 0,
      wind: w?.windSpeed ?? 0,
      temp: w?.temperature ?? 25,
      cloud: w?.cloudCover ?? 0,
      lang: widget.lang,
    );
    setState(() {
      _isLoading = false;
      if (result != null) {
        _advisory = result;
      } else {
        _error = 'Could not fetch advisory. Please try again.';
      }
    });
  }

  Color _riskColor(String risk) {
    switch (risk) {
      case 'High':
        return AppTheme.dangerRed;
      case 'Medium':
        return AppTheme.warningOrange;
      default:
        return AppTheme.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.weather;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.crop.emoji} ${widget.crop.name}'),
        backgroundColor: AppTheme.primaryGreen,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh), onPressed: _fetchAdvisory),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(_error!,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: _fetchAdvisory,
                          child: const Text('Retry')),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Crop header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryGreen, Color(0xFF1B5E20)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(widget.crop.emoji,
                                style: const TextStyle(fontSize: 56)),
                            const SizedBox(height: 8),
                            Text(
                              widget.crop.name,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            if (_advisory != null) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _riskColor(_advisory!.risk)
                                      .withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _advisory!.riskDisplay,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Current weather used
                      if (w != null) ...[
                        const Text('Current Weather Conditions',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 8),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _WeatherChip(
                                    icon: '🌡️',
                                    label:
                                        '${w.temperature.toStringAsFixed(0)}°C'),
                                _WeatherChip(
                                    icon: '🌧️',
                                    label:
                                        '${w.rainProbability.toStringAsFixed(0)}% Rain'),
                                _WeatherChip(
                                    icon: '💧',
                                    label:
                                        '${w.humidity.toStringAsFixed(0)}% Humidity'),
                                _WeatherChip(
                                    icon: '💨',
                                    label:
                                        '${w.windSpeed.toStringAsFixed(0)} km/h'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Advisory
                      const Text('Advisory',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 10),
                      if (_advisory != null)
                        ..._advisory!.advice.map((advice) => _AdviceCard(
                              text: advice,
                              riskColor: _riskColor(_advisory!.risk),
                            )),

                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '⚠️ This advisory is based on current weather conditions. Always follow local agricultural guidance and expert advice.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _WeatherChip extends StatelessWidget {
  final String icon;
  final String label;
  const _WeatherChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _AdviceCard extends StatelessWidget {
  final String text;
  final Color riskColor;
  const _AdviceCard({required this.text, required this.riskColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: riskColor, width: 4)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('•',
                style: TextStyle(
                    fontSize: 20,
                    color: riskColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, height: 1.4)),
            ),
          ],
        ),
      ),
    );
  }
}
