import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class Listagem extends StatefulWidget {
  @override
  _ListagemState createState() => _ListagemState();
}

class _ListagemState extends State<Listagem> {
  List _reservas = [];

  Future<File> _getFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return File(appDocPath + '/reservas.json');
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (error) {
      print('Erro na leitura do arquivo ${error.toString()}');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _readData().then((value) => {
          setState(() {
            _reservas = json.decode(value);
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tabela"),
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
            itemCount: _reservas.length,
            itemBuilder: (context, index) {
              return Table(
                border: TableBorder.all(
                    color: Colors.black26, width: 1, style: BorderStyle.solid),
                children: [
                  TableRow(
                    children: <Widget>[
                      Expanded(
                          child: TableCell(
                              child: Text(
                        _reservas[index]["nome"].toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontFamily: "Arial",
                            fontWeight: FontWeight.bold),
                      ))),
                      /*
                      TableCell(
                          child: Text(
                        _reservas[index]["reservado"].toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontFamily: "Arial",
                            fontWeight: FontWeight.bold),
                      )),*/
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

//The method '>' was called on null.
// Receiver: null
// Tried calling: >(1e-10)
