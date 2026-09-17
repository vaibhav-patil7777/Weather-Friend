from django.db import models


class Crop(models.Model):
    name_en = models.CharField(max_length=100)
    name_hi = models.CharField(max_length=100)
    name_mr = models.CharField(max_length=100)
    emoji = models.CharField(max_length=10, default='🌱')
    description_en = models.TextField(blank=True)
    description_hi = models.TextField(blank=True)
    description_mr = models.TextField(blank=True)

    def __str__(self):
        return self.name_en

    def get_name(self, lang='en'):
        return getattr(self, f'name_{lang}', self.name_en)


class CropSeason(models.Model):
    SEASON_CHOICES = [
        ('kharif', 'Kharif'),
        ('rabi', 'Rabi'),
        ('zaid', 'Zaid'),
        ('annual', 'Annual'),
    ]
    crop = models.ForeignKey(Crop, on_delete=models.CASCADE, related_name='seasons')
    season = models.CharField(max_length=20, choices=SEASON_CHOICES)
    district = models.CharField(max_length=200)
    state = models.CharField(max_length=200, default='Maharashtra')
    priority = models.IntegerField(default=5)  # 1=highest priority

    def __str__(self):
        return f"{self.crop.name_en} - {self.season} - {self.district}"

    class Meta:
        ordering = ['priority']
