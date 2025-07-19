import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'routes.dart';
import 'auth/auth_controller.dart';
import 'controllers/product_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cgxklqbylmbbjkmgjbtf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNneGtscWJ5bG1iYmprbWdqYnRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAwNDI2ODQsImV4cCI6MjA2NTYxODY4NH0.1Bqxr63mxKJYQAiwkehWc1xr2XVurmwzK_clRx2iAwY',
  );
  Get.put(AuthController());
  Get.put(ProductController()); // inisialisasi hanya satu kali

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: AppRoutes.pages,
    );
  }
}
