from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .services import search_location, get_current_weather, get_weather_description


class LocationSearchView(APIView):
    """GET /api/weather/location/search/?q=jalgaon"""

    def get(self, request):
        query = request.query_params.get('q', '').strip()
        if not query:
            return Response({'error': 'Query parameter q is required'}, status=status.HTTP_400_BAD_REQUEST)
        locations = search_location(query)
        return Response({'results': locations})


class WeatherView(APIView):
    """GET /api/weather/?lat=21.0077&lon=75.5626"""

    def get(self, request):
        lat = request.query_params.get('lat')
        lon = request.query_params.get('lon')
        if not lat or not lon:
            return Response({'error': 'lat and lon are required'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            lat = float(lat)
            lon = float(lon)
        except ValueError:
            return Response({'error': 'lat and lon must be numbers'}, status=status.HTTP_400_BAD_REQUEST)

        weather_data = get_current_weather(lat, lon)
        if 'error' in weather_data:
            return Response({'error': weather_data['error']}, status=status.HTTP_503_SERVICE_UNAVAILABLE)

        # Add description to current weather
        current = weather_data['current']
        desc = get_weather_description(current['weather_code'])
        current['description'] = desc['desc']
        current['emoji'] = desc['emoji']

        # Add description to forecast days
        for day in weather_data['forecast']:
            d = get_weather_description(day['weather_code'])
            day['description'] = d['desc']
            day['emoji'] = d['emoji']

        # Add description to hourly
        for hour in weather_data['hourly']:
            h = get_weather_description(hour['weather_code'])
            hour['description'] = h['desc']
            hour['emoji'] = h['emoji']

        return Response(weather_data)
