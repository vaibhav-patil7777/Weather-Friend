from django.urls import path
from .views import LocationSearchView, WeatherView

urlpatterns = [
    path('', WeatherView.as_view(), name='weather'),
    path('location/search/', LocationSearchView.as_view(), name='location-search'),
]
