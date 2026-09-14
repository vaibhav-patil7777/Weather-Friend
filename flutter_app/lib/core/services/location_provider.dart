import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/weather_model.dart';
import '../models/crop_model.dart';
import 'api_service.dart';

class LocationProvider extends ChangeNotifier {
  LocationResult? _selectedLocation;
  WeatherData? _weatherData;
  CropsResponse? _cropsData;
  String _currentSeason = 'kharif';
  bool _isLoadingWeather = false;
  bool _isLoadingCrops = false;
  String? _error;

  LocationResult? get selectedLocation => _selectedLocation;
  WeatherData? get weatherData => _weatherData;
  CropsResponse? get cropsData => _cropsData;
  String get currentSeason => _currentSeason;
  bool get isLoadingWeather => _isLoadingWeather;
  bool get isLoadingCrops => _isLoadingCrops;
  String? get error => _error;

  final ApiService _api = ApiService();

  Future<void> loadLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(AppConstants.lastLocationNameKey);
    final lat = prefs.getDouble(AppConstants.lastLatKey);
    final lon = prefs.getDouble(AppConstants.lastLonKey);
    if (name != null && lat != null && lon != null) {
      _selectedLocation = LocationResult(
        name: name,
        district: '',
        state: '',
        country: 'India',
        latitude: lat,
        longitude: lon,
        timezone: 'Asia/Kolkata',
      );
      notifyListeners();
    }
  }

  Future<void> selectLocation(LocationResult location, String lang) async {
    _selectedLocation = location;
    _error = null;

    // Save last location
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.lastLocationNameKey, location.name);
    await prefs.setDouble(AppConstants.lastLatKey, location.latitude);
    await prefs.setDouble(AppConstants.lastLonKey, location.longitude);

    notifyListeners();
    await fetchWeather();
    await fetchCrops(lang);
  }

  Future<void> fetchWeather() async {
    if (_selectedLocation == null) return;
    _isLoadingWeather = true;
    _error = null;
    notifyListeners();

    final data = await _api.getWeather(
      _selectedLocation!.latitude,
      _selectedLocation!.longitude,
    );

    _isLoadingWeather = false;
    if (data != null) {
      _weatherData = data;
    } else {
      _error = 'Could not fetch weather data. Check your connection.';
    }
    notifyListeners();
  }

  Future<void> fetchCrops(String lang) async {
    if (_selectedLocation == null) return;
    _isLoadingCrops = true;
    notifyListeners();

    _currentSeason = await _api.getCurrentSeason();
    final data = await _api.getCrops(
      district: _selectedLocation!.district.isNotEmpty
          ? _selectedLocation!.district
          : _selectedLocation!.name,
      season: _currentSeason,
      lang: lang,
    );

    _isLoadingCrops = false;
    if (data != null) {
      _cropsData = data;
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
