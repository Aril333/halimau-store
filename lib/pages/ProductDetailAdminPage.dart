import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailAdminPage extends StatelessWidget {
  const ProductDetailAdminPage({super.key});

  Future<void> deleteProduct(String productId) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('products')
          .delete()
          .eq('id', productId);

      print('🗑️ Delete response: $response');

      if (response != null) {
        Get.snackbar('Sukses', 'Produk berhasil dihapus');
        Get.back(result: true); // Trigger fetch di AdminDashboard
      } else {
        Get.snackbar('Gagal', 'Produk tidak ditemukan atau sudah dihapus');
      }
    } catch (e) {
      print('❌ Error saat menghapus produk: $e');
      Get.snackbar('Gagal', 'Terjadi kesalahan saat menghapus produk');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? product = Get.arguments;

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Produk tidak ditemukan")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1500C2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Detail Produk (Admin)',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            product['image_url'] ?? '',
            height: 250,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp ${product['price']}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(product['description'] ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final result = await Get.toNamed(
                    '/editProduct',
                    arguments: product,
                  );
                  if (result == true) {
                    Get.back(result: true); // Refresh Dashboard
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text("UPDATE"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final confirm = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: const Text("Yakin ingin menghapus produk ini?"),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text("Hapus"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await deleteProduct(product['id']);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.delete),
                label: const Text("DELETE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
