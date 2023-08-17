import 'package:flutter/material.dart';
import 'package:Rakshika/components/app_bar.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_webservice/directions.dart' as directionsAPI;
import 'package:google_maps_webservice/places.dart' as places;

final places.GoogleMapsPlaces placesAPI =
    places.GoogleMapsPlaces(apiKey: "AIzaSyDiziClz5wUhO7M79hHQEU5n7ojpFXw93k");
const String googleAPIKey = "AIzaSyDiziClz5wUhO7M79hHQEU5n7ojpFXw93k";

class SafeNavScreen extends StatelessWidget {
  const SafeNavScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  maps.GoogleMapController? mapController;
  PolylinePoints polylinePoints = PolylinePoints();

  TextEditingController startAddressController = TextEditingController();
  TextEditingController endAddressController = TextEditingController();

  Set<maps.Marker> markers = {};
  Map<maps.PolylineId, maps.Polyline> polylines = {};

  List<List<maps.LatLng>> paths = []; // List to store all paths

  @override
  void initState() {
    super.initState();
    updateMarkers();
  }

  void updateMarkers() {
    markers.clear();
    markers.add(const maps.Marker(
      markerId: maps.MarkerId("start"),
      position: maps.LatLng(27.6683619, 85.3101895),
      infoWindow: maps.InfoWindow(
        title: 'Starting Point',
        snippet: 'Start Marker',
      ),
      icon: maps.BitmapDescriptor.defaultMarker,
    ));

    markers.add(const maps.Marker(
      markerId: maps.MarkerId("end"),
      position: maps.LatLng(27.6688312, 85.3077329),
      infoWindow: maps.InfoWindow(
        title: 'Destination Point',
        snippet: 'Destination Marker',
      ),
      icon: maps.BitmapDescriptor.defaultMarker,
    ));
  }

  void calculateOptimalPathWrapper() {
    String startAddress = startAddressController.text;
    String endAddress = endAddressController.text;

    getCoordinates(startAddress).then((startCoordinates) {
      getCoordinates(endAddress).then((endCoordinates) {
        setState(() {
          // Update the markers for start and end points
          markers.clear();
          markers.add(maps.Marker(
            markerId: const maps.MarkerId("start"),
            position: startCoordinates,
            infoWindow: const maps.InfoWindow(
              title: 'Starting Point',
              snippet: 'Start Marker',
            ),
            icon: maps.BitmapDescriptor.defaultMarker,
          ));

          markers.add(maps.Marker(
            markerId: const maps.MarkerId("end"),
            position: endCoordinates,
            infoWindow: const maps.InfoWindow(
              title: 'Destination Point',
              snippet: 'Destination Marker',
            ),
            icon: maps.BitmapDescriptor.defaultMarker,
          ));
        });
        calculateOptimalPath(startCoordinates, endCoordinates);
      }).catchError((e) {
        print("Error fetching end coordinates: $e");
      });
    }).catchError((e) {
      print("Error fetching start coordinates: $e");
    });
  }

  Future<maps.LatLng> getCoordinates(String address) async {
    try {
      List<geo.Location> locations = await geo.locationFromAddress(address);
      if (locations.isNotEmpty) {
        geo.Location location = locations.first;
        return maps.LatLng(location.latitude, location.longitude);
      } else {
        throw Exception("Location not found for address: $address");
      }
    } catch (e) {
      throw Exception("Error fetching coordinates: $e");
    }
  }

