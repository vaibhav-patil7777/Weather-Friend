import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/weather_model.dart';
import '../models/crop_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final Duration _timeout = const Duration(seconds: 15);

  Future<List<LocationResult>> searchLocation(String query) async {
    try {
      final uri = Uri.parse(AppConstants.locationSearchUrl)
          .replace(queryParameters: {'q': query});
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List? ?? [];
        return results.map((r) => LocationResult.fromJson(r)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Direct Open-Meteo — Django bypass kiya 429 fix ke liye
  Future<WeatherData?> getWeather(double lat, double lon) async {
    try {
      final uri = Uri.parse('https://api.open-meteo.com/v1/forecast').replace(
        queryParameters: {
          'latitude': lat.toString(),
          'longitude': lon.toString(),
          'current': 'temperature_2m,relative_humidity_2m,precipitation_probability,precipitation,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m',
          'hourly': 'temperature_2m,precipitation_probability,weather_code',
          'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum,precipitation_probability_max,sunrise,sunset',
          'timezone': 'Asia/Kolkata',
          'forecast_days': '7',
        },
      );
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body);
      final current = data['current'] as Map<String, dynamic>? ?? {};
      final daily = data['daily'] as Map<String, dynamic>? ?? {};
      final hourly = data['hourly'] as Map<String, dynamic>? ?? {};

      final dayTimes = daily['time'] as List? ?? [];
      final List<DayForecast> forecastDays = [];
      for (int i = 0; i < dayTimes.length; i++) {
        final wCode = _safeInt((daily['weather_code'] as List? ?? [])[i]);
        forecastDays.add(DayForecast(
          date: dayTimes[i].toString(),
          weatherCode: wCode,
          tempMax: _safeDouble((daily['temperature_2m_max'] as List? ?? [])[i]),
          tempMin: _safeDouble((daily['temperature_2m_min'] as List? ?? [])[i]),
          rainProbability: _safeDouble((daily['precipitation_probability_max'] as List? ?? [])[i]),
          precipitationSum: _safeDouble((daily['precipitation_sum'] as List? ?? [])[i]),
          sunrise: (daily['sunrise'] as List? ?? []).length > i ? (daily['sunrise'] as List)[i].toString() : '',
          sunset: (daily['sunset'] as List? ?? []).length > i ? (daily['sunset'] as List)[i].toString() : '',
          description: _weatherDesc(wCode)['desc']!,
          emoji: _weatherDesc(wCode)['emoji']!,
        ));
      }

      final hourlyTimes = hourly['time'] as List? ?? [];
      final List<HourlyForecast> hourlyList = [];
      for (int i = 0; i < hourlyTimes.length && i < 24; i++) {
        final wCode = _safeInt((hourly['weather_code'] as List? ?? [])[i]);
        hourlyList.add(HourlyForecast(
          time: hourlyTimes[i].toString(),
          temperature: _safeDouble((hourly['temperature_2m'] as List? ?? [])[i]),
          rainProbability: _safeDouble((hourly['precipitation_probability'] as List? ?? [])[i]),
          weatherCode: wCode,
          description: _weatherDesc(wCode)['desc']!,
          emoji: _weatherDesc(wCode)['emoji']!,
        ));
      }

      final wCode = _safeInt(current['weather_code']);
      return WeatherData(
        current: CurrentWeather(
          temperature: _safeDouble(current['temperature_2m']),
          humidity: _safeDouble(current['relative_humidity_2m']),
          rainProbability: _safeDouble(current['precipitation_probability']),
          precipitation: _safeDouble(current['precipitation']),
          weatherCode: wCode,
          cloudCover: _safeDouble(current['cloud_cover']),
          windSpeed: _safeDouble(current['wind_speed_10m']),
          description: _weatherDesc(wCode)['desc']!,
          emoji: _weatherDesc(wCode)['emoji']!,
          time: current['time']?.toString() ?? '',
        ),
        forecast: forecastDays,
        hourly: hourlyList,
      );
    } catch (e) {
      return null;
    }
  }

  Future<CropsResponse?> getCrops({required String district, required String season, required String lang}) async {
    try {
      final uri = Uri.parse(AppConstants.cropsUrl).replace(queryParameters: {'district': district, 'season': season, 'lang': lang});
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) return CropsResponse.fromJson(jsonDecode(response.body));
      return null;
    } catch (e) { return null; }
  }

  Future<String> getCurrentSeason() async {
    try {
      final response = await http.get(Uri.parse(AppConstants.seasonUrl)).timeout(_timeout);
      if (response.statusCode == 200) return jsonDecode(response.body)['season'] ?? 'kharif';
      return 'kharif';
    } catch (e) { return 'kharif'; }
  }

  Future<AdvisoryResponse?> getAdvisory({required String cropNameEn, required double rain, required double humidity, required double wind, required double temp, required double cloud, required String lang}) async {
    try {
      final uri = Uri.parse(AppConstants.advisoryUrl).replace(queryParameters: {'crop': cropNameEn, 'rain': rain.toString(), 'humidity': humidity.toString(), 'wind': wind.toString(), 'temp': temp.toString(), 'cloud': cloud.toString(), 'lang': lang});
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) return AdvisoryResponse.fromJson(jsonDecode(response.body));
      return null;
    } catch (e) { return null; }
  }

  double _safeDouble(dynamic val) => val == null ? 0.0 : (val as num).toDouble();
  int _safeInt(dynamic val) => val == null ? 0 : (val as num).toInt();

  Map<String, String> _weatherDesc(int code) {
    const map = <int, Map<String, String>>{
      0: {'desc': 'Clear Sky', 'emoji': '☀️'},
      1: {'desc': 'Mainly Clear', 'emoji': '🌤️'},
      2: {'desc': 'Partly Cloudy', 'emoji': '⛅'},
      3: {'desc': 'Overcast', 'emoji': '☁️'},
      45: {'desc': 'Foggy', 'emoji': '🌫️'},
      51: {'desc': 'Light Drizzle', 'emoji': '🌦️'},
      61: {'desc': 'Light Rain', 'emoji': '🌧️'},
      63: {'desc': 'Moderate Rain', 'emoji': '🌧️'},
      65: {'desc': 'Heavy Rain', 'emoji': '🌧️'},
      80: {'desc': 'Light Showers', 'emoji': '🌦️'},
      81: {'desc': 'Moderate Showers', 'emoji': '🌧️'},
      82: {'desc': 'Heavy Showers', 'emoji': '⛈️'},
      95: {'desc': 'Thunderstorm', 'emoji': '⛈️'},
    };
    return map[code] ?? {'desc': 'Unknown', 'emoji': '🌡️'};
  }
}