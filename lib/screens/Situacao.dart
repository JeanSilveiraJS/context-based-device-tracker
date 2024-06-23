import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Situacao extends StatefulWidget {
  final List<Map<String, String>> agentes;

  Situacao({required this.agentes});

  _SituacaoState createState() => _SituacaoState();
}

class _SituacaoState extends State<Situacao> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  MapType _currentMapType = MapType.satellite;

  void initState() {
    super.initState();
    _createMarkers();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _moveCameraToBounds());
  }

  void _createMarkers() {
    _markers = widget.agentes.map((element) => Marker(
      markerId: MarkerId(element['nome']!),
      position: LatLng(double.parse(element['latitude']!), double.parse(element['longitude']!)),
      infoWindow: InfoWindow(
        title: element['nome'],
        snippet: element['descricao'],
      ),
    )).toSet();
  }

  void _moveCameraToBounds() {
    var bounds = _calculateBounds();
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _calculateBounds() {
    var latitudes = widget.agentes.map((e) => double.parse(e['latitude']!)).toList();
    var longitudes = widget.agentes.map((e) => double.parse(e['longitude']!)).toList();
    return LatLngBounds(
      southwest: LatLng(latitudes.reduce(math.min), longitudes.reduce(math.min)),
      northeast: LatLng(latitudes.reduce(math.max), longitudes.reduce(math.max)),
    );
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void _moveCameraToElement(Map<String, String> element) {
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(double.parse(element['latitude']!), double.parse(element['longitude']!)),
        15.0, // This is the zoom level. Adjust this value as needed.
      ),
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciamento de Situação'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.map),
            onPressed: _onMapTypeButtonPressed,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 500,
            child: GoogleMap(
              mapType: _currentMapType,
              initialCameraPosition: CameraPosition(
                target: _calculateBounds().northeast,
                zoom: 14.4746,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                _moveCameraToBounds();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.agentes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.agentes[index]['nome']!),
                  subtitle: Text(widget.agentes[index]['descricao']!),
                  onTap: () {
                    _moveCameraToElement(widget.agentes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}