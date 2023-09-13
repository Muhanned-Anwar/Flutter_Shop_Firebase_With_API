import 'package:avatar_course2_5_shop/core/model/custom_user.dart';
import 'package:avatar_course2_5_shop/core/widgets/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_state_render_dialog/flutter_state_render_dialog.dart';
import 'package:get/get.dart';

class FbAuthController with Helpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> register({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        CustomUser customUser = CustomUser();
        customUser.id = user.uid;
        customUser.email = email;
        customUser.password = password;
        customUser.username = name;
      }

      user?.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (exception) {
      _controlException(exception);
    } catch (exception) {
      dialogRender(
        context: Get.context!,
        stateRenderType: StateRenderType.popUpErrorState,
        message: 'Unknown error',
        title: '',
        retryAction: () {
          Get.back();
        },
      );
    }

    return false;
  }

  _controlException(
    FirebaseAuthException exception,
  ) {
    String error = '';
    switch (exception.code) {
      case 'wrong-password':
        error = 'Wrong password';
        break;
      case 'user-not-found':
        error = 'User not found';
        break;
      case 'network-request-failed':
        error = 'Network request failed';
        break;
      case 'user-disabled':
        error = 'User disabled';
        break;
      case 'invalid-email':
        error = 'Invalid email';
        break;
      case 'email-already-in-use':
        error = 'Email already in use';
        break;
      default:
        error = 'Unknown error';
    }

    dialogRender(
        context: Get.context!,
        stateRenderType: StateRenderType.popUpErrorState,
        message: error,
        title: '',
        retryAction: () {
          Get.back();
        });
  }
}
