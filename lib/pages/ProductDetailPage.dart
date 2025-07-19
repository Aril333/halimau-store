import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailUserPage extends StatelessWidget {
  final supabase = Supabase.instance.client;

  ProductDetailUserPage({super.key});

  Future<void> addToCart(Map<String, dynamic> product) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar('Gagal', 'Kamu harus login terlebih dahulu');
      return;
    }

    await supabase.from('carts').insert({
      'user_id': user.id,
      'product_id': product['id'],
      'quantity': 1,
    });

    Get.snackbar('Berhasil', 'Produk ditambahkan ke keranjang');
  }

  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Produk")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product['image_url'], height: 200),
            const SizedBox(height: 16),
            Text(
              product['name'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Rp ${product['price']}"),
            const SizedBox(height: 16),
            Text(product['description'] ?? ''),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => addToCart(product),
                    child: const Text('ADD TO BAG'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.snackbar(
                        'Simulasi',
                        'Fitur BELI SEKARANG belum tersedia',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('BUY NOW'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
