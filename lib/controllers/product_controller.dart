import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ProductController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void removeProductById(String id) {
    products.removeWhere((product) => product['id'] == id);
    products.refresh();
  }

  void addProduct(Map<String, dynamic> product) {
    products.add(product);
    products.refresh();
  }

  Future<void> fetchProducts() async {
    final supabase = Supabase.instance.client;
    print('🔥 [fetchProducts] Memanggil Supabase...');
    try {
      final response = await supabase.from('products').select();
      print('✅ [fetchProducts] Data produk terambil: ${response.length}');
      products.value = response;
    } catch (e) {
      print('❌ [fetchProducts] Error: $e');
      Get.snackbar('Error', 'Gagal mengambil data produk');
    }
  }

  void updateProduct(Map<String, dynamic> updatedProduct) {
    final index = products.indexWhere((p) => p['id'] == updatedProduct['id']);
    if (index != -1) {
      products[index] = updatedProduct;
      products.refresh();
    }
  }
}
