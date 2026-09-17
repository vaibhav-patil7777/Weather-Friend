from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import UserPreference

class UserPreferenceView(APIView):
    def get(self, request):
        device_id = request.query_params.get('device_id', '')
        if not device_id:
            return Response({'error': 'device_id required'}, status=status.HTTP_400_BAD_REQUEST)
        pref, _ = UserPreference.objects.get_or_create(device_id=device_id)
        return Response({'device_id': pref.device_id, 'language': pref.language, 'last_location_name': pref.last_location_name, 'last_lat': pref.last_lat, 'last_lon': pref.last_lon})

    def post(self, request):
        device_id = request.data.get('device_id', '')
        if not device_id:
            return Response({'error': 'device_id required'}, status=status.HTTP_400_BAD_REQUEST)
        pref, _ = UserPreference.objects.get_or_create(device_id=device_id)
        pref.language = request.data.get('language', pref.language)
        pref.last_location_name = request.data.get('last_location_name', pref.last_location_name)
        pref.last_lat = request.data.get('last_lat', pref.last_lat)
        pref.last_lon = request.data.get('last_lon', pref.last_lon)
        pref.save()
        return Response({'status': 'saved', 'language': pref.language})
