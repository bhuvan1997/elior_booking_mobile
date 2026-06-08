class RoomAvailableModel {
  bool? status;
  List<Datas>? data;

  RoomAvailableModel({this.status, this.data});

  RoomAvailableModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Datas>[];
      json['data'].forEach((v) {
        data!.add(new Datas.fromJson(v));
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

class Datas {
  int? propertyId;
  String? hotelName;
  String? description;
  String? roomType;
  String? currency;
  int? pricePerNight;
  String? tax;
  int? capacity;
  String? beds;
  String? bedType;
  String? roomSize;
  List<int>? roomsId;
  List<int>? availableRoomId;
  List<String>? facilities;
  List<String>? roomImages;
  String? translatedRoomType;
  String? translatedBeds;
  Datas(
      {this.propertyId,
        this.hotelName,
        this.description,
        this.roomType,
        this.currency,
        this.pricePerNight,
        this.tax,
        this.capacity,
        this.beds,
        this.bedType,
        this.roomSize,
        this.roomsId,
        this.availableRoomId,
        this.facilities,
        this.roomImages});

  Datas.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    hotelName = json['hotel_name'];
    description = json['description'];
    roomType = json['room_type'];
    currency = json['currency'];
    pricePerNight = json['price_per_night'];
    tax = json['tax'];
    capacity = json['capacity'];
    beds = json['beds'];
    bedType = json['bed_type'];
    roomSize = json['room_size'];
    roomsId = json['rooms_id'].cast<int>();
    availableRoomId = json['available_room_id'].cast<int>();
    facilities = json['facilities'].cast<String>();
    roomImages = json['room_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['property_id'] = this.propertyId;
    data['hotel_name'] = this.hotelName;
    data['description'] = this.description;
    data['room_type'] = this.roomType;
    data['currency'] = this.currency;
    data['price_per_night'] = this.pricePerNight;
    data['tax'] = this.tax;
    data['capacity'] = this.capacity;
    data['beds'] = this.beds;
    data['bed_type'] = this.bedType;
    data['room_size'] = this.roomSize;
    data['rooms_id'] = this.roomsId;
    data['available_room_id'] = this.availableRoomId;
    data['facilities'] = this.facilities;
    data['room_images'] = this.roomImages;
    return data;
  }
}
