import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double storeLatitude;
  final double storeLongitude;
  MapScreen(this.storeLatitude, this.storeLongitude);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static Position _currentPosition;
  var storeLatitude;
  var storeLongitude;
  GoogleMapController mapController;
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  getCurrentLocation() async {
    await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                      height: ScreenUtil().setHeight(MediaQuery.of(context).size.height / 1.5),
                      width: ScreenUtil().setWidth(MediaQuery.of(context).size.width),
                      child: _currentPosition != null ? GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                            zoom: 16.0,
                        ),
                      ) : Center(
                        child: SpinKitCircle(
                            color: Colors.blue,
                        ),
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Map View",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
