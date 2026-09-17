from django.urls import path
from .views import CropsView, SeasonView

urlpatterns = [
    path('', CropsView.as_view(), name='crops'),
    path('season/', SeasonView.as_view(), name='season'),
]
