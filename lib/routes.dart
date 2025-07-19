import 'package:get/get.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/profile_page.dart';
import 'pages/cart_page.dart';
import 'pages/admin_dashboard_page.dart';
import 'pages/add_product_page.dart';
import 'pages/ProductDetailPage.dart';
import 'pages/ProductDetailAdminPage.dart';
import 'pages/EditProductPage.dart';

// ✅ kalau kamu sudah punya
// Bisa tambah halaman lain seperti tambah produk, dll

class AppRoutes {
  static final pages = [
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/signup', page: () => const SignupPage()),
    GetPage(name: '/dashboard', page: () => const DashboardPage()),
    GetPage(name: '/profile', page: () => const ProfilePage()),
    GetPage(name: '/cart', page: () => const CartPage()), // ✅ Tambahan
    GetPage(name: '/adminDashboard', page: () => AdminDashboardPage()),
    GetPage(
      name: '/addProduct',
      page: () => const AddProductPage(),
    ), // ✅ Jika admin dibedakan
    GetPage(name: '/productDetailPage', page: () => ProductDetailUserPage()),
    GetPage(
      name: '/productDetailAdmin',
      page: () => const ProductDetailAdminPage(),
    ),
    GetPage(name: '/editProduct', page: () => const EditProductPage()),
  ];
}
