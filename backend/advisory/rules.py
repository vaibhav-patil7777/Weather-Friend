"""
Advisory Rule Engine for Mausam Saathi.
Evaluates weather conditions against crop-specific rules and returns advice.
"""

# Built-in rules (used as fallback or when DB is empty)
BUILT_IN_RULES = {
    'Cotton': {
        'en': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'Heavy rain expected. Avoid unnecessary irrigation.',
                    'Check and clear field drainage channels.',
                    'Do not spray pesticides or fertilizers during rainfall.',
                    'Monitor cotton bolls for disease symptoms after rain.',
                ]
            },
            {
                'condition': 'rain_probability',
                'min': 40, 'max': 69,
                'advice': [
                    'Moderate rain expected. Reduce irrigation accordingly.',
                    'Monitor for waterlogging in low-lying areas.',
                    'Plan spraying activities before or after rain.',
                ]
            },
            {
                'condition': 'humidity',
                'min': 80,
                'advice': [
                    'High humidity detected. Monitor for fungal disease symptoms.',
                    'Ensure proper air circulation around cotton plants.',
                    'Watch for signs of boll rot or leaf spot.',
                ]
            },
            {
                'condition': 'wind_speed',
                'min': 20,
                'advice': [
                    'Strong winds expected. Avoid spraying operations.',
                    'Check support structures for tall cotton plants.',
                ]
            },
            {
                'condition': 'temperature',
                'min': 38,
                'advice': [
                    'High temperature alert. Ensure adequate soil moisture.',
                    'Avoid daytime irrigation — prefer early morning or evening.',
                    'Watch for heat stress symptoms on young bolls.',
                ]
            },
            {
                'condition': 'temperature',
                'max': 15,
                'advice': [
                    'Low temperature may slow cotton growth.',
                    'Avoid cold water irrigation during cold nights.',
                ]
            },
        ],
        'hi': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'भारी बारिश की संभावना है। अनावश्यक सिंचाई से बचें।',
                    'खेत की जल निकासी की जाँच करें और साफ रखें।',
                    'बारिश के दौरान कीटनाशक या उर्वरक का छिड़काव न करें।',
                    'बारिश के बाद कपास की गांठों में रोग के लक्षण देखें।',
                ]
            },
            {
                'condition': 'humidity',
                'min': 80,
                'advice': [
                    'उच्च आर्द्रता है। फफूंद रोग के लक्षणों की निगरानी करें।',
                    'कपास के पौधों के आसपास उचित वायु संचार सुनिश्चित करें।',
                ]
            },
            {
                'condition': 'wind_speed',
                'min': 20,
                'advice': [
                    'तेज हवाएं हैं। छिड़काव से बचें।',
                ]
            },
        ],
        'mr': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'मुसळधार पाऊस अपेक्षित. अनावश्यक सिंचन टाळा.',
                    'शेताचे पाण्याचे निचरा नाले तपासा व स्वच्छ करा.',
                    'पावसात कीटकनाशक किंवा खत फवारणी करू नका.',
                    'पावसानंतर कापसाच्या बोंडांमध्ये रोगाची लक्षणे पाहा.',
                ]
            },
            {
                'condition': 'humidity',
                'min': 80,
                'advice': [
                    'उच्च आर्द्रता आहे. बुरशीजन्य रोगाच्या लक्षणांवर लक्ष ठेवा.',
                    'कापसाच्या झाडांभोवती योग्य हवा खेळती ठेवा.',
                ]
            },
            {
                'condition': 'wind_speed',
                'min': 20,
                'advice': [
                    'जोरदार वारे आहेत. फवारणी टाळा.',
                ]
            },
        ],
    },

    'Soybean': {
        'en': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'High rain probability. Avoid unnecessary irrigation.',
                    'Check for standing water — soybean is sensitive to waterlogging.',
                    'Monitor crop after heavy rainfall for disease symptoms.',
                    'Avoid spraying during rainfall.',
                ]
            },
            {
                'condition': 'rain_probability',
                'min': 40, 'max': 69,
                'advice': [
                    'Moderate rain expected. Plan irrigation accordingly.',
                    'Check field drainage before rain.',
                ]
            },
            {
                'condition': 'humidity',
                'min': 80,
                'advice': [
                    'High humidity — watch for yellow mosaic virus symptoms.',
                    'Monitor for pod blight and stem rot in humid conditions.',
                ]
            },
        ],
        'hi': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'भारी बारिश की संभावना। अनावश्यक सिंचाई से बचें।',
                    'खड़े पानी की जाँच करें — सोयाबीन जलजमाव के प्रति संवेदनशील है।',
                    'भारी बारिश के बाद फसल में रोग के लक्षण देखें।',
                ]
            },
            {
                'condition': 'humidity',
                'min': 80,
                'advice': [
                    'उच्च आर्द्रता — पीली चित्तेरी वायरस के लक्षण देखें।',
                ]
            },
        ],
        'mr': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'जास्त पाऊस अपेक्षित. अनावश्यक सिंचन टाळा.',
                    'साचलेले पाणी तपासा — सोयाबीन जलसाचण्यास संवेदनशील आहे.',
                    'मुसळधार पावसानंतर पिकातील रोगाची लक्षणे पाहा.',
                ]
            },
            {
                'condition': 'humidity',
                'min': 80,
                'advice': [
                    'जास्त आर्द्रता — पिवळ्या मोझेक विषाणूची लक्षणे पाहा.',
                ]
            },
        ],
    },

    'Maize': {
        'en': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'Heavy rainfall expected. Check field drainage.',
                    'Avoid irrigation before expected rainfall.',
                    'Monitor plants for waterlogging symptoms.',
                    'Check crop after strong winds — maize can lodge.',
                ]
            },
            {
                'condition': 'wind_speed',
                'min': 30,
                'advice': [
                    'Strong winds can cause maize plants to fall (lodging).',
                    'Avoid tall/top-heavy varieties if strong winds persist.',
                ]
            },
            {
                'condition': 'temperature',
                'min': 38,
                'advice': [
                    'High temperature may affect pollination.',
                    'Ensure adequate irrigation during tasseling and silking stages.',
                ]
            },
        ],
        'hi': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'भारी बारिश की संभावना। खेत की जल निकासी जाँचें।',
                    'बारिश से पहले सिंचाई न करें।',
                    'जलजमाव के लक्षणों के लिए पौधों की निगरानी करें।',
                ]
            },
            {
                'condition': 'wind_speed',
                'min': 30,
                'advice': [
                    'तेज हवाएं मक्का के पौधों को गिरा सकती हैं।',
                ]
            },
        ],
        'mr': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'मुसळधार पाऊस अपेक्षित. शेताचे निचरा तपासा.',
                    'अपेक्षित पावसापूर्वी सिंचन करू नका.',
                    'जलसाचण्याच्या लक्षणांसाठी झाडे तपासा.',
                ]
            },
            {
                'condition': 'wind_speed',
                'min': 30,
                'advice': [
                    'जोरदार वारे मक्याची झाडे पाडू शकतात.',
                ]
            },
        ],
    },

    'Tur (Pigeon Pea)': {
        'en': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'Heavy rain expected. Ensure field drainage is clear.',
                    'Avoid unnecessary irrigation.',
                    'Monitor for waterlogging — tur is sensitive to excess water.',
                    'Check for stem blight symptoms after rain.',
                ]
            },
            {
                'condition': 'humidity',
                'min': 75,
                'advice': [
                    'High humidity — monitor for wilt and leaf spot disease.',
                    'Check plants regularly for disease symptoms.',
                ]
            },
        ],
        'hi': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'भारी बारिश की संभावना। खेत की जल निकासी सुनिश्चित करें।',
                    'अनावश्यक सिंचाई से बचें।',
                    'जलजमाव की निगरानी करें — तुअर अधिक पानी के प्रति संवेदनशील है।',
                ]
            },
            {
                'condition': 'humidity',
                'min': 75,
                'advice': [
                    'उच्च आर्द्रता — रोग के लक्षणों के लिए पौधों की जाँच करें।',
                ]
            },
        ],
        'mr': [
            {
                'condition': 'rain_probability',
                'min': 70,
                'advice': [
                    'मुसळधार पाऊस अपेक्षित. शेताचे निचरा स्वच्छ ठेवा.',
                    'अनावश्यक सिंचन टाळा.',
                    'जलसाचणे तपासा — तूर जास्त पाण्यास संवेदनशील आहे.',
                ]
            },
            {
                'condition': 'humidity',
                'min': 75,
                'advice': [
                    'जास्त आर्द्रता — रोगाच्या लक्षणांसाठी झाडे नियमित तपासा.',
                ]
            },
        ],
    },

    'Wheat': {
        'en': [
            {
                'condition': 'rain_probability',
                'min': 60,
                'advice': [
                    'Rain expected. Avoid irrigation if rain is certain.',
                    'Monitor for rust disease in humid conditions after rain.',
                    'Avoid spraying during rainfall.',
                ]
            },
            {
                'condition': 'temperature',
                'min': 35,
                'advice': [
                    'High temperature may cause premature grain filling.',
                    'Ensure timely irrigation during grain filling stage.',
                    'Monitor crop for heat stress symptoms.',
                ]
            },
        ],
        'hi': [
            {
                'condition': 'rain_probability',
                'min': 60,
                'advice': [
                    'बारिश की संभावना। यदि बारिश निश्चित हो तो सिंचाई न करें।',
                    'बारिश के बाद आर्द्र परिस्थितियों में गेरुआ रोग की निगरानी करें।',
                ]
            },
        ],
        'mr': [
            {
                'condition': 'rain_probability',
                'min': 60,
                'advice': [
                    'पाऊस अपेक्षित. पाऊस नक्की असेल तर सिंचन टाळा.',
                    'पावसानंतर तांबेरा रोगाची निगराणी करा.',
                ]
            },
        ],
    },
}

