import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AppForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController namaController,
      detailController,
      kategoriController,
      fotoController,
      hargaController;

  AppForm({
    required this.formKey,
    required this.namaController,
    required this.detailController,
    required this.kategoriController,
    required this.fotoController,
    required this.hargaController,
  });

  @override
  AppFormState createState() => AppFormState();
}

class AppFormState extends State<AppForm> {
  final List<String> kategoriItems = [
    "",
    "Makanan Berat",
    "Minuman",
    "Cemilan",
    "Dessert",
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          txtNama(),
          const SizedBox(height: 15),
          txtHarga(),
          const SizedBox(height: 15),
          tbKategori(),
          const SizedBox(height: 15),
          txtDetail(),
          const SizedBox(height: 15),
          txtFoto(),
        ],
      ),
    );
  }

  txtNama() {
    return TextFormField(
      controller: widget.namaController,
      decoration: InputDecoration(
        labelText: "Nama Menu",
        prefixIcon: const Icon(Icons.fastfood),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) => value!.isEmpty ? 'Masukkan Nama Menu' : null,
    );
  }

  txtHarga() {
    return TextFormField(
      controller: widget.hargaController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Harga",
        prefixIcon: const Icon(Icons.money),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) => value!.isEmpty ? 'Masukkan Harga' : null,
    );
  }

  tbKategori() {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        labelText: "Kategori",
        prefixIcon: const Icon(Icons.category),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      value: widget.kategoriController.text.isNotEmpty
          ? widget.kategoriController.text
          : null,
      items: kategoriItems
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          widget.kategoriController.text = value.toString();
        });
      },
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Pilih Kategori' : null,
    );
  }

  txtDetail() {
    return TextFormField(
      controller: widget.detailController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Detail Menu",
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) => value!.isEmpty ? 'Masukkan Detail Menu' : null,
    );
  }

  txtFoto() {
    return TextFormField(
      controller: widget.fotoController,
      decoration: InputDecoration(
        labelText: "URL Foto Menu",
        prefixIcon: const Icon(Icons.image),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      validator: (value) => value!.isEmpty ? 'Masukkan URL Foto' : null,
    );
  }
}