  void calculateOptimalPath(maps.LatLng start, maps.LatLng end) async {
    try {
      // Fetch directions from Google Maps Directions API
      final directionsAPI.GoogleMapsDirections googleDirections =
          directionsAPI.GoogleMapsDirections(apiKey: googleAPIKey);

      final directionsAPI.DirectionsResponse directionsResponse =
          await googleDirections.directionsWithLocation(
        places.Location(lat: start.latitude, lng: start.longitude),
        places.Location(lat: end.latitude, lng: end.longitude),
        travelMode: directionsAPI.TravelMode.driving,
      );

      if (directionsResponse.isOkay && directionsResponse.routes.isNotEmpty) {
        List<maps.LatLng> polylineCoordinates = [];
        for (var step in directionsResponse.routes[0].legs[0].steps) {
          polylineCoordinates
              .add(maps.LatLng(step.startLocation.lat, step.startLocation.lng));
          polylineCoordinates
              .add(maps.LatLng(step.endLocation.lat, step.endLocation.lng));
        }

        // Add this path to the list of paths
        paths.add(polylineCoordinates);

        // Draw the path on the map
        addPolyLine(polylineCoordinates);
      }

      // If there are multiple paths, you can calculate safety scores for each path
      for (var path in paths) {
        int safetyScore = await calculateSafetyScore(path);
        print("Safety Score for this path: $safetyScore");
      }

      // You can find the optimal path based on safety scores and other criteria here
      List<maps.LatLng> optimalPath =
          paths[0]; // Assuming the first path is optimal

      // Display the optimal path on the map
      addPolyLine(optimalPath);

      // Add markers for police stations and hospitals on the optimal path
      for (var coordinate in optimalPath) {
        addPoliceStationsMarkers(coordinate);
        addHospitalsMarkers(coordinate);
      }

      // Animate the camera to fit both start and end points
      maps.LatLngBounds bounds = maps.LatLngBounds(
        southwest: maps.LatLng(
          start.latitude,
          start.longitude,
        ),
        northeast: maps.LatLng(
          end.latitude,
          end.longitude,
        ),
      );

      mapController!
          .animateCamera(maps.CameraUpdate.newLatLngBounds(bounds, 100));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<int> calculateSafetyScore(List<maps.LatLng> routeCoordinates) async {
    int safetyScore = 0;
    for (maps.LatLng coordinate in routeCoordinates) {
      List<places.PlacesSearchResult> nearbyPoliceStations =
          await fetchNearbyPoliceStations(coordinate);
      List<places.PlacesSearchResult> nearbyHospitals =
          await fetchNearbyHospitals(coordinate);

      int coordinateSafetyScore =
          nearbyPoliceStations.length + nearbyHospitals.length;
      safetyScore += coordinateSafetyScore;
    }
    return safetyScore;
  }

  Future<List<places.PlacesSearchResult>> fetchNearbyPoliceStations(
      maps.LatLng coordinate) async {
    final response = await placesAPI.searchNearbyWithRadius(
      places.Location(lat: coordinate.latitude, lng: coordinate.longitude),
      1000, // Radius in meters (adjust as needed)
      type: 'police',
    );

    return response.results;
  }

  Future<List<places.PlacesSearchResult>> fetchNearbyHospitals(
      maps.LatLng coordinate) async {
    final response = await placesAPI.searchNearbyWithRadius(
      places.Location(lat: coordinate.latitude, lng: coordinate.longitude),
      1000, // Radius in meters (adjust as needed)
      type: 'hospital',
    );

    return response.results;
  }

  void addPolyLine(List<maps.LatLng> polylineCoordinates) {
    maps.PolylineId id = const maps.PolylineId("poly");
    maps.Polyline polyline = maps.Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }

  void addPoliceStationsMarkers(maps.LatLng coordinate) {
    // Fetch nearby police stations using the places API
    fetchNearbyPoliceStations(coordinate)
        .then((List<places.PlacesSearchResult> places) {
      // Create markers for each police station
      for (var place in places) {
        // Check if place.id is not null, otherwise use a default value
        String markerId = place.id ?? 'default_police_station_id';

        maps.Marker marker = maps.Marker(
          markerId: maps.MarkerId(markerId),
          position: maps.LatLng(
              place.geometry!.location.lat, place.geometry!.location.lng),
          infoWindow: maps.InfoWindow(
            title: place.name,
            snippet: place.vicinity,
          ),
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(
              maps.BitmapDescriptor.hueAzure),
        );
        setState(() {
          markers.add(marker);
        });
      }
    }).catchError((e) {
      print("Error fetching nearby police stations: $e");
    });
  }

  void addHospitalsMarkers(maps.LatLng coordinate) {
    // Fetch nearby hospitals using the places API
    fetchNearbyHospitals(coordinate)
        .then((List<places.PlacesSearchResult> places) {
      for (var place in places) {
        // Check if place.id is not null, otherwise use a default value
        String markerId = place.id ?? 'default_hospital_id';

        maps.Marker marker = maps.Marker(
          markerId: maps.MarkerId(markerId),
          position: maps.LatLng(
              place.geometry!.location.lat, place.geometry!.location.lng),
          infoWindow: maps.InfoWindow(
            title: place.name,
            snippet: place.vicinity,
          ),
          icon: maps.BitmapDescriptor.defaultMarkerWithHue(
              maps.BitmapDescriptor.hueGreen),
        );
        setState(() {
          markers.add(marker);
        });
      }
    }).catchError((e) {
      print("Error fetching nearby hospitals: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarConstant(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: startAddressController,
              decoration: const InputDecoration(labelText: "Start Address"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: endAddressController,
              decoration: const InputDecoration(labelText: "End Address"),
            ),
          ),
          ElevatedButton(
            onPressed: calculateOptimalPathWrapper,
            child: const Text("Get Directions"),
          ),
          Expanded(
            child: maps.GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: const maps.CameraPosition(
                target: maps.LatLng(27.6683619, 85.3101895),
                zoom: 16.0,
              ),
              markers: markers,
              polylines: Set<maps.Polyline>.of(polylines.values),
              mapType: maps.MapType.normal,
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