# Generic fallback advice for unknown crops
GENERIC_RULES = {
    'en': [
        {'condition': 'rain_probability', 'min': 70, 'advice': ['Heavy rain expected. Avoid unnecessary irrigation.', 'Check field drainage.', 'Avoid spraying during rainfall.']},
        {'condition': 'rain_probability', 'min': 40, 'max': 69, 'advice': ['Moderate rain expected. Adjust irrigation accordingly.']},
        {'condition': 'humidity', 'min': 80, 'advice': ['High humidity. Monitor crop for disease symptoms.']},
        {'condition': 'wind_speed', 'min': 25, 'advice': ['Strong winds. Avoid spraying operations.']},
        {'condition': 'temperature', 'min': 38, 'advice': ['High temperature. Ensure adequate soil moisture.']},
    ],
    'hi': [
        {'condition': 'rain_probability', 'min': 70, 'advice': ['भारी बारिश की संभावना। अनावश्यक सिंचाई से बचें।', 'जल निकासी जाँचें।']},
        {'condition': 'humidity', 'min': 80, 'advice': ['उच्च आर्द्रता। फसल में रोग के लक्षण देखें।']},
        {'condition': 'wind_speed', 'min': 25, 'advice': ['तेज हवाएं। छिड़काव से बचें।']},
    ],
    'mr': [
        {'condition': 'rain_probability', 'min': 70, 'advice': ['मुसळधार पाऊस अपेक्षित. अनावश्यक सिंचन टाळा.', 'निचरा तपासा.']},
        {'condition': 'humidity', 'min': 80, 'advice': ['जास्त आर्द्रता. पिकातील रोगाची लक्षणे पाहा.']},
        {'condition': 'wind_speed', 'min': 25, 'advice': ['जोरदार वारे. फवारणी टाळा.']},
    ],
}


