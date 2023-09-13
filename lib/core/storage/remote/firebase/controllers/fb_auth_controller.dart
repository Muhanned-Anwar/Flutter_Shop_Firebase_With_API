import 'dart:async';

import 'package:avatar_course2_5_shop/core/model/custom_user.dart';
import 'package:avatar_course2_5_shop/core/storage/remote/firebase/controllers/fb_fire_store_controller.dart';
import 'package:avatar_course2_5_shop/core/widgets/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_state_render_dialog/flutter_state_render_dialog.dart';
import 'package:get/get.dart';

typedef UserAuthStatus = void Function({required bool loggedIn});

class FbAuthController with Helpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FbFireStoreController _fbFireStoreController = FbFireStoreController();

  StreamSubscription<User?> checkUserStatus(UserAuthStatus userAuthStatus) {
    return _firebaseAuth.authStateChanges().listen((event) {
      userAuthStatus(loggedIn: event != null);
    });
  }

  Future<bool> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          User? user = _firebaseAuth.currentUser;
          if (user != null) {}
          return true;
        } else {
          userCredential.user?.sendEmailVerification();
          await logout();
          showSnackBar(context: context, message: 'verifyEmail', error: true);
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (exception) {
      _controlException(exception);
    } catch (exception) {
      //
    }

    return false;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  bool loggedIn() => _firebaseAuth.currentUser != null;

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

        bool storedUserInFireStore = await _fbFireStoreController.createUser(customUser: customUser);
        if(storedUserInFireStore){
          dialogRender(
            context: Get.context!,
            stateRenderType: StateRenderType.popUpSuccessState,
            message: 'Success',
            title: '',
            retryAction: () {
              Get.back();
            },
          );
        }else{
          dialogRender(
            context: Get.context!,
            stateRenderType: StateRenderType.popUpErrorState,
            message: 'Failed',
            title: '',
            retryAction: () {
              Get.back();
            },
          );
        }
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
