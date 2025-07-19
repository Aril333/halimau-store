import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/bottom_nav_bar.dart';

class AdminDashboardPage extends StatelessWidget {
  AdminDashboardPage({super.key});

  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1500C2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Halimau Store (Admin)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/addProduct');
        },
        backgroundColor: Colors.white,
        label: const Text(
          'Tambah Produk',
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(Icons.add, color: Colors.black),
      ),
      body: Obx(() {
        final products = productController.products;

        if (products.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada produk tersedia",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return GestureDetector(
              onTap: () async {
                final result = await Get.toNamed(
                  '/productDetailAdmin',
                  arguments: product,
                );
                if (result == true) {
                  // ⬅️ Refresh setelah kembali dari detail/edit/hapus
                  await productController.fetchProducts();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product['image_url'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Rp ${product['price']}",
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
