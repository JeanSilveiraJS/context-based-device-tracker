import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gps_device_manager/app-core/model/SituacaoModel.dart';
import 'package:gps_device_manager/app-core/model/UsuarioModel.dart';
import 'package:gps_device_manager/app-core/persistence/LoginPersistence.dart';
import 'package:gps_device_manager/services/SituacaoService.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../services/AutenticacaoService.dart';
import 'Situacao.dart';
import 'autenticacao/Login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late UsuarioModel usuario;
  List<SituacaoModel> situacoes = [];

  @override
  void initState() {
    super.initState();

    if (AutenticacaoService().getUsuarioLogado() == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
    }
    usuario = AutenticacaoService().getUsuarioLogado()!;
    SituacaoService().listar(usuario).then((situacoesFromService) {
      if (situacoesFromService != null) {
        setState(() {
          situacoes = situacoesFromService;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _popupSituacao(null),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Início'),
      automaticallyImplyLeading: false,
      actions: <Widget>[
        PopupMenuButton<int>(
          onSelected: (item) => onSelected(context, item),
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: -1,
              enabled: false,
              child: Text(usuario.nome, style: const TextStyle(fontSize: 20)),
            ),
            const PopupMenuItem<int>(
              value: 0,
              child: Text('Logout'),
            ),
          ],
          icon: const Icon(Icons.person),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return situacoes.isEmpty
        ? const Center(child: Text('Não existem situações cadastradas.'))
        : ListView.builder(
            itemCount: situacoes.length,
            itemBuilder: (context, index) => _buildListItem(context, index),
          );
  }

  Widget _buildListItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Situacao(situacao: situacoes[index]),
          ),
        ),
        child: _buildCard(index),
      ),
    );
  }

  Card _buildCard(int index) {
    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(situacoes![index].nome,
                  style: TextStyle(fontSize: 20, color: Colors.black87)),
              trailing: _buildTrailing(context, index),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(situacoes![index].descricao,
                  style: TextStyle(fontSize: 16, color: Colors.black87)),
            ),
            Divider(color: Colors.black38),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Início: ${DateFormat('dd/MM/yyyy').format(situacoes![index].dataInicio)}',
                  style: TextStyle(color: Colors.black87)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  'Fim: ${DateFormat('dd/MM/yyyy').format(situacoes![index].dataFim)}',
                  style: TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildTrailing(BuildContext context, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => _popupSituacao(situacoes![index]),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            if (await SituacaoService().deletar(situacoes!, index)) {
              setState(() {
                situacoes!.removeAt(index);
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Falha ao deletar situação')));
            }
          },
        ),
      ],
    );
  }

  void _popupSituacao(SituacaoModel? situacao) {
    final _nameController = TextEditingController(text: situacao?.nome);
    final _descriptionController =
        TextEditingController(text: situacao?.descricao);
    final _startDateController = TextEditingController(
        text: situacao != null
            ? DateFormat('dd/MM/yyyy').format(situacao.dataInicio)
            : '');
    final _endDateController = TextEditingController(
        text: situacao != null
            ? DateFormat('dd/MM/yyyy').format(situacao.dataFim)
            : '');
    DateTime _startDate = situacao?.dataInicio ?? DateTime.now();
    DateTime _endDate = situacao?.dataFim ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(situacao == null ? 'Nova situação' : 'Editar situação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Data de início'),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _startDateController.text =
                        DateFormat('dd/MM/yyyy').format(date);
                    _startDate = date;
                  }
                },
              ),
              TextField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'Data de término'),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    _endDateController.text =
                        DateFormat('dd/MM/yyyy').format(date);
                    _endDate = date;
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                SituacaoModel newSituacao = SituacaoModel.criar(
                  id: situacao?.id,
                  nome: _nameController.text,
                  descricao: _descriptionController.text,
                  dataInicio: _startDate,
                  dataFim: _endDate,
                );
                if (situacao == null) {
                  newSituacao = await SituacaoService().cadastrar(newSituacao);
                  setState(() {
                    situacoes.add(newSituacao);
                  });
                } else {
                  if (await SituacaoService().editar(newSituacao)) {
                    setState(() {
                      situacoes![situacoes!.indexOf(situacao)] = newSituacao;
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Falha ao editar situação')));
                  }
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Situacao(situacao: newSituacao),
                  ),
                );
              },
              child: Text(situacao == null ? 'Adicionar' : 'Editar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        if (await AutenticacaoService().logout()) {
          await LoginPersistence().logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Falha ao fazer logout')));
        }
        break;
    }
  }
}
