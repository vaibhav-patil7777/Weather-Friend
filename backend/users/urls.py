from django.urls import path
from .views import UserPreferenceView
urlpatterns = [
    path('preference/', UserPreferenceView.as_view(), name='user-preference'),
]
