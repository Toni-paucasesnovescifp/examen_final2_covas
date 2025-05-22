import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// hem hagut d'agregar una dependència per poder treballar aquesta classe
// serveix per la localització real de l'usuari actual
import 'package:geolocator/geolocator.dart';

// és la classe que mostra la vista que succeeix quan feim click
// o acabam de escanetjar una adreça geo. És a dir, aquí veim
// la localització damunt Google Maps i l'usuari pot tenir
// accés a les prestacions de Maps que hem previst

// sent una pantalla que implica moviment i actualització, ha de ser un StatefulWidget
class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  MapType _currentMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  bool _showMarkers = true; // Controla la visibilitat dels marcadors
  bool _showLine = false; // Controla la visibilitat de la línea recta
  Polyline? _lineaRecta; // Polilínea de la línea recta
  late LatLng _puntInicial;

  // el mapa se situa inicialment en el punt de la localització que li hem donat
  // com a paràmetre   (és a dir, per exemple, la coordenada geo:222.22, 222,444)
  @override
  Widget build(BuildContext context) {
 final  geo = ModalRoute.of(context)!.settings.arguments as String;

// Convierte la cadena en LatLng
List<String> latLng = geo.split(',');
final LatLng geoPosition = LatLng(
  double.parse(latLng[0]),
  double.parse(latLng[1]),
);



    final CameraPosition _puntInicialPos = CameraPosition(
      target: geoPosition,
      zoom: 14,
      tilt: 50,
    );

    _puntInicial = geoPosition;

    // s'estableix el marcador de la posició inicial que li ve a la pantalla donada    com a paràmetre
    Set<Marker> markers = Set<Marker>();
    if (_showMarkers) {
      markers.add(Marker(
          markerId: MarkerId('id1'),
          position: geoPosition)); // Agrega marcador
    }

    // aquest Scaffold conté pràcticament tota la part visual de la pantalla de Google Maps
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapes',
          style: TextStyle(
            color: Colors.white, // Camvia el color del text a blanc
          ),
        ),
        backgroundColor: Colors.deepPurple, // Canviar  a color violeta
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Navega cap enrera
          },
        ),
        actions: [
          // aquest botó és el d'adalt i a la dreta, que ens duu a la posició inicial
          IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.white,
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                    _puntInicialPos), // Vuelve a la posición inicial
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: _currentMapType,
            markers: markers,
            initialCameraPosition: _puntInicialPos,
            polylines: _showLine && _lineaRecta != null ? {_lineaRecta!} : {},
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          // Botons a la parte inferior centrats i ajustats
          Positioned(
            bottom: 20,
            left: 20,
            right: 40, // Asegura que no se superposin amb els botons del zoom
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // botó per canviar en MapType entre hybrid i normal
                FloatingActionButton(
                  heroTag: 'toggleMapType',
                  onPressed: () {
                    setState(() {
                      _currentMapType = _currentMapType == MapType.normal
                          ? MapType.hybrid
                          : MapType.normal;
                    });
                  },
                  child: Icon(Icons.layers), // Botón para cambiar tipo de mapa
                ),

                // botó per anar a la localització actual de l'usuari
                FloatingActionButton(
                  heroTag: 'centerOnUser',
                  onPressed: () async {
                    try {
                      LatLng currentLocation = await _getCurrentLocation();
                      final GoogleMapController controller =
                          await _controller.future;
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: currentLocation, zoom: 16),
                        ),
                      );
                      mostrarMissatgeNoModal(context,
                          'Anant a la teva ubicació: $currentLocation');
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },
                  child: Icon(Icons
                      .my_location), // Botón para centrar a la meva ubicació
                ),

                // botó per ocultar/mostrar marcadors
                FloatingActionButton(
                  heroTag: 'toggleMarkers',
                  onPressed: () {
                    setState(() {
                      _showMarkers =
                          !_showMarkers; // Alterna visibilidad de marcadores
                    });
                  },
                  child: Icon(
                    _showMarkers ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                // botó per mostrar/ocultar la línea entre adreça de l'usuari i adreça inicial
                FloatingActionButton(
                  heroTag: 'toggleLine',
                  onPressed: () async {
                    if (_showLine) {
                      setState(() {
                        _showLine = false; // Ocultar la línea
                      });
                    } else {
                      try {
                        LatLng currentLocation = await _getCurrentLocation();
                        _drawStraightLine(_puntInicial, currentLocation);
                        setState(() {
                          _showLine = true; // Mostrar la línea
                        });
                        await _zoomToFit(_puntInicial, currentLocation);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                  child: Icon(Icons.straighten), // Icono de medición
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método per dibuixar una línea recta entre el punt inicial i l'ubicació actual de l'usuari
  void _drawStraightLine(LatLng start, LatLng end) {
    setState(() {
      _lineaRecta = Polyline(
        polylineId: PolylineId('lineaRecta'),
        points: [start, end],
        color: Colors.red,
        width: 4,
      );

      // Calcular la distància entre els punts
      double distanceInMeters = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );

      double distanceInKm = distanceInMeters / 1000;
      mostrarMissatgeNoModal(
          context, 'Distancia: ${distanceInKm.toStringAsFixed(2)} km');
    });
  }

  // Ajustar el zoom perquè els dos punts  (inicial i ubicació actual de l'usuari)
  //siguin visibles a la vegada
  Future<void> _zoomToFit(LatLng start, LatLng end) async {
    final GoogleMapController controller = await _controller.future;

    LatLngBounds bounds;
    if (start.latitude > end.latitude && start.longitude > end.longitude) {
      bounds = LatLngBounds(southwest: end, northeast: start);
    } else if (start.latitude > end.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(end.latitude, start.longitude),
          northeast: LatLng(start.latitude, end.longitude));
    } else if (start.longitude > end.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(start.latitude, end.longitude),
          northeast: LatLng(end.latitude, start.longitude));
    } else {
      bounds = LatLngBounds(southwest: start, northeast: end);
    }

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  // Mètodo per obtenir la ubicació actual
  Future<LatLng> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servei d'ubitació està activat
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    // Solicita permisos d''ubicació
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación están denegados permanentemente.');
    }

    // Obté l'ubicación actual
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return LatLng(position.latitude, position.longitude);
  }
}


void mostrarMissatgeNoModal(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    ),
  );

  overlay?.insert(overlayEntry);

  // Quitar el mensaje después de 2 segundos
  Future.delayed(Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}