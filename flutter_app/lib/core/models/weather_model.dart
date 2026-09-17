class CurrentWeather {
  final double temperature;
  final double humidity;
  final double rainProbability;
  final double precipitation;
  final int weatherCode;
  final double cloudCover;
  final double windSpeed;
  final String description;
  final String emoji;
  final String time;

  CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.rainProbability,
    required this.precipitation,
    required this.weatherCode,
    required this.cloudCover,
    required this.windSpeed,
    required this.description,
    required this.emoji,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      rainProbability: (json['rain_probability'] ?? 0).toDouble(),
      precipitation: (json['precipitation'] ?? 0).toDouble(),
      weatherCode: json['weather_code'] ?? 0,
      cloudCover: (json['cloud_cover'] ?? 0).toDouble(),
      windSpeed: (json['wind_speed'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      emoji: json['emoji'] ?? '🌡️',
      time: json['time'] ?? '',
    );
  }
}

class DayForecast {
  final String date;
  final int weatherCode;
  final double tempMax;
  final double tempMin;
  final double rainProbability;
  final double precipitationSum;
  final String sunrise;
  final String sunset;
  final String description;
  final String emoji;

  DayForecast({
    required this.date,
    required this.weatherCode,
    required this.tempMax,
    required this.tempMin,
    required this.rainProbability,
    required this.precipitationSum,
    required this.sunrise,
    required this.sunset,
    required this.description,
    required this.emoji,
  });

  factory DayForecast.fromJson(Map<String, dynamic> json) {
    return DayForecast(
      date: json['date'] ?? '',
      weatherCode: json['weather_code'] ?? 0,
      tempMax: (json['temp_max'] ?? 0).toDouble(),
      tempMin: (json['temp_min'] ?? 0).toDouble(),
      rainProbability: (json['rain_probability'] ?? 0).toDouble(),
      precipitationSum: (json['precipitation_sum'] ?? 0).toDouble(),
      sunrise: json['sunrise'] ?? '',
      sunset: json['sunset'] ?? '',
      description: json['description'] ?? '',
      emoji: json['emoji'] ?? '🌡️',
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final double rainProbability;
  final int weatherCode;
  final String description;
  final String emoji;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.rainProbability,
    required this.weatherCode,
    required this.description,
    required this.emoji,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      rainProbability: (json['rain_probability'] ?? 0).toDouble(),
      weatherCode: json['weather_code'] ?? 0,
      description: json['description'] ?? '',
      emoji: json['emoji'] ?? '🌡️',
    );
  }
}

class WeatherData {
  final CurrentWeather current;
  final List<DayForecast> forecast;
  final List<HourlyForecast> hourly;

  WeatherData({
    required this.current,
    required this.forecast,
    required this.hourly,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current'] ?? {}),
      forecast: (json['forecast'] as List? ?? [])
          .map((d) => DayForecast.fromJson(d))
          .toList(),
      hourly: (json['hourly'] as List? ?? [])
          .map((h) => HourlyForecast.fromJson(h))
          .toList(),
    );
  }
}

class LocationResult {
  final String name;
  final String district;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  final String timezone;

  LocationResult({
    required this.name,
    required this.district,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      name: json['name'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      timezone: json['timezone'] ?? 'Asia/Kolkata',
    );
  }

  String get displayName {
    if (district.isNotEmpty && district != name) {
      return '$name, $district';
    }
    return name;
  }
}
