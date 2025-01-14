import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_project/consts.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grad_project/models/request_model.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

// Global variable to store the last tapped location
LatLng? globalLastTappedLocation;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();

  Location _locationController = Location();
  LatLng? _currentPosition = null;
  Marker? _lastTappedMarker;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchSuggestions = [];

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    // Restore the last tapped marker if available
    if (globalLastTappedLocation != null) {
      setState(() {
        _lastTappedMarker = Marker(
          markerId: MarkerId("tappedLocation"),
          position: globalLastTappedLocation!,
          infoWindow: InfoWindow(title: "Last Tapped Location"),
        );
      });
    }

    // Get the current location once and move the camera
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        LocationData currentLocation = await _locationController.getLocation();
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentPosition = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );
          });

          // Move the camera to the last tapped marker or current location
          if (_lastTappedMarker != null) {
            _cameraToPosition(_lastTappedMarker!.position);
          } else if (_currentPosition != null) {
            _cameraToPosition(_currentPosition!);
          }
        }
      } catch (e) {
        print("Error fetching initial location: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick a Location"),
      ),
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: Text("Loading.."))
              : GoogleMap(
            onMapCreated: (GoogleMapController controller) =>
                _mapController.complete(controller),
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 10,
            ),
            markers: {
              Marker(
                markerId: MarkerId("_currentLocation"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                position: _currentPosition!,
              ),
              if (_lastTappedMarker != null) _lastTappedMarker!,
            },
            onTap: (LatLng tappedLocation) {
              setState(() {
                _lastTappedMarker = Marker(
                  markerId: MarkerId("tappedLocation"),
                  position: tappedLocation,
                  infoWindow: InfoWindow(title: "Tapped Location"),
                );
                globalLastTappedLocation = tappedLocation; // Update global variable
              });
              _cameraToPosition(tappedLocation); // Move to tapped location
            },
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search location",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(
                      Duration(milliseconds: 500),
                          () {
                        if (value.isNotEmpty) {
                          _searchPlaces(value);
                        }
                      },
                    );
                  },
                ),
                if (_searchSuggestions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _searchSuggestions[index];
                        return ListTile(
                          title: Text(suggestion['description'] ?? 'Unknown'),
                          onTap: () {
                            _onSuggestionTap(suggestion);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 60,
            child: ElevatedButton(
              onPressed: (){
                if (_lastTappedMarker != null) {
                  globalLastTappedLocation = _lastTappedMarker!.position;
                } else if (_currentPosition != null) {
                  globalLastTappedLocation = _currentPosition;
                }
                if (globalLastTappedLocation != null) {
                  RequestModel request = RequestModel(location: globalLastTappedLocation);
                  // Call your method to save the request to Firestore
                  // e.g., databaseService.saveRequest(request);
                  Navigator.pop(context); // Go back to the previous screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a valid location")),
                  );
                }
              },
              child: Text('Save Location'),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 10,
            right: 60,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPosition != null) {
                  _cameraToPosition(_currentPosition!);
                  setState(() {
                    _lastTappedMarker = null; // Reset last tapped marker
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Current location is not available")),
                  );
                }
              },
              child: Text('Go to Current Location'),
            ),
          ),
        ],
      ),
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

  Future<void> _searchPlaces(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$PLACES_API_KEY';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List<dynamic>;
        setState(() {
          _searchSuggestions = predictions
              .map<Map<String, String>>((prediction) => {
            'description': prediction['description'] as String,
            'place_id': prediction['place_id'] as String,
          })
              .toList();
        });
      } else {
        print('Failed to fetch suggestions: ${response.body}');
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  Future<void> _onSuggestionTap(Map<String, String> suggestion) async {
    final String placeId = suggestion['place_id']!;
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$PLACES_API_KEY';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];

        if (result != null && result['geometry'] != null) {
          final location = result['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];

          if (lat != null && lng != null) {
            _cameraToPosition(LatLng(lat, lng));
            setState(() {
              _searchSuggestions = [];
            });
          } else {
            print('Invalid latitude or longitude.');
          }
        } else {
          print('Geometry or location data is missing in the response.');
        }
      } else {
        print('Failed to fetch place details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
  }


}
