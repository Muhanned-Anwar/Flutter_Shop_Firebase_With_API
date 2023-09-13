class CustomUser {
  String id = '';
  String email = '';
  String password = '';
  String username = '';
  String address = '';
  String birthDate = '';
  String gender = '';
  String phoneNumber = '';
  String documentId = '';
  String profileImage = '';

  CustomUser();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': id,
      'user_name': username,
      'address': address,
      'birth_date': birthDate,
      'gender': gender,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
    };
  }
}
