import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi data kosong. Nanti bisa diisi dari state/database
    final cartItems = <Map<String, dynamic>>[]; // List kosong dulu

    return Scaffold(
      backgroundColor: const Color(0xFF1500C2),
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Keranjang kamu kosong',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Image.network(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name']),
                    subtitle: Text("Rp ${item['price']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Tambahkan aksi hapus item dari keranjang
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
