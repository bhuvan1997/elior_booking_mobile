import 'package:get_storage/get_storage.dart';

class LocalStorages {
  final storage = GetStorage();

  saveName({required String name}) {
    storage.write("name", name);
  }

  String? getName() {
    return storage.read("name");
  }


  saveProfileImage(String image) {
    // Save the file path in storage
    storage.write("profile_image_path", image);
  }

  String? getProfileImage() {
    return storage.read("profile_image_path");
    // No image saved
  }

  String? getToken() {
    return storage.read("kUserToken");
  }

  saveEmail({required String email}) {
    storage.write("kUserEmail", email);
  }
  saveToken({required String token}) {
    storage.write("kUserToken", token);
  }
  void removeToken() {
    storage.remove('kUserToken');
  }

  String? getEmail() {
    return storage.read("kUserEmail");
  }

  saveRegisterNumber({required String registerNumber}) {
    storage.write("registerNumber", registerNumber);
  }

  String? getRegisterNumber() {
    return storage.read("registerNumber");
  }

  savePhoneNumber({required String phoneNumber}) {
    storage.write("phoneNumber", phoneNumber);
  }

  String? getPhoneNumber() {
    return storage.read("phoneNumber");
  }

  saveImage({required String Image}) {
    storage.write("Image", Image);
  }

  String? getImage() {
    return storage.read("Image");
  }

  saveCheckIn({required String checkIn}) {
    storage.write("checkIn", checkIn);
  }

  String? getCheckIn() {
    return storage.read("checkIn");
  }

  saveCheckOut({required String checkOut}) {
    storage.write("checkOut", checkOut);
  }

  String? getCheckOut() {
    return storage.read("checkOut");
  }

  saveRoomAvailable({required int roomAvailable}) {
    storage.write("roomAvailable", roomAvailable);
  }

  int? getRoomAvailable() {
    return storage.read("roomAvailable");
  }

  saveForgotId({required int forgotId}) {
    storage.write("forgotId", forgotId);
  }

  int? getForgotId() {
    return storage.read("forgotId");
  }

  savehotelName({required String hotelName}) {
    storage.write("hotelName", hotelName);
  }

  String? getHotelName() {
    return storage.read("hotelName");
  }

  savehotelAddress({required String hotelAddress}) {
    storage.write("hotelAddress", hotelAddress);
  }

  String? getHotelAddress() {
    return storage.read("hotelAddress");
  }

  saveRoomType({required String RoomTyp}) {
    storage.write("RoomTyp", RoomTyp);
  }

  String? getRoomTyp() {
    return storage.read("RoomTyp");
  }

  saveMobile({required String mobile}) {
    storage.write("mobile", mobile);
  }

  String? getMobile() {
    return storage.read("mobile");
  }

  saveDob({required String dob}) {
    storage.write("dob", dob);
  }

  String? getDob() {
    return storage.read("dob");
  }

  saveAddress({required String address}) {
    storage.write("address", address);
  }

  String? getAddress() {
    return storage.read("address");
  }

  saveMobileCode({required String mobileCode}) {
    storage.write("mobileCode", mobileCode);
  }

  String? getMobileCode() {
    return storage.read("mobileCode");
  }

  saveGender({required String gender}) {
    storage.write("gender", gender);
  }

  String? getGender() {
    return storage.read("gender");
  }

  saveMaritalStatus({required String maritalStatus}) {
    storage.write("maritalStatus", maritalStatus);
  }

  String? getMaritalStatus() {
    return storage.read("maritalStatus");
  }

  savePostalCode({required String postalCode}) {
    storage.write("postalCode", postalCode);
  }

  String? getPostalCode() {
    return storage.read("postalCode");
  }

  savePassportNumber({required String passportNumber}) {
    storage.write("passportNumber", passportNumber);
  }

  String? getPassportNumber() {
    return storage.read("passportNumber");
  }

  saveExpiryDate({required String expiryDate}) {
    storage.write("expiryDate", expiryDate);
  }

  String? getExpiryDate() {
    return storage.read("expiryDate");
  }
  saveBusDate({required String busDate}) {
    storage.write("busDate", busDate);
  }

  String? getBusDate() {
    return storage.read("busDate");
  }
  Future<void> clearAll() async {
    await storage.erase();   // Clears ALL stored data
  }

}
