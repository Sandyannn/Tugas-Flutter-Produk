class MakananModel {
  final int id;
  final String nama;
  final String detail;
  final String kategori;
  final String foto;
  final String harga;

  MakananModel({
    required this.id,
    required this.nama,
    required this.detail,
    required this.kategori,
    required this.foto,
    required this.harga,
  });

  factory MakananModel.fromJson(Map<String, dynamic> json) {
    return MakananModel(
      id: json['id'],
      nama: json['nama'],
      detail: json['detail'],
      kategori: json['kategori'],
      foto: json['foto'],
      harga: json['harga'].toString(), 
    );
  }

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'detail': detail,
        'kategori': kategori,
        'foto': foto,
        'harga': harga,
      };
}
