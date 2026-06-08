// class HomeStayIdModel {
//   bool? status;
//   String? message;
//   List<Data>? data;
//
//   HomeStayIdModel({this.status, this.message, this.data});
//
//   HomeStayIdModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? propertyName;
//   String? homestayName;
//   int? guestCapacity;
//   int? bedroom;
//   int? beds;
//   int? bathroom;
//   int? pricePerNight;
//   String? description;
//   String? address;
//   String? countryName;
//   String? districtCityName;
//   String? cityname;
//   String? zipcode;
//   String? latitude;
//   String? longitude;
//   String? phone;
//   String? email;
//   String? checkInTime;
//   String? checkOutTime;
//   String? facilities;
//   List<String>? images;
//   String? availability;
//   String? translatedRoomType;
//   String? translatedBeds;
//   String? translatedName;
//   String? translatedDescription;
//   String? translatedAddress;
//   String? translatedCityCountry;
//   String? translatedFacilities;
//   Data(
//       {this.id,
//         this.propertyName,
//         this.homestayName,
//         this.guestCapacity,
//         this.bedroom,
//         this.beds,
//         this.bathroom,
//         this.pricePerNight,
//         this.description,
//         this.address,
//         this.countryName,
//         this.districtCityName,
//         this.cityname,
//         this.zipcode,
//         this.latitude,
//         this.longitude,
//         this.phone,
//         this.email,
//         this.checkInTime,
//         this.checkOutTime,
//         this.facilities,
//         this.images,
//         this.availability});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     propertyName = json['property_name'];
//     homestayName = json['homestay_name'];
//     guestCapacity = json['guest_capacity'];
//     bedroom = json['bedroom'];
//     beds = json['beds'];
//     bathroom = json['bathroom'];
//     pricePerNight = json['price_per_night'];
//     description = json['description'];
//     address = json['address'];
//     countryName = json['country_name'];
//     districtCityName = json['district_city_name'];
//     cityname = json['cityname'];
//     zipcode = json['zipcode'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     phone = json['phone'];
//     email = json['email'];
//     checkInTime = json['check_in_time'];
//     checkOutTime = json['check_out_time'];
//     facilities = json['facilities'];
//     images = json['images'].cast<String>();
//     availability = json['availability'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['property_name'] = this.propertyName;
//     data['homestay_name'] = this.homestayName;
//     data['guest_capacity'] = this.guestCapacity;
//     data['bedroom'] = this.bedroom;
//     data['beds'] = this.beds;
//     data['bathroom'] = this.bathroom;
//     data['price_per_night'] = this.pricePerNight;
//     data['description'] = this.description;
//     data['address'] = this.address;
//     data['country_name'] = this.countryName;
//     data['district_city_name'] = this.districtCityName;
//     data['cityname'] = this.cityname;
//     data['zipcode'] = this.zipcode;
//     data['latitude'] = this.latitude;
//     data['longitude'] = this.longitude;
//     data['phone'] = this.phone;
//     data['email'] = this.email;
//     data['check_in_time'] = this.checkInTime;
//     data['check_out_time'] = this.checkOutTime;
//     data['facilities'] = this.facilities;
//     data['images'] = this.images;
//     data['availability'] = this.availability;
//     return data;
//   }
// }
