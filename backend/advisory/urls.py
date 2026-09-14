from django.urls import path
from .views import AdvisoryView

urlpatterns = [
    path('', AdvisoryView.as_view(), name='advisory'),
]
