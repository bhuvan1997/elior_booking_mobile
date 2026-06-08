class AccomendationModel {
  bool? status;
  List<Data>? data;

  AccomendationModel({this.status, this.data});

  AccomendationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? propertyId;
  String? homestayName;
  String? accomodationName;
  String? currency;
  int? pricePerNight;
  String? tax;
  int? guest;
  int? bedroom;
  int? beds;
  int? bathroom;
  List<int>? accomodationId;
  List<int>? availableAccomodationId;
  List<String>? images;

  Data(
      {this.propertyId,
        this.homestayName,
        this.accomodationName,
        this.currency,
        this.pricePerNight,
        this.tax,
        this.guest,
        this.bedroom,
        this.beds,
        this.bathroom,
        this.accomodationId,
        this.availableAccomodationId,
        this.images});

  Data.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    homestayName = json['homestay_name'];
    accomodationName = json['accomodation_name'];
    currency = json['currency'];
    pricePerNight = json['price_per_night'];
    tax = json['tax'];
    guest = json['guest'];
    bedroom = json['bedroom'];
    beds = json['beds'];
    bathroom = json['bathroom'];
    accomodationId = json['accomodation_id'].cast<int>();
    availableAccomodationId = json['available_accomodation_id'].cast<int>();
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['homestay_name'] = this.homestayName;
    data['accomodation_name'] = this.accomodationName;
    data['currency'] = this.currency;
    data['price_per_night'] = this.pricePerNight;
    data['tax'] = this.tax;
    data['guest'] = this.guest;
    data['bedroom'] = this.bedroom;
    data['beds'] = this.beds;
    data['bathroom'] = this.bathroom;
    data['accomodation_id'] = this.accomodationId;
    data['available_accomodation_id'] = this.availableAccomodationId;
    data['images'] = this.images;
    return data;
  }
}
