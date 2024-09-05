import 'package:dummy_mapstr/model/model_city.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' as services;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> jsonStyle;
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
      children: [
        map(),
      ],
    ));
  }

  Widget map() {
    return FutureBuilder(
        future: jsonStyle,
        builder: (context, snapShot) {
          if (snapShot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          } else {
            print(snapShot.requireData);
            return Expanded(
              child: GoogleMap(
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

  // Widget searchBar() {
  //   return Positioned(
  //     top: 50,
  //     right: 0,
  //     left: 0,
  //     child: SizedBox(
  //       height: 60,
  //       child: FloatingSearchBar(
  //           builder: (context, animation) => ListTile(
  //                 title: Text(cities[0].name),
  //               )),
  //     ),
  //   );
  // }
}
