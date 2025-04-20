import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin/add_data.dart';
import 'auth/auth_controller.dart';
import 'screen/home/home_screen.dart';
import 'screen/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((_) {
    print("✅ Firebase initialized");
  });

  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        return AuthController.to.isLoggedIn.value &&
                AuthController.to.user != null
            ? HomeScreen() //UploadSampleProjectsScreen()
            : LoginScreen();
      }),
    );
  }
}
