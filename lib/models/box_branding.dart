class BoxBranding {
  final String boxName;
  final String logoUrl;
  final String primaryColor; // Branding Hex String
  final String secondaryColor; // Branding Hex String

  BoxBranding({
    required this.boxName,
    required this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
  });

  // Factory constructor for creating a new BoxBranding instance from a map.
  factory BoxBranding.fromJson(Map<String, dynamic> json) {
    return BoxBranding(
      boxName: json['boxName'] as String? ?? 'Box App',
      logoUrl: json['logoUrl'] as String? ?? '',
      primaryColor: json['primaryColor'] as String? ?? '#2196F3', // Default Blue
      secondaryColor: json['secondaryColor'] as String? ?? '#FFC107', // Default Amber
    );
  }

  // Method for converting a BoxBranding instance to a map.
  Map<String, dynamic> toJson() {
    return {
      'boxName': boxName,
      'logoUrl': logoUrl,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }

  // Default "Neutral" Branding
  factory BoxBranding.defaultBranding() {
    return BoxBranding(
      boxName: 'Box App',
      logoUrl: '',
      primaryColor: '#607D8B', // Neutral Grey
      secondaryColor: '#FF5722', // Deep Orange Accent
    );
  }
}
