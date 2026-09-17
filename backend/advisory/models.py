from django.db import models


class AdvisoryRule(models.Model):
    CONDITION_CHOICES = [
        ('rain_probability', 'Rain Probability'),
        ('temperature', 'Temperature'),
        ('humidity', 'Humidity'),
        ('wind_speed', 'Wind Speed'),
        ('cloud_cover', 'Cloud Cover'),
    ]

    crop_name_en = models.CharField(max_length=100)  # matches Crop.name_en
    condition = models.CharField(max_length=50, choices=CONDITION_CHOICES)
    min_value = models.FloatField(null=True, blank=True)
    max_value = models.FloatField(null=True, blank=True)
    advice_en = models.TextField()
    advice_hi = models.TextField()
    advice_mr = models.TextField()
    priority = models.IntegerField(default=5)
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.crop_name_en} - {self.condition}"

    class Meta:
        ordering = ['crop_name_en', 'priority']
