import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/image_helper.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final supabase = Supabase.instance.client;

  String? imageUrl;
  Uint8List? pickedFileBytes;
  String? pickedFileName;
  bool isLoading = false;

  Future<void> pickImage() async {
    final picked = await ImageHelper.pickImage();

    if (picked != null) {
      pickedFileBytes = picked.bytes;
      pickedFileName = picked.name;

      final storage = supabase.storage.from(
        'products',
      ); // ✅ Sesuaikan bucket name

      try {
        print(
          '🔄 Mulai upload: $pickedFileName (${pickedFileBytes!.length} bytes)',
        );
        await storage.uploadBinary(
          pickedFileName!,
          pickedFileBytes!,
          fileOptions: const FileOptions(upsert: true),
        );
        print('✅ Upload sukses');

        final url = storage.getPublicUrl(pickedFileName!);
        print('✅ URL Gambar: $url');

        setState(() {
          imageUrl = url;
        });
      } catch (e) {
        print('❌ Upload gagal: $e');
        Get.snackbar('Upload Gagal', 'Gagal mengunggah gambar');
      }
    } else {
      Get.snackbar('Gagal', 'Gagal memilih gambar');
    }
  }

  Future<void> saveProduct() async {
    final name = nameController.text.trim();
    final price = int.tryParse(priceController.text.trim());
    final description = descriptionController.text.trim();

    if (name.isEmpty ||
        price == null ||
        imageUrl == null ||
        description.isEmpty) {
      Get.snackbar('Error', 'Semua field wajib diisi dan gambar harus dipilih');
      return;
    }

    try {
      setState(() => isLoading = true);

      await supabase.from('products').insert({
        'name': name,
        'price': price,
        'image_url': imageUrl,
        'description': description,
      });

      Get.snackbar('Sukses', 'Produk berhasil ditambahkan');
      Get.offAllNamed('/adminDashboard');
    } catch (e) {
      print('❌ Error saat insert: $e');
      Get.snackbar('Gagal', 'Gagal menambahkan produk: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
        backgroundColor: const Color(0xFF1500C2),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pilih Gambar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1500C2),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (imageUrl != null)
                    Expanded(
                      child: Text(
                        imageUrl!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (imageUrl != null)
                Center(
                  child: Image.network(
                    Uri.encodeFull(imageUrl!), // ✅ Penting untuk encode URL
                    height: 150,
                    errorBuilder:
                        (ctx, err, stack) => const Text('Gagal memuat gambar'),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : saveProduct,
                  icon:
                      isLoading
                          ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.save),
                  label: Text(isLoading ? 'Menyimpan...' : 'Simpan Produk'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1500C2),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
