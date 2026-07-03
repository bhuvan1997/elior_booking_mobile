class HomestaySuggestion {
  String name;
  String type;

  HomestaySuggestion({
    required this.name,
    required this.type,
  });

  factory HomestaySuggestion.fromJson(
      Map<String, dynamic> json,
      ) {
    return HomestaySuggestion(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }
}