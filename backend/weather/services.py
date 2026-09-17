import requests
from django.conf import settings


def search_location(query: str) -> list:
    """Search locations using Open-Meteo Geocoding API."""
    try:
        url = settings.OPEN_METEO_GEOCODING_URL
        params = {
            'name': query,
            'count': 10,
            'language': 'en',
            'format': 'json',
        }
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()
        results = data.get('results', [])
        locations = []
        for r in results:
            locations.append({
                'name': r.get('name', ''),
                'district': r.get('admin2', r.get('admin1', '')),
                'state': r.get('admin1', ''),
                'country': r.get('country', ''),
                'latitude': r.get('latitude'),
                'longitude': r.get('longitude'),
                'timezone': r.get('timezone', 'Asia/Kolkata'),
            })
        return locations
    except Exception as e:
        return []


def get_current_weather(lat: float, lon: float) -> dict:
    """Fetch current weather + 7-day forecast + hourly from Open-Meteo."""
    try:
        url = settings.OPEN_METEO_WEATHER_URL
        params = {
            'latitude': lat,
            'longitude': lon,
            'current': [
                'temperature_2m',
                'relative_humidity_2m',
                'precipitation_probability',
                'precipitation',
                'weather_code',
                'cloud_cover',
                'wind_speed_10m',
                'wind_direction_10m',
            ],
            'hourly': [
                'temperature_2m',
                'precipitation_probability',
                'weather_code',
            ],
            'daily': [
                'weather_code',
                'temperature_2m_max',
                'temperature_2m_min',
                'precipitation_sum',
                'precipitation_probability_max',
                'sunrise',
                'sunset',
            ],
            'timezone': 'Asia/Kolkata',
            'forecast_days': 7,
        }
        response = requests.get(url, params=params, timeout=10)
        response.raise_for_status()
        data = response.json()

        current = data.get('current', {})
        daily = data.get('daily', {})
        hourly = data.get('hourly', {})

        # Build 7-day forecast list
        forecast_days = []
        day_times = daily.get('time', [])
        for i, day in enumerate(day_times):
            forecast_days.append({
                'date': day,
                'weather_code': daily.get('weather_code', [])[i] if i < len(daily.get('weather_code', [])) else 0,
                'temp_max': daily.get('temperature_2m_max', [])[i] if i < len(daily.get('temperature_2m_max', [])) else 0,
                'temp_min': daily.get('temperature_2m_min', [])[i] if i < len(daily.get('temperature_2m_min', [])) else 0,
                'precipitation_sum': daily.get('precipitation_sum', [])[i] if i < len(daily.get('precipitation_sum', [])) else 0,
                'rain_probability': daily.get('precipitation_probability_max', [])[i] if i < len(daily.get('precipitation_probability_max', [])) else 0,
                'sunrise': daily.get('sunrise', [])[i] if i < len(daily.get('sunrise', [])) else '',
                'sunset': daily.get('sunset', [])[i] if i < len(daily.get('sunset', [])) else '',
            })

        # Build hourly forecast (next 24 hours)
        hourly_forecast = []
        hourly_times = hourly.get('time', [])
        for i, h in enumerate(hourly_times[:24]):
            hourly_forecast.append({
                'time': h,
                'temperature': hourly.get('temperature_2m', [])[i] if i < len(hourly.get('temperature_2m', [])) else 0,
                'rain_probability': hourly.get('precipitation_probability', [])[i] if i < len(hourly.get('precipitation_probability', [])) else 0,
                'weather_code': hourly.get('weather_code', [])[i] if i < len(hourly.get('weather_code', [])) else 0,
            })

        return {
            'current': {
                'temperature': current.get('temperature_2m', 0),
                'humidity': current.get('relative_humidity_2m', 0),
                'rain_probability': current.get('precipitation_probability', 0),
                'precipitation': current.get('precipitation', 0),
                'weather_code': current.get('weather_code', 0),
                'cloud_cover': current.get('cloud_cover', 0),
                'wind_speed': current.get('wind_speed_10m', 0),
                'wind_direction': current.get('wind_direction_10m', 0),
                'time': current.get('time', ''),
            },
            'forecast': forecast_days,
            'hourly': hourly_forecast,
        }
    except Exception as e:
        return {'error': str(e)}


def get_weather_description(weather_code: int) -> dict:
    """Convert WMO weather code to description and emoji."""
    code_map = {
        0: {'desc': 'Clear Sky', 'emoji': '☀️'},
        1: {'desc': 'Mainly Clear', 'emoji': '🌤️'},
        2: {'desc': 'Partly Cloudy', 'emoji': '⛅'},
        3: {'desc': 'Overcast', 'emoji': '☁️'},
        45: {'desc': 'Foggy', 'emoji': '🌫️'},
        48: {'desc': 'Icy Fog', 'emoji': '🌫️'},
        51: {'desc': 'Light Drizzle', 'emoji': '🌦️'},
        53: {'desc': 'Drizzle', 'emoji': '🌦️'},
        55: {'desc': 'Heavy Drizzle', 'emoji': '🌧️'},
        61: {'desc': 'Light Rain', 'emoji': '🌧️'},
        63: {'desc': 'Moderate Rain', 'emoji': '🌧️'},
        65: {'desc': 'Heavy Rain', 'emoji': '🌧️'},
        71: {'desc': 'Light Snow', 'emoji': '🌨️'},
        73: {'desc': 'Moderate Snow', 'emoji': '❄️'},
        75: {'desc': 'Heavy Snow', 'emoji': '❄️'},
        80: {'desc': 'Light Showers', 'emoji': '🌦️'},
        81: {'desc': 'Moderate Showers', 'emoji': '🌧️'},
        82: {'desc': 'Heavy Showers', 'emoji': '⛈️'},
        95: {'desc': 'Thunderstorm', 'emoji': '⛈️'},
        96: {'desc': 'Thunderstorm with Hail', 'emoji': '⛈️'},
        99: {'desc': 'Heavy Thunderstorm', 'emoji': '⛈️'},
    }
    return code_map.get(weather_code, {'desc': 'Unknown', 'emoji': '🌡️'})
