import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trabalho1/listagem.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _edName = TextEditingController();
  bool _edBooking = false;
  var _edMensagem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trabalho 1')),
      body: _body(context),
    );
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

  Column _body(context) {
    return Column(
      children: <Widget>[_form(), _listagem(context)],
    );
  }

  Container _form() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _edName,
            decoration: InputDecoration(
              labelText: "Nome Completo",
              labelStyle: TextStyle(color: Colors.blue),
            ),
          ),
          CheckboxListTile(
            title: Text("Reservar Quarto"),
            value: _edBooking,
            onChanged: (bool value) {
              setState(() {
                if (_edBooking == true) {
                  _edBooking = false;
                } else {
                  _edBooking = true;
                }
              });
            },
          ),
          RaisedButton(
            color: Colors.deepOrangeAccent,
            child: Text("Adicionar"),
            textColor: Colors.white,
            onPressed: () {
              _addReserva();
            },
          ),
          RaisedButton(
            color: Colors.deepOrangeAccent,
            child: Text("Listagem"),
            textColor: Colors.white,
            onPressed: () {
              _tabelas(context);
            },
          ),
          Text(_edMensagem)
        ],
      ),
    );
  }

  _tabelas(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Listagem()));
  }

  _addReserva() {
    String completeName = _edName.text;
    String booking = "";
    if (_edBooking == true) {
      booking = "Reservado";
    } else {
      booking = "Não Reservado";
    }
    var newBooking = new Map();

    newBooking['nome'] = completeName;
    newBooking['reservado'] = booking;

    setState(() {
      _reservas.add(newBooking);
      _edName.clear();
      _edBooking = false;
      _edMensagem = '$completeName foi reservado seu quarto $booking';
    });
    _saveData();
  }

  List _reservas = [];

  _listagem(context) {
    return 
    Expanded(
      child: ListView.builder(
        itemCount: _reservas.length,
        itemBuilder: (context, index) {
        
          return Table(
            border: TableBorder.all(
              color: Colors.black26, width: 1, style: BorderStyle.solid
              
            ),
            children: [
         
              TableRow(
                children: [
                  TableCell(
                    child: Center(child: Text(_reservas[index]["nome"], style: TextStyle(fontSize: 18, color: Colors.black54, fontFamily: "Arial", fontWeight: FontWeight.bold),)),
                  ),
                  TableCell(child: Center(child: Text(_reservas[index]["reservado"], style: TextStyle(fontSize: 18, color: Colors.black54, fontFamily: "Arial", fontWeight: FontWeight.bold),))),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Future<File> _getFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return File(appDocPath + '/reservas.json');
  }

  Future<File> _saveData() async {
    String reservados = json.encode(_reservas);

    final file = await _getFile();
    return file.writeAsString(reservados);
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
}
