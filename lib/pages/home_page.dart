import 'dart:async';

import 'package:dummy_mapstr/model/model_city.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' as services;
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> jsonStyle;
  final googleMapsController = Completer<GoogleMapController>();
  List<ModelCity> filteredCities = cities;
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  void navigateToCity(ModelCity modelCity) async {
    final controller = await googleMapsController.future;

    controller.animateCamera(
      CameraUpdate.newLatLng(modelCity.latLng),
    );
  }

  @override
  void initState() {
    super.initState();
    jsonStyle = getJsonData();

    setState(() {
      markers = cities.map(
        (e) {
          return Marker(
              position: e.latLng,
              markerId: MarkerId(e.name),
              infoWindow: InfoWindow(
                  title: e.name,
                  snippet: "Latitudine: ${e.latLng.latitude.toString()}"));
        },
      ).toSet();

      circles = cities.map(
        (e) {
          return Circle(
              center: e.latLng,
              circleId: CircleId(
                e.name,
              ),
              radius: 300,
              strokeColor: Colors.blue,
              fillColor: Colors.blue.shade300.withAlpha(80),
              strokeWidth: 2);
        },
      ).toSet();
    });
  }

  getJsonData() async {
    final response =
        await services.rootBundle.loadString("assets/maps_style.json");
    // print(response);
    return response.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [map(), searchBar()],
    ));
  }

  Widget map() {
    return FutureBuilder(
        future: jsonStyle,
        builder: (context, snapShot) {
          if (snapShot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          } else {
            //print(snapShot.requireData);
            return Expanded(
              child: GoogleMap(
                markers: markers,
                circles: circles,
                onMapCreated: (controller) {
                  googleMapsController.complete(controller);
                },
                style: snapShot.requireData,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  zoom: 15,
                  target: cities[0].latLng,
                ),
              ),
            );
          }
        });
  }

  Widget searchBar() {
    return FloatingSearchBar(
        onQueryChanged: (query) {
          setState(() {
            filteredCities = cities
                .where(
                  (element) =>
                      element.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
          });
        },
        builder: (context, animation) => ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Material(
                elevation: 4,
                child: Column(
                  children: List.generate(
                    filteredCities.length,
                    (index) => ListTile(
                      onTap: () {
                        navigateToCity(filteredCities[index]);
                      },
                      title: Text(filteredCities[index].name),
                    ),
                  ),
                ),
              ),
            ));
  }
}