def evaluate_rules(crop_name: str, weather: dict, lang: str = 'en') -> list:
    """
    Evaluate weather conditions against crop rules and return advice list.
    
    Args:
        crop_name: English name of crop (e.g. 'Cotton')
        weather: dict with keys: rain_probability, humidity, wind_speed, temperature, cloud_cover
        lang: 'en', 'hi', or 'mr'
    
    Returns:
        List of advice strings
    """
    lang = lang if lang in ['en', 'hi', 'mr'] else 'en'
    rain = weather.get('rain_probability', 0)
    humidity = weather.get('humidity', 0)
    wind = weather.get('wind_speed', 0)
    temp = weather.get('temperature', 25)

    # Get rules for this crop
    crop_rules = BUILT_IN_RULES.get(crop_name, {})
    rules_for_lang = crop_rules.get(lang, GENERIC_RULES.get(lang, GENERIC_RULES['en']))

    advice_list = []
    for rule in rules_for_lang:
        condition = rule['condition']
        min_val = rule.get('min')
        max_val = rule.get('max')

        value_map = {
            'rain_probability': rain,
            'humidity': humidity,
            'wind_speed': wind,
            'temperature': temp,
            'cloud_cover': weather.get('cloud_cover', 0),
        }
        value = value_map.get(condition, 0)

        matched = False
        if min_val is not None and max_val is not None:
            matched = min_val <= value <= max_val
        elif min_val is not None:
            matched = value >= min_val
        elif max_val is not None:
            matched = value <= max_val

        if matched:
            advice_list.extend(rule['advice'])

    # If no rules matched, give generic good weather advice
    if not advice_list:
        good_weather = {
            'en': ['Weather conditions look good for farming activities today.', 'Continue regular crop monitoring.'],
            'hi': ['आज खेती के लिए मौसम की स्थिति अच्छी दिखती है।', 'नियमित फसल निगरानी जारी रखें।'],
            'mr': ['आज शेतीसाठी हवामान परिस्थिती चांगली दिसते.', 'नियमित पीक निगराणी सुरू ठेवा.'],
        }
        advice_list = good_weather.get(lang, good_weather['en'])

    return advice_list


def get_risk_level(weather: dict) -> str:
    """Calculate overall weather risk level."""
    rain = weather.get('rain_probability', 0)
    humidity = weather.get('humidity', 0)
    wind = weather.get('wind_speed', 0)
    temp = weather.get('temperature', 25)

    score = 0
    if rain >= 70:
        score += 3
    elif rain >= 40:
        score += 1

    if humidity >= 80:
        score += 2
    elif humidity >= 70:
        score += 1

    if wind >= 30:
        score += 2
    elif wind >= 20:
        score += 1

    if temp >= 38 or temp <= 10:
        score += 2

    if score >= 5:
        return 'High'
    elif score >= 2:
        return 'Medium'
    else:
        return 'Low'
