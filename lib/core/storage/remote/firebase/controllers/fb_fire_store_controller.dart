import 'package:avatar_course2_5_shop/core/model/custom_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FbFireStoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String tableUsersName = 'Users';

  Future<bool> createUser({required CustomUser customUser}) async {
    return await _firestore
        .collection(
          tableUsersName,
        )
        .add(
          customUser.toMap(),
        )
        .then(
          (value) => true,
        )
        .catchError(
          (error) => false,
        );
  }
}
