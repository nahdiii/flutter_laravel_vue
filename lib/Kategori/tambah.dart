import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_laravel_vue/Api/api.dart';
import 'package:flutter_laravel_vue/Beranda/Home.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class TambahKategori extends StatefulWidget {
  TambahKategori({Key key}) : super(key: key);

  @override
  _TambahKategoriState createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<TambahKategori> {
  // TextEditingController userid = new TextEditingController();
  TextEditingController namaKategori = new TextEditingController();

//menampilkan data user kedalam DropdownButton
  String userid;

  List data = List(); //edited line
  Future<String> getSWData() async {
    var res = await CallApi().getData('pengguna');
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody;
    });
    // print(resBody);
    // return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }
// akhir koding utk menampilkan data user kedalam DropdownButton

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Kategori"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
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
                      this._postKategori();
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

  Future _postKategori() async {
    if (userid.isEmpty || namaKategori.text.isEmpty) {
      Alert(context: context, title: "Data Masih Kosong", type: AlertType.error)
          .show();
      return;
    }

    // Untuk Android
    // var url = 'http://192.168.100.8:8000/api/kategoris';

    var data = {
      'user_id': userid,
      'namaKategori': namaKategori.text,
    };
    var response = await CallApi().postData(data, 'kategoris');

    if (response.statusCode == 201) {
      Alert(context: context, title: "Sukses", type: AlertType.success).show();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      Alert(context: context, title: "Gagal", type: AlertType.error).show();
    }
  }
}
