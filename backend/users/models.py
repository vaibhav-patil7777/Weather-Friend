from django.db import models

class UserPreference(models.Model):
    device_id = models.CharField(max_length=200, unique=True)
    language = models.CharField(max_length=5, default='en')
    last_location_name = models.CharField(max_length=200, blank=True)
    last_lat = models.FloatField(null=True, blank=True)
    last_lon = models.FloatField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Device {self.device_id} - {self.language}"
