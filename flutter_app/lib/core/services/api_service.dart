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
      final uri = Uri.parse(AppConstants.locationSearchUrl).replace(
        queryParameters: {'q': query},
      );
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

  Future<WeatherData?> getWeather(double lat, double lon) async {
    try {
      final uri = Uri.parse(AppConstants.weatherUrl).replace(
        queryParameters: {
          'lat': lat.toString(),
          'lon': lon.toString(),
        },
      );
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherData.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<CropsResponse?> getCrops({
    required String district,
    required String season,
    required String lang,
  }) async {
    try {
      final uri = Uri.parse(AppConstants.cropsUrl).replace(
        queryParameters: {
          'district': district,
          'season': season,
          'lang': lang,
        },
      );
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CropsResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String> getCurrentSeason() async {
    try {
      final uri = Uri.parse(AppConstants.seasonUrl);
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['season'] ?? 'kharif';
      }
      return 'kharif';
    } catch (e) {
      return 'kharif';
    }
  }

  Future<AdvisoryResponse?> getAdvisory({
    required String cropNameEn,
    required double rain,
    required double humidity,
    required double wind,
    required double temp,
    required double cloud,
    required String lang,
  }) async {
    try {
      final uri = Uri.parse(AppConstants.advisoryUrl).replace(
        queryParameters: {
          'crop': cropNameEn,
          'rain': rain.toString(),
          'humidity': humidity.toString(),
          'wind': wind.toString(),
          'temp': temp.toString(),
          'cloud': cloud.toString(),
          'lang': lang,
        },
      );
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdvisoryResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
