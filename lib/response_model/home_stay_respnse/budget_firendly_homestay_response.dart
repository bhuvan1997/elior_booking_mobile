// class BudgetFriendlyHomestaysResponse {
//   final bool? status;
//   final String? message;
//   final List<Property>? data;
//
//   BudgetFriendlyHomestaysResponse({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory BudgetFriendlyHomestaysResponse.fromJson(
//       Map<String, dynamic> json) {
//     return BudgetFriendlyHomestaysResponse(
//       status: json['status'],
//       message: json['message'],
//       data: json['data'] != null
//           ? (json['data'] as List)
//           .map((e) => Property.fromJson(e))
//           .toList()
//           : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'message': message,
//       'data': data?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class Property {
//   final int? id;
//   final String? name;
//   final String? description;
//   final String? address;
//   final String? city;
//   final String? state;
//   final String? country;
//   final String? zipcode;
//   final int? starRating;
//   final String? currency;
//   final int? pricePerNight;
//   final String? checkInTime;
//   final String? checkOutTime;
//   final List<String>? images;
//
//   Property({
//     this.id,
//     this.name,
//     this.description,
//     this.address,
//     this.city,
//     this.state,
//     this.country,
//     this.zipcode,
//     this.starRating,
//     this.currency,
//     this.pricePerNight,
//     this.checkInTime,
//     this.checkOutTime,
//     this.images,
//   });
//
//   factory Property.fromJson(Map<String, dynamic> json) {
//     return Property(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       address: json['address'],
//       city: json['city'],
//       state: json['state'],
//       country: json['country'],
//       zipcode: json['zipcode'],
//       starRating: json['star_rating'],
//       currency: json['currency'],
//       pricePerNight: json['price_per_night'],
//       checkInTime: json['check_in_time'],
//       checkOutTime: json['check_out_time'],
//       images: json['images'] != null
//           ? List<String>.from(json['images'])
//           : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'address': address,
//       'city': city,
//       'state': state,
//       'country': country,
//       'zipcode': zipcode,
//       'star_rating': starRating,
//       'currency': currency,
//       'price_per_night': pricePerNight,
//       'check_in_time': checkInTime,
//       'check_out_time': checkOutTime,
//       'images': images,
//     };
//   }
// }