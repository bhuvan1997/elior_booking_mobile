class HotelSuggestion {
  final String name;
  final String type;

  HotelSuggestion({
    required this.name,
    required this.type,
  });

  factory HotelSuggestion.fromJson(Map<String, dynamic> json) {
    return HotelSuggestion(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }
}