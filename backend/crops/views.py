from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime
from .models import Crop, CropSeason


def get_current_season() -> str:
    """Detect current agricultural season based on month."""
    month = datetime.now().month
    if month in [6, 7, 8, 9, 10]:
        return 'kharif'
    elif month in [11, 12, 1, 2, 3]:
        return 'rabi'
    else:
        return 'zaid'


class CropsView(APIView):
    """GET /api/crops/?district=Jalgaon&season=kharif&lang=en"""

    def get(self, request):
        district = request.query_params.get('district', '').strip()
        season = request.query_params.get('season', '').strip().lower()
        lang = request.query_params.get('lang', 'en').strip().lower()

        if not season:
            season = get_current_season()

        # Query crop seasons
        qs = CropSeason.objects.select_related('crop')

        if district:
            # Try exact district match first, fallback to all
            district_qs = qs.filter(district__iexact=district, season=season)
            if not district_qs.exists():
                district_qs = qs.filter(season=season)
            qs = district_qs
        else:
            qs = qs.filter(season=season)

        crops_data = []
        seen = set()
        for cs in qs:
            if cs.crop.id not in seen:
                seen.add(cs.crop.id)
                crops_data.append({
                    'id': cs.crop.id,
                    'name': cs.crop.get_name(lang),
                    'name_en': cs.crop.name_en,
                    'emoji': cs.crop.emoji,
                    'description': getattr(cs.crop, f'description_{lang}', cs.crop.description_en),
                })

        return Response({
            'season': season,
            'season_display': season.capitalize(),
            'district': district,
            'lang': lang,
            'crops': crops_data,
        })


class SeasonView(APIView):
    """GET /api/crops/season/ — returns current season"""

    def get(self, request):
        season = get_current_season()
        month = datetime.now().month

        season_display = {
            'kharif': {'en': 'Kharif', 'hi': 'खरीफ', 'mr': 'खरीफ'},
            'rabi': {'en': 'Rabi', 'hi': 'रबी', 'mr': 'रब्बी'},
            'zaid': {'en': 'Zaid', 'hi': 'जायद', 'mr': 'झायद'},
        }

        return Response({
            'season': season,
            'month': month,
            'display': season_display.get(season, {}),
        })
