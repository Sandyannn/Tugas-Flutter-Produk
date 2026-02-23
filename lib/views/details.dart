import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:produk/models/api.dart';
import 'package:produk/models/makanan.dart';
import 'package:produk/views/edit.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class Details extends StatefulWidget {
  final MakananModel sw;
  Details({required this.sw});

  @override
  DetailsState createState() => DetailsState();
}

class DetailsState extends State<Details> {
  void deleteMakanan(context) async {
    http.Response response = await http.post(
      Uri.parse(Api.delete),
      body: {
        'id': widget.sw.id.toString(),
      },
    );
    final data = json.decode(response.body);
    if (data['success'] == true) {
      pesan();
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    }
  }

  pesan() {
    Fluttertoast.showToast(
        msg: "Data makanan berhasil dihapus",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void confirmDelete(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                'Apakah anda yakin akan menghapus menu ${widget.sw.nama}?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(Icons.cancel),
              ),
              ElevatedButton(
                onPressed: () => deleteMakanan(context),
                child: Icon(Icons.check_circle),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Makanan"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => confirmDelete(context),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.sw.foto,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 100),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sw.nama,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Harga: Rp ${widget.sw.harga}",
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 30),
                  const Text("Kategori:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.sw.kategori,
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  const Text("Deskripsi:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.sw.detail, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Edit(sw: widget.sw),
          ),
        ),
      ),
    );
  }
}
