class FilterModel {
  bool? status;
  String? message;
  List<String>? allFeatures;
  List<String>? allRules;
  StarRating? starRating;
  Pricing? pricing;
  Sorting? sorting;

  FilterModel(
      {this.status,
        this.message,
        this.allFeatures,
        this.allRules,
        this.starRating,
        this.pricing,
        this.sorting});

  FilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    allFeatures = json['allFeatures'].cast<String>();
    allRules = json['allRules'].cast<String>();
    starRating = json['starRating'] != null
        ? new StarRating.fromJson(json['starRating'])
        : null;
    pricing =
    json['pricing'] != null ? new Pricing.fromJson(json['pricing']) : null;
    sorting =
    json['sorting'] != null ? new Sorting.fromJson(json['sorting']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['allFeatures'] = this.allFeatures;
    data['allRules'] = this.allRules;
    if (this.starRating != null) {
      data['starRating'] = this.starRating!.toJson();
    }
    if (this.pricing != null) {
      data['pricing'] = this.pricing!.toJson();
    }
    if (this.sorting != null) {
      data['sorting'] = this.sorting!.toJson();
    }
    return data;
  }
}

class StarRating {
  int? i1Star;
  int? i2Star;
  int? i3Star;
  int? i4Star;
  int? i5Star;

  StarRating({this.i1Star, this.i2Star, this.i3Star, this.i4Star, this.i5Star});

  StarRating.fromJson(Map<String, dynamic> json) {
    i1Star = json['1 Star'];
    i2Star = json['2 Star'];
    i3Star = json['3 Star'];
    i4Star = json['4 Star'];
    i5Star = json['5 Star'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1 Star'] = this.i1Star;
    data['2 Star'] = this.i2Star;
    data['3 Star'] = this.i3Star;
    data['4 Star'] = this.i4Star;
    data['5 Star'] = this.i5Star;
    return data;
  }
}

class Pricing {
  String? s0To500;
  String? s500To1000;
  String? s1000To1500;
  String? s1500To2500;
  String? s2500To3000;
  String? s3000To3500;
  String? s3500To7500;
  String? s7500To11500;
  String? s11500To15000;
  String? s15000To30000;

  Pricing(
      {
        this.s0To500,
        this.s500To1000,
        this.s1000To1500,
        this.s1500To2500,
        this.s2500To3000,
        this.s3000To3500,
        this.s3500To7500,
        this.s7500To11500,
        this.s11500To15000,
        this.s15000To30000

      });

  Pricing.fromJson(Map<String, dynamic> json) {
    s0To500 = json['0 to 500'];
    s500To1000 = json['500 to 1000'];
    s1000To1500 = json['1000 to 1500'];
    s1500To2500 = json['1500 to 2500'];
    s2500To3000 = json['2500 to 3000'];
    s3000To3500 = json['3000 to 3500'];
    s3500To7500 = json['3500 to 7500'];
    s7500To11500 = json['7500 to 11500'];
    s11500To15000 = json['11500 to 15000'];
    s15000To30000 = json['15000 to 30000'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0 to 500'] = this.s0To500;
    data['500 to 1000'] = this.s500To1000;
    data['1000 to 1500'] = this.s1000To1500;
    data['1500 to 2500'] = this.s1500To2500;
    data['2500 to 3000'] = this.s2500To3000;
    data['3000 to 3500'] = this.s3000To3500;
    data['3500 to 7500'] = this.s3500To7500;
    data['7500 to 11500'] = this.s7500To11500;
    data['11500 to 15000'] = this.s11500To15000;
    data['15000 to 30000'] = this.s15000To30000;
    return data;
  }
}

class Sorting {

  String? priceLowToHigh;
  String? priceHighToLow;
  String? ratingHighToLow;
  String? ratingLowToHigh;

  Sorting({
    this.priceLowToHigh,
    this.priceHighToLow,
    this.ratingHighToLow,
    this.ratingLowToHigh,

  });

  Sorting.fromJson(Map<String, dynamic> json) {

    priceLowToHigh = json['Price: Low to High']?.toString();
    priceHighToLow = json['Price: High to Low']?.toString();
    ratingHighToLow = json['Rating: High to Low']?.toString();
    ratingLowToHigh = json['Rating: Low to High']?.toString();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // ✅ Only include fields that actually exist or are used
    if (priceLowToHigh != null) data['Price: Low to High'] = priceLowToHigh;
    if (priceHighToLow != null) data['Price: High to Low'] = priceHighToLow;
    if (ratingHighToLow != null) data['Rating: High to Low'] = ratingHighToLow;
    if (ratingLowToHigh != null) data['Rating: Low to High'] = ratingLowToHigh;

    return data;
  }
}
