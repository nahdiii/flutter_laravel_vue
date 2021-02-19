import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_laravel_vue/Api/api.dart';
import 'package:flutter_laravel_vue/Kategori/kategori.dart';
import 'package:flutter_laravel_vue/Kategori/edit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShowKategori extends StatefulWidget {
  ShowKategori({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ShowKategoriState createState() => _ShowKategoriState();
}

class _ShowKategoriState extends State<ShowKategori> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  List<Kategori> _kategoris = List<Kategori>();

  Future<List<Kategori>> fetchKategoris() async {
    // Untuk Android
    // var url = 'http://192.168.100.8:8000/api/kategoris';
    // var url = 'http://laravel-vue-flutter.test/api/kategoris/';

    // var response = await http.get(url, headers: {
    //   'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer $token',
    // });
    var response = await CallApi().getData('kategoris');

    // print(json.decode(response.body));

    // var response = await http.get(url);
    var kategoris = List<Kategori>();
    if (response.statusCode == 200) {
      var kategorisJson = json.decode(response.body);

      for (var kategoriJson in kategorisJson) {
        kategoris.add(Kategori.fromJson(kategoriJson));
      }
    }
    return kategoris;
  }

  @override
  void initState() {
    fetchKategoris().then((value) {
      setState(() {
        _kategoris.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test API Laravel ke Flutter'),
      ),
      body: new RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 32, bottom: 32, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _kategoris[index].id,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      _kategoris[index].namaKategori,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Upload by " + _kategoris[index].userid,
                      style:
                          TextStyle(fontSize: 15, color: Colors.grey.shade600),
                    ),
                    ButtonTheme(
                      minWidth: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          var route = new MaterialPageRoute(
                            builder: (BuildContext context) => new EditKategori(
                                var_idKategori: _kategoris[index].id),
                          );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           EditKategori(value: _kategoris[index].id)),
                          // );
                          // print(_kategoris[index].id);
                          Navigator.of(context).push(route);
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: double.infinity,
                      child: RaisedButton(
                        onPressed: () async {
                          // DELETE
                          // var url = 'http://192.168.100.8:8000/api/kategoris/' +
                          //     _kategoris[index].id;

                          final response = await CallApi()
                              .deleteData('kategoris/' + _kategoris[index].id);
                          if (response.statusCode == 200) {
                            Alert(
                                    context: context,
                                    title: "Sukses",
                                    type: AlertType.success)
                                .show();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => Home()),
                            // );

                          } else {
                            Alert(
                                    context: context,
                                    title: "Gagal",
                                    type: AlertType.error)
                                .show();
                          }
                        },
                        child: Text(
                          "Hapus",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: _kategoris.length,
        ),
        onRefresh: _handleRefresh,
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    setState(() {
      fetchKategoris().then((value) {
        setState(() {
          _kategoris.clear();
          _kategoris.addAll(value);
        });
      });
      super.initState();
    });
    // return null;
  }
}
