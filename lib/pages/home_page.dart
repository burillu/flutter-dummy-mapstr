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
                onMapCreated: (controller) {
                  googleMapsController.complete(controller);
                },
                style: snapShot.requireData,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  zoom: 14,
                  target: cities[1].latLng,
                ),
              ),
            );
          }
        });
  }

  Widget searchBar() {
    return FloatingSearchBar(
        builder: (context, animation) => ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Material(
                elevation: 4,
                child: Column(
                  children: List.generate(
                    cities.length,
                    (index) => ListTile(
                      onTap: () {
                        navigateToCity(cities[index]);
                      },
                      title: Text(cities[index].name),
                    ),
                  ),
                ),
              ),
            ));
  }
}
