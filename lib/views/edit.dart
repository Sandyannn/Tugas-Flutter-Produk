import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:produk/models/makanan.dart';
import 'package:produk/models/api.dart';
import 'package:produk/widgets/form.dart';

class Edit extends StatefulWidget {
  final MakananModel sw; 

  Edit({required this.sw});

  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController namaController, detailController, kategoriController,
      fotoController, hargaController;

  Future editMakanan() async {
    return await http.post(
      Uri.parse(Api.update), 
      body: {
        "id": widget.sw.id.toString(),
        "nama": namaController.text,
        "detail": detailController.text,
        "kategori": kategoriController.text,
        "foto": fotoController.text,
        "harga": hargaController.text,
      },
    );
  }

  pesan() {
    Fluttertoast.showToast(
      msg: "Perubahan Menu Berhasil disimpan",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
  }

  void _onConfirm(context) async {
    http.Response response = await editMakanan();
    final data = json.decode(response.body);
    if (data['success'] == true) {
      pesan();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    namaController = TextEditingController(text: widget.sw.nama);
    detailController = TextEditingController(text: widget.sw.detail);
    kategoriController = TextEditingController(text: widget.sw.kategori);
    fotoController = TextEditingController(text: widget.sw.foto);
    hargaController = TextEditingController(text: widget.sw.harga);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Menu ${widget.sw.nama}"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          child: Text("Update Menu"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.orange,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _onConfirm(context);
            }
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
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
    );
  }
}