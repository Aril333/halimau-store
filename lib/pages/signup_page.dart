import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final supabase = Supabase.instance.client;

    return Scaffold(
      backgroundColor: const Color(0xFF1500C2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image.png', height: 120),
                const SizedBox(height: 24),

                // Email
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Password
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Confirm Password
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign Up Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final pass = passwordController.text;
                    final confirm = confirmPasswordController.text;

                    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
                      Get.snackbar('Error', 'Semua field wajib diisi');
                      return;
                    }

                    if (pass != confirm) {
                      Get.snackbar('Error', 'Password tidak cocok');
                      return;
                    }

                    try {
                      final response = await supabase.auth.signUp(
                        email: email,
                        password: pass,
                      );

                      final user = response.user;

                      if (user == null) {
                        Get.snackbar(
                          'Signup Gagal',
                          'User belum terverifikasi',
                        );
                        return;
                      }

                      await supabase.from('profiles').insert({
                        'id': user.id,
                        'username': email,
                        'role': 'user',
                      });

                      Get.offAllNamed('/dashboard');
                    } catch (e) {
                      Get.snackbar('Signup Gagal', e.toString());
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 12,
                    ),
                    child: Text("Sign up"),
                  ),
                ),

                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Get.toNamed('/login'),
                  child: const Text(
                    "Sudah punya akun? Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("or", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: Image.asset('assets/pngwing.com (4).png', height: 18),
                  label: const Text("Lanjutkan dengan Google"),
                  onPressed: () {
                    // Optional: Implement Google Sign-in
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
