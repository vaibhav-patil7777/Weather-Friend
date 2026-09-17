from django.core.management.base import BaseCommand
from crops.models import Crop, CropSeason


CROPS_DATA = [
    {
        'name_en': 'Cotton',
        'name_hi': 'कपास',
        'name_mr': 'कापूस',
        'emoji': '🌿',
        'description_en': 'Major cash crop of Maharashtra. Grown mainly in Vidarbha and Marathwada.',
        'description_hi': 'महाराष्ट्र की प्रमुख नकदी फसल।',
        'description_mr': 'महाराष्ट्राचे प्रमुख नगदी पीक.',
        'seasons': [
            {'season': 'kharif', 'districts': ['Jalgaon', 'Aurangabad', 'Nanded', 'Amravati', 'Buldhana', 'Akola', 'Washim', 'Yavatmal', 'Wardha', 'Nagpur'], 'priority': 1},
        ]
    },
    {
        'name_en': 'Soybean',
        'name_hi': 'सोयाबीन',
        'name_mr': 'सोयाबीन',
        'emoji': '🫘',
        'description_en': 'Important oilseed crop grown during Kharif season.',
        'description_hi': 'खरीफ मौसम में उगाई जाने वाली महत्वपूर्ण तिलहन फसल।',
        'description_mr': 'खरीफ हंगामात पिकवले जाणारे महत्त्वाचे तेलबिया पीक.',
        'seasons': [
            {'season': 'kharif', 'districts': ['Jalgaon', 'Aurangabad', 'Latur', 'Osmanabad', 'Buldhana', 'Akola', 'Washim'], 'priority': 2},
        ]
    },
    {
        'name_en': 'Maize',
        'name_hi': 'मक्का',
        'name_mr': 'मका',
        'emoji': '🌽',
        'description_en': 'Cereal crop grown in both Kharif and Rabi seasons.',
        'description_hi': 'खरीफ और रबी दोनों मौसमों में उगाई जाने वाली अनाज फसल।',
        'description_mr': 'खरीफ आणि रब्बी दोन्ही हंगामात पिकवले जाणारे धान्य पीक.',
        'seasons': [
            {'season': 'kharif', 'districts': ['Jalgaon', 'Nashik', 'Pune', 'Aurangabad', 'Nanded'], 'priority': 3},
            {'season': 'rabi', 'districts': ['Jalgaon', 'Nashik', 'Pune'], 'priority': 3},
        ]
    },
    {
        'name_en': 'Tur (Pigeon Pea)',
        'name_hi': 'तुअर (अरहर)',
        'name_mr': 'तूर',
        'emoji': '🌱',
        'description_en': 'Major pulse crop of Maharashtra.',
        'description_hi': 'महाराष्ट्र की प्रमुख दलहन फसल।',
        'description_mr': 'महाराष्ट्राचे प्रमुख कडधान्य पीक.',
        'seasons': [
            {'season': 'kharif', 'districts': ['Jalgaon', 'Aurangabad', 'Latur', 'Nanded', 'Osmanabad', 'Buldhana'], 'priority': 2},
        ]
    },
    {
        'name_en': 'Wheat',
        'name_hi': 'गेहूं',
        'name_mr': 'गहू',
        'emoji': '🌾',
        'description_en': 'Major Rabi crop, primarily grown in winter.',
        'description_hi': 'प्रमुख रबी फसल, मुख्यतः सर्दियों में उगाई जाती है।',
        'description_mr': 'प्रमुख रब्बी पीक, मुख्यतः हिवाळ्यात पिकवले जाते.',
        'seasons': [
            {'season': 'rabi', 'districts': ['Nashik', 'Pune', 'Aurangabad', 'Jalgaon', 'Nanded', 'Latur'], 'priority': 1},
        ]
    },
    {
        'name_en': 'Sugarcane',
        'name_hi': 'गन्ना',
        'name_mr': 'ऊस',
        'emoji': '🎋',
        'description_en': 'Annual cash crop, major in Pune and Kolhapur districts.',
        'description_hi': 'वार्षिक नकदी फसल, पुणे और कोल्हापुर जिलों में प्रमुख।',
        'description_mr': 'वार्षिक नगदी पीक, पुणे आणि कोल्हापूर जिल्ह्यांत प्रमुख.',
        'seasons': [
            {'season': 'annual', 'districts': ['Pune', 'Kolhapur', 'Satara', 'Sangli', 'Solapur', 'Nashik'], 'priority': 1},
        ]
    },
    {
        'name_en': 'Onion',
        'name_hi': 'प्याज',
        'name_mr': 'कांदा',
        'emoji': '🧅',
        'description_en': 'Important vegetable crop, Nashik is major producer.',
        'description_hi': 'महत्वपूर्ण सब्जी फसल, नाशिक प्रमुख उत्पादक है।',
        'description_mr': 'महत्त्वाचे भाजीपाला पीक, नाशिक प्रमुख उत्पादक आहे.',
        'seasons': [
            {'season': 'rabi', 'districts': ['Nashik', 'Pune', 'Solapur', 'Aurangabad', 'Jalgaon'], 'priority': 2},
        ]
    },
    {
        'name_en': 'Gram (Chickpea)',
        'name_hi': 'चना',
        'name_mr': 'हरभरा',
        'emoji': '🫛',
        'description_en': 'Important pulse crop grown in Rabi season.',
        'description_hi': 'रबी मौसम में उगाई जाने वाली महत्वपूर्ण दलहन फसल।',
        'description_mr': 'रब्बी हंगामात पिकवले जाणारे महत्त्वाचे कडधान्य पीक.',
        'seasons': [
            {'season': 'rabi', 'districts': ['Aurangabad', 'Latur', 'Nanded', 'Osmanabad', 'Jalgaon', 'Buldhana'], 'priority': 2},
        ]
    },
    {
        'name_en': 'Jowar (Sorghum)',
        'name_hi': 'ज्वार',
        'name_mr': 'ज्वारी',
        'emoji': '🌾',
        'description_en': 'Drought-resistant cereal crop grown in both seasons.',
        'description_hi': 'सूखा-प्रतिरोधी अनाज फसल जो दोनों मौसमों में उगाई जाती है।',
        'description_mr': 'दुष्काळ-प्रतिरोधक धान्य पीक, दोन्ही हंगामात पिकवले जाते.',
        'seasons': [
            {'season': 'kharif', 'districts': ['Aurangabad', 'Latur', 'Osmanabad', 'Solapur', 'Nashik', 'Pune'], 'priority': 3},
            {'season': 'rabi', 'districts': ['Aurangabad', 'Latur', 'Osmanabad', 'Solapur'], 'priority': 2},
        ]
    },
    {
        'name_en': 'Bajra (Pearl Millet)',
        'name_hi': 'बाजरा',
        'name_mr': 'बाजरी',
        'emoji': '🌾',
        'description_en': 'Drought-tolerant cereal crop, mainly Kharif season.',
        'description_hi': 'सूखा-सहिष्णु अनाज फसल, मुख्यतः खरीफ मौसम में।',
        'description_mr': 'दुष्काळ-सहनशील धान्य पीक, मुख्यतः खरीफ हंगामात.',
        'seasons': [
            {'season': 'kharif', 'districts': ['Nashik', 'Pune', 'Solapur', 'Aurangabad', 'Jalgaon'], 'priority': 4},
        ]
    },
]


class Command(BaseCommand):
    help = 'Seed initial crop data into the database'

    def handle(self, *args, **kwargs):
        self.stdout.write('Seeding crop data...')
        created_count = 0
        for crop_info in CROPS_DATA:
            seasons_data = crop_info.pop('seasons')
            crop, created = Crop.objects.get_or_create(
                name_en=crop_info['name_en'],
                defaults=crop_info,
            )
            if created:
                created_count += 1
                self.stdout.write(f'  Created crop: {crop.name_en}')
            else:
                # Update existing
                for k, v in crop_info.items():
                    setattr(crop, k, v)
                crop.save()

            for season_info in seasons_data:
                districts = season_info.pop('districts')
                for district in districts:
                    CropSeason.objects.get_or_create(
                        crop=crop,
                        season=season_info['season'],
                        district=district,
                        defaults={'priority': season_info['priority']},
                    )

        self.stdout.write(self.style.SUCCESS(f'Done! Created {created_count} new crops.'))
