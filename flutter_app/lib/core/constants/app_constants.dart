class AppConstants {
  // ⚠️ IMPORTANT: Change this to your Django server URL when deploying
  // For local development (Android emulator): use 10.0.2.2 instead of localhost
  // For local development (physical device): use your PC's IP address e.g. http://192.168.1.100:8000
  //static const String baseUrl = 'http://127.0.0.1:8000';
  static const String baseUrl = 'https://weather-friend.onrender.com';

  // API endpoints
  static const String locationSearchUrl = '$baseUrl/api/weather/location/search/';
  static const String weatherUrl = '$baseUrl/api/weather/';
  static const String cropsUrl = '$baseUrl/api/crops/';
  static const String seasonUrl = '$baseUrl/api/crops/season/';
  static const String advisoryUrl = '$baseUrl/api/advisory/';
  static const String userPreferenceUrl = '$baseUrl/api/users/preference/';

  // SharedPreferences keys
  static const String langKey = 'selected_language';
  static const String lastLocationNameKey = 'last_location_name';
  static const String lastLatKey = 'last_lat';
  static const String lastLonKey = 'last_lon';
  static const String deviceIdKey = 'device_id';

  // Supported languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧', 'native': 'English'},
    {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳', 'native': 'हिन्दी'},
    {'code': 'mr', 'name': 'Marathi', 'flag': '🇮🇳', 'native': 'मराठी'},
  ];
}
