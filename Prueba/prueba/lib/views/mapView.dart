import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:prueba/controls/servicio_back/FacadeService.dart';
import 'package:simple_tiles_map/simple_tiles_map.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mapa de Comentarios',
      home: MapaSitiosView(),
    );
  }
}

class MapaSitiosView extends StatefulWidget {
  @override
  _MapaSitiosViewState createState() => _MapaSitiosViewState();
}

class _MapaSitiosViewState extends State<MapaSitiosView> {
  List<dynamic> comentarios = [];
  Map<String, dynamic> lugar_origen = {};
  late Location location;
  late StreamSubscription<LocationData> locationSubscription;
  bool isLocationListening = false;

  @override
  void initState() {
    super.initState();
    location = Location();
    locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
      // Handle location changes here if needed
    });
    obtenerSitio();
  }

  @override
  void dispose() {
    super.dispose();
    locationSubscription.cancel(); // Cancela la suscripción a la ubicación
  }

  Future<void> obtenerSitio() async {
    FacadeService fs = FacadeService();
    var response = await fs.verGuias();
    if (response.code == 200) {
      bool serviceEnabled;
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          mostrarSnackBar('El servicio de ubicación está desactivado');
          return;
        }
      }

      PermissionStatus permission;
      permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != PermissionStatus.granted) {
          mostrarSnackBar('Permiso de ubicación denegado');
          return;
        }
      }

      LocationData locationData = await location.getLocation();
      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;

      setState(() {
        lugar_origen = {
          "latitud": latitude,
          "longitud": longitude,
        };
      });

      setState(() {
        // Filtrar los comentarios que tienen coordenadas válidas
        comentarios = response.datos.where((sitio) =>
            sitio['latitud'] != 0 && sitio['longitud'] != 0).toList();
      });
    } else {
      print(response.msg);
    }
  }

  void mostrarSnackBar(String mensaje) {
    SnackBar snackBar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Comentarios'),
      ),
      body: lugar_origen.isNotEmpty
          ? SimpleTilesMap(
              typeMap: TypeMap.osmHot,
              mapOptions: MapOptions(
                center: LatLng(lugar_origen['latitud'], lugar_origen['longitud']),
                zoom: 15.0,
              ),
              otherLayers: [
                MarkerLayer(
                  markers: comentarios.map((sitio) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        sitio['latitud'],
                        sitio['longitud'],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.comment,
                            color: Colors.blueAccent,
                            size: 30.0,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
