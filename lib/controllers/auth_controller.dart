import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final Rxn<User> user = Rxn<User>();
  final RxBool isAuthCheckComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen((firebaseUser) {
      user.value = firebaseUser;
      if (!isAuthCheckComplete.value) {
        isAuthCheckComplete.value = true;
      }
    });
  }
}