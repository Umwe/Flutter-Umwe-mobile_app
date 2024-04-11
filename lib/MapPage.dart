import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController; // Initialize to null

  // Replace these coordinates with your home location
  final LatLng _homeLocation = const LatLng(37.7749, -122.4194);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _homeLocation,
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId('Home'),
            position: _homeLocation,
            infoWindow: InfoWindow(title: 'Home Location'),
          ),
        },
      ),
    );
  }
}
