class CropItem {
  final int id;
  final String name;
  final String nameEn;
  final String emoji;
  final String description;

  CropItem({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.emoji,
    required this.description,
  });

  factory CropItem.fromJson(Map<String, dynamic> json) {
    return CropItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? '',
      emoji: json['emoji'] ?? '🌱',
      description: json['description'] ?? '',
    );
  }
}

class CropsResponse {
  final String season;
  final String seasonDisplay;
  final String district;
  final List<CropItem> crops;

  CropsResponse({
    required this.season,
    required this.seasonDisplay,
    required this.district,
    required this.crops,
  });

  factory CropsResponse.fromJson(Map<String, dynamic> json) {
    return CropsResponse(
      season: json['season'] ?? '',
      seasonDisplay: json['season_display'] ?? '',
      district: json['district'] ?? '',
      crops: (json['crops'] as List? ?? [])
          .map((c) => CropItem.fromJson(c))
          .toList(),
    );
  }
}

class AdvisoryResponse {
  final String crop;
  final String risk;
  final String riskDisplay;
  final List<String> advice;

  AdvisoryResponse({
    required this.crop,
    required this.risk,
    required this.riskDisplay,
    required this.advice,
  });

  factory AdvisoryResponse.fromJson(Map<String, dynamic> json) {
    return AdvisoryResponse(
      crop: json['crop'] ?? '',
      risk: json['risk'] ?? 'Low',
      riskDisplay: json['risk_display'] ?? '',
      advice: (json['advice'] as List? ?? []).map((a) => a.toString()).toList(),
    );
  }
}
