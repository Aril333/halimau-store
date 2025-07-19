import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient client = Supabase.instance.client;

  // ✅ Tambahkan RxString dengan nilai awal kosong
  var userRole = ''.obs;

  Future<void> login(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) throw 'Login gagal';

      // Ambil role dari tabel profiles
      final profile = await client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();

      final role = profile['role'];

      // ✅ Simpan role ke dalam userRole
      userRole.value = role;

      // Navigasi berdasarkan role
      if (role == 'admin') {
        Get.offAllNamed('/adminDashboard');
      } else {
        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString());
    }
  }

  Future<void> logout() async {
    await client.auth.signOut();
    userRole.value = ''; // reset
    Get.offAllNamed('/login');
  }
}
