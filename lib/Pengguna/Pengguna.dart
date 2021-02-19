// import 'package:flutter/foundation.dart';

class Pengguna {
  String id;
  String name;

  Pengguna(this.id, this.name);

  Pengguna.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
  }
}
