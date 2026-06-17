class HomestaySuggestionResponse {
  List<HomestaySuggestion>? suggestions;

  HomestaySuggestionResponse({
    this.suggestions,
  });

  HomestaySuggestionResponse.fromJson(dynamic json) {
    if (json is List) {
      suggestions = json.map((item) => HomestaySuggestion.fromJson(item)).toList();
    } else {
      suggestions = [];
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (suggestions != null) {
      map['suggestions'] = suggestions!.map((item) => item.toJson()).toList();
    }
    return map;
  }
}

class HomestaySuggestion {
  String? name;
  String? type;

  HomestaySuggestion({
    this.name,
    this.type,
  });

  HomestaySuggestion.fromJson(dynamic json) {
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['type'] = type;
    return map;
  }
}