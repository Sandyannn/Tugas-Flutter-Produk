import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:produk/models/makanan.dart';
import 'package:produk/models/api.dart';
import 'package:produk/widgets/form.dart'; 
import 'dart:async';

class Create extends StatefulWidget {
  @override
  CreateState createState() => CreateState();
}

class CreateState extends State<Create> {
  final formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();
  TextEditingController fotoController = TextEditingController();
  TextEditingController hargaController = TextEditingController();

  Future createMakanan() async {
    try {
      return await http.post(
        Uri.parse(Api.create),
        body: {
          "nama": namaController.text,
          "detail": detailController.text,
          "kategori": kategoriController.text,
          "foto": fotoController.text,
          "harga": hargaController.text,
        },
      );
    } catch (e) {
      print("Error koneksi: $e");
      return null;
    }
  }

  void _onConfirm(context) async {
    http.Response? response = await createMakanan();

    if (response != null && response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['success'].toString() == "true") {
        print("Simpan Berhasil!");
        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      } else {
        print("Gagal Simpan: ${data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan data!")),
        );
      }
    } else {
      print("Server Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Makanan"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            child: const Text("Simpan Makanan"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _onConfirm(context);
              }
            },
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: AppForm(
              formKey: formKey,
              namaController: namaController,
              detailController: detailController,
              kategoriController: kategoriController,
              fotoController: fotoController,
              hargaController: hargaController,
            ),
          ),
        ),
      ),
    );
  }
}