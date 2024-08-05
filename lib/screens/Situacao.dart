import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../app-core/model/AgenteModel.dart';
import '../app-core/model/SituacaoModel.dart';
import '../services/AgenteService.dart';

class Situacao extends StatefulWidget {
  final SituacaoModel situacao;

  const Situacao({super.key, required this.situacao});

  @override
  _SituacaoState createState() => _SituacaoState();
}

class _SituacaoState extends State<Situacao> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  static MapType _tipoMapa = MapType.satellite;
  late List<AgenteModel> agentes;
  StreamController<LatLng> _localizacaoController = StreamController<LatLng>();

  @override
  void initState() {
    super.initState();
    AgenteService().listar(widget.situacao).then((agentesFromService) {
      if (agentesFromService != null) {
        setState(() {
          agentes = agentesFromService;
        });
        _criarMarcador();
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _moverCameraParaTodos());
      }
    });

    Stream.periodic(const Duration(seconds: 10))
        .asyncMap((_) => _obterLocalizacaoAtual())
        .pipe(_localizacaoController);
  }

  @override
  void dispose() {
    _localizacaoController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gerenciamento de Situação'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: _mudarTipoMapa,
            ),
          ],
        ),
        body: Column(
          children: [
            Text(
              widget.situacao.nome,
              style: const TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 500,
              child: StreamBuilder<LatLng>(
                stream: _localizacaoController.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<LatLng> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data == null) {
                    return const Center(
                        child: Text('Não foi possível obter a localização'));
                  } else {
                    LatLng localizacaoUsuario = snapshot.data!;

                    return GoogleMap(
                      mapType: _tipoMapa,
                      markers: _markers,
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                        _moverCameraParaTodos();
                      },
                      onTap: (LatLng latLng) {
                        _cardCriarAgente(latLng);
                      },
                      initialCameraPosition: CameraPosition(
                          target: localizacaoUsuario, zoom: 15.0),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: agentes.isEmpty
                  ? const Center(
                      child: Text(
                          'Nenhum agente cadastrado. Clique no mapa para adicionar.'),
                    )
                  : ListView.builder(
                      itemCount: agentes.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(agentes[index].nome),
                          subtitle: Text(agentes[index].descricao),
                          onTap: () {
                            _moverCameraPara(agentes[index]);
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (await AgenteService()
                                      .excluir(agentes[index])) {
                                    setState(() {
                                      agentes.removeAt(index);
                                      _criarMarcador();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Agente excluído'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Erro ao excluir agente'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ));
  }

  void _cardCriarAgente(LatLng latLng) {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    final latitudeController =
        TextEditingController(text: latLng.latitude.toString());
    final longitudeController =
        TextEditingController(text: latLng.longitude.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Agente'),
          content: Column(
            children: <Widget>[
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () async {
                _criarAgente(
                  nomeController.text,
                  descricaoController.text,
                  double.parse(latitudeController.text),
                  double.parse(longitudeController.text),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _criarAgente(nome, descricao, latitude, longitude) async {
    AgenteModel agente = await AgenteService().criar(
      AgenteModel.criar(
        id_situacao: widget.situacao.id,
        nome: nome,
        descricao: descricao,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    setState(() {
      agentes.add(agente);
      _criarMarcador();
      _moverCameraPara(agente);
    });
  }

  void _criarMarcador() {
    _markers.clear();
    for (var agente in agentes) {
      _markers.add(
        Marker(
          markerId: MarkerId(agente.nome),
          position: LatLng(agente.latitude, agente.longitude),
          infoWindow: InfoWindow(
            title: agente.nome,
            snippet: agente.descricao,
          ),
        ),
      );
    }
  }

  void _moverCameraParaTodos() {
    if (agentes.isNotEmpty) {
      double minLat = agentes[0].latitude;
      double maxLat = agentes[0].latitude;
      double minLong = agentes[0].longitude;
      double maxLong = agentes[0].longitude;

      for (var agente in agentes) {
        if (agente.latitude < minLat) minLat = agente.latitude;
        if (agente.latitude > maxLat) maxLat = agente.latitude;
        if (agente.longitude < minLong) minLong = agente.longitude;
        if (agente.longitude > maxLong) maxLong = agente.longitude;
      }

      LatLngBounds limite = LatLngBounds(
        southwest: LatLng(minLat, minLong),
        northeast: LatLng(maxLat, maxLong),
      );

      mapController
          .moveCamera(CameraUpdate.newLatLngBounds(limite, 50))
          .then((void v) async {
        if (await mapController.getZoomLevel() > 15) {
          mapController.moveCamera(CameraUpdate.zoomTo(15));
        }
      });
    }
  }

  void _moverCameraPara(AgenteModel agente) {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(agente.latitude, agente.longitude),
        15.0,
      ),
    );
  }

  void _mudarTipoMapa() {
    setState(() {
      _tipoMapa =
          _tipoMapa == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  Future<LatLng> _obterLocalizacaoAtual() async {
    PermissionStatus permissao = await Permission.location.status;

    if (!permissao.isGranted) {
      permissao = await Permission.location.request();
    }

    if (permissao.isGranted) {
      Position posicao = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng localizacaoUsuario = LatLng(posicao.latitude, posicao.longitude);

      return localizacaoUsuario;
    } else {
      print("Permissão de localização não concedida");
      return LatLng(-29.7188134, -53.7154823);
    }
  }
}
