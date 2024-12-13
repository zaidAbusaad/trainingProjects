import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/consts.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  Location _locationController = new Location();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentPosition = null;

  Marker? _lastTappedMarker;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then(
          (coordinates) => {
            print(coordinates),
          },
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("pick a location"),),
      body: _currentPosition == null
          ? const Center(
              child: Text("Loading.."),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) =>
                  _mapController.complete(controller),
              initialCameraPosition: const CameraPosition(
                target: _pGooglePlex,
                zoom: 10,
              ),
              markers: {
                Marker(
                    markerId: MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    position: _currentPosition!),
                Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pGooglePlex),
                Marker(
                    markerId: MarkerId("_destinationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pApplePark),
                if (_lastTappedMarker != null) _lastTappedMarker!,
              },
              onTap: (LatLng tappedLocation) {
                setState(() {
                  _lastTappedMarker = Marker(
                    markerId: MarkerId("tappedLocation"),
                    position: tappedLocation,
                    infoWindow: InfoWindow(title: "Tapped Location"),
                  );
                });
                _saveTappedLocation(tappedLocation);
              },
            ),
    );
  }

  Future<void> _cameraPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData CurrentLocation) {
      if (CurrentLocation.latitude != null &&
          CurrentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(CurrentLocation.latitude!, CurrentLocation.longitude!);
          _cameraToPosition(_currentPosition!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    final request = PolylineRequest(
      origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      destination: PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      mode: TravelMode.driving,
    );
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_API_KEY,
      request: request,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  Future<void> _saveTappedLocation(LatLng location) async {///////////////firebase function
    try {
      await FirebaseFirestore.instance.collection("locations").add({
        "latitude": location.latitude,
        "longitude": location.longitude,
        "timestamp": Timestamp.now(),
      });
      print("Tapped Location Saved to Firebase: ${location.latitude}, ${location.longitude}");
    } catch (e) {
      print("Failed to save tapped location: $e");
    }
  }

}
