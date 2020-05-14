import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -123.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  BitmapDescriptor _markerIcon;

  Future<Set<Marker>> _createMarker(BuildContext context) async {
    List<Marker> mMarkers = [];

    mMarkers.add(Marker(
      markerId: MarkerId("1"),
      position: LatLng(37.43296265331129, -122.08832357078792),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      onTap: (){
        print('Done!!');
      },
      infoWindow: InfoWindow(
        title: 'Google Map',
        snippet: 'This is description',
        onTap: (){}
      ),
    ));
    mMarkers.add(Marker(
      markerId: MarkerId("2"),
      position: LatLng(37.43296265331129, -122.08232357078792),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
          title: 'Google Map',
          snippet: 'This is description',
          onTap: (){}
      ),
    ));
    return mMarkers.toSet();
  }

//  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
//    if (_markerIcon == null) {
//      final ImageConfiguration imageConfiguration =
//          createLocalImageConfiguration(context);
//      BitmapDescriptor.fromAssetImage(
//              imageConfiguration, 'assets/images/pin.jpg')
//          .then(_updateBitmap);
//    }
//  }

//  void _updateBitmap(BitmapDescriptor bitmapDescriptor) {
//    if (this.mounted) {
//      setState(() {
//        _markerIcon = bitmapDescriptor;
//      });
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    _createMarkerImageFromAsset(context);

  _createMarker(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Flutter'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
        future: _createMarker(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Error');
              break;
            case ConnectionState.waiting:
              return _loading();
              break;
            case ConnectionState.active:
              return _loading();
              break;
            case ConnectionState.done:
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: snapshot.data,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              );
              break;
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  _loading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
