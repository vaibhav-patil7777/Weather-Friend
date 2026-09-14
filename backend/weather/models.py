from django.db import models


class Location(models.Model):
    name = models.CharField(max_length=200)
    district = models.CharField(max_length=200, blank=True)
    state = models.CharField(max_length=200, blank=True)
    country = models.CharField(max_length=200, default='India')
    latitude = models.FloatField()
    longitude = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name}, {self.district}"

    class Meta:
        ordering = ['name']
