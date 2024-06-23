import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Situacao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //TODO: substituir a lista de itens de teste pela lista de itens reais, puxando dados dinamicamente do backend
  final List<List<Map<String, String>>> agentes = [
    [
      {'nome': 'Item 1', 'descricao': 'This is item 1', 'latitude': '-29.7198236', 'longitude': '-53.71465'},
      {'nome': 'Item 2', 'descricao': 'This is item 2', 'latitude': '-29.7198237', 'longitude': '-53.71461'},
      {'nome': 'Item 3', 'descricao': 'This is item 3', 'latitude': '-29.7198238', 'longitude': '-53.7148'},
    ],
    [
      {'nome': 'Carga 01', 'descricao': 'Caminhão baú', 'latitude': '-29.6842', 'longitude': '-53.8069'},
      {'nome': 'Entregador', 'descricao': 'Van média', 'latitude': '-29.5894', 'longitude': '-53.3903'},
      {'nome': 'Fiscal', 'descricao': 'Carro comum', 'latitude': '-29.8188', 'longitude': '-53.3807'},
    ],
  ];

  void _addNewSituacao() {
    final _startDateController = TextEditingController();
    final _endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: AlertDialog(
              title: Text('Adicionar novo item'),
              content: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Nome"),
                    onChanged: (value) {
                      // Handle name input
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Descrição"),
                    onChanged: (value) {
                      // Handle description input
                    },
                  ),
                  TextFormField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      hintText: "Data de início",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );
                          if (date != null) {
                            _startDateController.text = DateFormat('dd/MM/yyyy').format(date);
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value!)) {
                        return 'Insira a data no formato dd/mm/aaaa';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      hintText: "Data de fim",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2050),
                          );
                          if (date != null) {
                            _endDateController.text = DateFormat('dd/MM/yyyy').format(date);
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value!)) {
                        return 'Insira a data no formato dd/mm/aaaa';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Adicionar'),
                  onPressed: () {
                    //TODO: implementar a criação de situações no backend
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editSituacao(int index) {
    //TODO: implementar a edição de situações no backend
  }

  void _deleteSituation(int index) {
    //TODO: implementar a exclusão de situações no backend
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Início'),
      ),

      //TODO: alterar campos de teste para campos reais
      body: ListView.builder(
        itemCount: agentes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Lista de Agentes ${index + 1}'),
            onTap: () {
              print('Você clicou na situacao ${index + 1}');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Situacao(agentes: agentes[index]),
                  )
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editSituacao(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteSituation(index),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addNewSituacao,
      ),
    );
  }
}