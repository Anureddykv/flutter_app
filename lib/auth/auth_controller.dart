import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  RxBool isLoggedIn = false.obs;

  User? get user => firebaseUser.value;

  @override
  void onInit() async {
    super.onInit();
    firebaseUser.bindStream(auth.authStateChanges());

    // Check shared preference
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;

    // If already logged in and Firebase still holds a session
    if (isLoggedIn.value && auth.currentUser != null) {
      firebaseUser.value = auth.currentUser;
    }
  }

  void createUser(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      await _setLoginState(true);
      Get.snackbar('Success', 'Account created');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await _setLoginState(true);
      Get.snackbar('Success', 'Logged in');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void signOut() async {
    await auth.signOut();
    await _setLoginState(false);
    firebaseUser.value = null;
  }

  Future<void> _setLoginState(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
    isLoggedIn.value = status;
  }
}
