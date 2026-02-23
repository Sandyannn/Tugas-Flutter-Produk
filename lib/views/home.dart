import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:produk/models/makanan.dart';
import 'package:produk/models/api.dart';
import 'details.dart';
import 'create.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List<MakananModel>> sw;
  final swListKey = GlobalKey<HomeState>();

  @override
  void initState() {
    super.initState();
    sw = getSwList();
  }

  Future<List<MakananModel>> getSwList() async {
    try {
      final response = await http.get(Uri.parse(Api.list));

      print("Status Code: ${response.statusCode}");
      print("Data dari Server: ${response.body}");

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<MakananModel> sw = items.map<MakananModel>((json) {
          return MakananModel.fromJson(json);
        }).toList();
        return sw;
      } else {
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      print("Errornya adalah: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Data Makanan"), 
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FutureBuilder<List<MakananModel>>(
          future: sw,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];

                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), 
                      child: Image.network(
                        data.foto, 
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    trailing: const Icon(Icons.info_outline),
                    title: Text(
                      "${data.kategori} - ${data.nama}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Harga: Rp ${data.harga} \n${data.detail}",
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(
                              sw: data), 
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Create(),
            ),
          );
        },
      ),
    );
  }
}
