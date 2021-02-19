import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_laravel_vue/Api/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_laravel_vue/kate.dart';

class EditKategori extends StatefulWidget {
  final String var_idKategori;
  EditKategori({Key key, this.var_idKategori}) : super(key: key);

  @override
  _EditKategoriState createState() => _EditKategoriState();
}

class _EditKategoriState extends State<EditKategori> {
  TextEditingController id = new TextEditingController();

  TextEditingController namaKategori = new TextEditingController();

  // var _kategoris = List();
  Future fetchKategoris() async {
    // Untuk Android
    var id = "${widget.var_idKategori}";
    // var url = 'http://192.168.100.8:8000/api/kategoris'+ id;
    // var url = 'http://laravel-vue-flutter.test/api/kategoris/' + id;
    var response = await CallApi().getData('kategoris/' + id);
    var isiKategori = json.decode(response.body);

    // if (response.statusCode == 200) {
    //   Alert(context: context, title: "Sukses", type: AlertType.success).show();
    // } else {
    //   Alert(context: context, title: "Gagal", type: AlertType.error).show();
    // }
    return isiKategori;
  }

//menampilkan data user kedalam DropdownButton

  // final String url = "http://laravel-vue-flutter.test/api/pengguna/";
  List data = List(); //edited line
  Future<String> getSWData() async {
    // var res = await http
    //     .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var res = await CallApi().getData('pengguna');
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });
    // print(resBody);
    // return "Sucess";
  }

  String userid;
// akhir koding utk menampilkan data user kedalam DropdownButton

  @override
  void initState() {
    fetchKategoris().then((isiKategori) {
      setState(() {
        print("${widget.var_idKategori}");
        id.text = isiKategori['id'].toString();
        //menampilkan nama user hasil relasi.
        // userid.text = isiKategori['user']['name'].toString();
        // menampilkan id nya saja
        userid = isiKategori['user_id'].toString();
        namaKategori.text = isiKategori['namaKategori'];
      });
      print(userid);
    });
    super.initState();
    //biar data user tampil di DropdownButton
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Kategori"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: id,
                  decoration: InputDecoration(hintText: "Id"),
                ),
                // TextFormField(
                //   controller: userid,
                //   decoration: InputDecoration(hintText: "User Id"),
                // ),
                new DropdownButton(
                  isExpanded:
                      true, //biar tampillan DropdownButton mengikuti lebar layar HP
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  items: data.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(item['name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),
                  hint: new Text("Pilih User"),
                  onChanged: (newVal) {
                    setState(() {
                      userid = newVal;
                    });
                  },
                  value: userid,
                ),
                TextFormField(
                  controller: namaKategori,
                  decoration: InputDecoration(hintText: "Nama Kategori"),
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      this._putKategori();
                    },
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future _putKategori() async {
    if (userid.isEmpty || namaKategori.text.isEmpty) {
      Alert(context: context, title: "Data Masih Kosong", type: AlertType.error)
          .show();
      return;
    }

    var id = "${widget.var_idKategori}";
    // Untuk Android
    // var url = 'http://192.168.100.8:8000/api/kategoris'+ id;
    // var url = 'http://laravel-vue-flutter.test/api/kategoris/' + id;
    // final response = await http.put(url,
    //     body: {'user_id': userid, 'namaKategori': namaKategori.text},
    //     headers: {'Accept': 'application/json'});
    var data = {
      'user_id': userid,
      'namaKategori': namaKategori.text,
    };
    var response = await CallApi().putData(data, 'kategoris/' + id);
    if (response.statusCode == 200) {
      Alert(context: context, title: "Sukses", type: AlertType.success).show();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShowKategori()),
      );
    } else {
      Alert(context: context, title: "Gagal", type: AlertType.error).show();
    }
  }
}
