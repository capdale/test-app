import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocationPage extends StatefulWidget {
  GeoLocationPage({Key? key}) : super(key: key);

  @override
  State<GeoLocationPage> createState() => _GeoLocationPageState();
}

class _GeoLocationPageState extends State<GeoLocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: isGeoLocationServiceEnable(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return const Center(child: Text("wait for permission"));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Snapshot Error"));
          }
          if (snapshot.data == false) {
            return const Text("no permission");
          }
          return PositionComponent();
        },
      ),
    );
  }
}

Future<bool> isGeoLocationServiceEnable() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return false;
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

class PositionComponent extends StatefulWidget {
  PositionComponent({Key? key}) : super(key: key);

  @override
  State<PositionComponent> createState() => _PositionComponentState();
}

class _PositionComponentState extends State<PositionComponent> {
  Position position = Position(
    longitude: 0,
    latitude: 0,
    accuracy: 0,
    altitude: 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
    timestamp: DateTime(0),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("longitude: ${position.longitude}"),
          Text("latitude: ${position.latitude}"),
          Text("altitude: ${position.altitude}"),
          Text("heading: ${position.heading}"),
          Text("accuracy: ${position.accuracy}"),
          TextButton(
            onPressed: () async {
              final position = await Geolocator.getCurrentPosition();
              setState(() {
                this.position = position;
              });
            },
            child: const Text("refresh"),
          )
        ],
      ),
    );
  }
}
