from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .rules import evaluate_rules, get_risk_level


class AdvisoryView(APIView):
    """
    GET /api/advisory/?crop=Cotton&rain=80&humidity=85&wind=10&temp=33&lang=en
    """

    def get(self, request):
        crop = request.query_params.get('crop', '').strip()
        lang = request.query_params.get('lang', 'en').strip().lower()

        if not crop:
            return Response({'error': 'crop parameter is required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            weather = {
                'rain_probability': float(request.query_params.get('rain', 0)),
                'humidity': float(request.query_params.get('humidity', 0)),
                'wind_speed': float(request.query_params.get('wind', 0)),
                'temperature': float(request.query_params.get('temp', 25)),
                'cloud_cover': float(request.query_params.get('cloud', 0)),
            }
        except ValueError:
            return Response({'error': 'Weather parameters must be numbers'}, status=status.HTTP_400_BAD_REQUEST)

        advice = evaluate_rules(crop, weather, lang)
        risk = get_risk_level(weather)

        risk_display = {
            'en': {'High': '⚠️ High Risk', 'Medium': '⚡ Medium Risk', 'Low': '✅ Low Risk'},
            'hi': {'High': '⚠️ उच्च जोखिम', 'Medium': '⚡ मध्यम जोखिम', 'Low': '✅ कम जोखिम'},
            'mr': {'High': '⚠️ जास्त धोका', 'Medium': '⚡ मध्यम धोका', 'Low': '✅ कमी धोका'},
        }

        return Response({
            'crop': crop,
            'lang': lang,
            'risk': risk,
            'risk_display': risk_display.get(lang, risk_display['en']).get(risk, risk),
            'weather_used': weather,
            'advice': advice,
        })
