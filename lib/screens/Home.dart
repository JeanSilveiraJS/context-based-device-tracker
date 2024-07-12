import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'Situacao.dart';
import 'autenticacao/Login.dart';

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

  //TODO: buscar o nome do usuário logado do backend
  String userName = "Nome do Usuário";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        automaticallyImplyLeading: false, // Remove o botão de voltar
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: -1,
                enabled: false, // Valor que não corresponde a nenhuma ação
                child: Text(userName, style: const TextStyle(fontSize: 20)), // Desabilita a seleção deste item
              ),
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Logout'),
              ),
            ],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: agentes.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Lista de Agentes ${index + 1}'),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Situacao(agentes: agentes[index]),
                      ),
                    );
                  },
                ),
                Image.network('https://th.bing.com/th/id/OIP.4xUwZLLE24q97yTVCkrw1QHaG6?w=623&h=582&rs=1&pid=ImgDetMain', width: double.infinity, height: 100, alignment: Alignment.center, fit: BoxFit.cover), // Imagem genérica
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

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        _logout();
        break;
    }
  }

  //TODO: simplificar a função de logout, removendo a necessidade de enviar uma requisição ao backend
  void _logout() async {
    var url = Uri.parse('${Globals.httpServerUrl}/login/logout');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // Logout bem-sucedido, redirecionar para a tela de login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
      );
    } else {
      // Tratar erro de logout
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Falha no logout"),
      ));
    }
  }
}