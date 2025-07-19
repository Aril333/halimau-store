import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Map<String, dynamic>? product;

  @override
  void initState() {
    super.initState();
    product = Get.arguments;

    if (product != null) {
      _nameController.text = product!['name'] ?? '';
      _priceController.text = product!['price'].toString();
      _descriptionController.text = product!['description'] ?? '';
      _imageUrlController.text = product!['image_url'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final supabase = Supabase.instance.client;

    try {
      await supabase.from('products').update({
        'name': _nameController.text,
        'price': int.parse(_priceController.text),
        'description': _descriptionController.text,
        'image_url': _imageUrlController.text,
      }).eq('id', product!['id']);

      Get.back(result: true); // ⬅️ trigger refresh
      Get.snackbar('Sukses', 'Produk berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Gagal', 'Gagal memperbarui produk');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Produk tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1500C2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Produk',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Nama produk tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga',
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Harga tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'URL Gambar',
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value!.isEmpty ? 'URL Gambar tidak boleh kosong' : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _updateProduct,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Perubahan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
