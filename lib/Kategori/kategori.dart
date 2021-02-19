// import 'package:flutter/foundation.dart';

class Kategori {
  String id;
  String userid;
  String namaKategori;

  Kategori(this.id, this.userid, this.namaKategori);

  Kategori.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userid = json['user']['name'].toString();
    namaKategori = json['namaKategori'];
  }
}
