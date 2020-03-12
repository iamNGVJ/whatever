import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as LatLong;
import 'package:link/models/product.dart';

class MapScreen extends StatefulWidget {
  final Products product;
  MapScreen(this.product);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Polyline> pathToDest = {};
  static Position _currentPosition;
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
      Fluttertoast.showToast(
        msg: "Failed to get location",
        backgroundColor: Colors.grey,
      );
    });
  }

  GoogleMapController _mapController;
  List<LatLng> routeCords;
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(
    apiKey: "AIzaSyCnx7E3hzCsR5onzv34H0Mk5BMdG3CzKUk"
  );

  getSomePoints() async{
    routeCords = await googleMapPolyline.getCoordinatesWithLocation(
      origin: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      destination: LatLng(this.widget.product.storeLatitude, this.widget.product.storeLongitude),
      mode: RouteMode.driving
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _markers.add(Marker(
          markerId: MarkerId("Location1"),
          position: LatLng(this.widget.product.storeLatitude, this.widget.product.storeLongitude),
          icon: pinLocationIcon));
      pathToDest.add(Polyline(
        polylineId: PolylineId("Route1"),
        visible: true,
        points: routeCords,
        width: 4,
        color: Color(0xFF6C00E9),
        startCap: Cap.roundCap,
        endCap: Cap.buttCap
      ));
    });
  }

  calculateDistance(latitude, longitude){
    LatLong.Distance distance = new LatLong.Distance();
    final double km = distance.as(LatLong.LengthUnit.Kilometer, new LatLong.LatLng(_currentPosition.latitude, _currentPosition.longitude), new LatLong.LatLng(latitude, longitude));
    return km;
  }

  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      "assets/images/marker.png",
    ).then((onValue) {
      pinLocationIcon = onValue;
    });
    super.initState();
    getSomePoints();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        height: ScreenUtil().setHeight(
                            MediaQuery.of(context).size.height / 1.5),
                        width: ScreenUtil()
                            .setWidth(MediaQuery.of(context).size.width),
                        child: _currentPosition.latitude != null && _currentPosition.longitude != null ? GoogleMap(
                          markers: _markers,
                          myLocationEnabled: true,
                          polylines: pathToDest,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                            zoom: 16.0,
                          ),
                          mapType: MapType.hybrid,
                        ):Center(
                          child: SpinKitCircle(
                            color: Colors.blue,
                          ),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Map View",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: true),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Recommended Store Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Store Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "${this.widget.product.storeAddress}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Distance (from your location)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        )
                      ),
                      Text(calculateDistance(this.widget.product.storeLatitude, this.widget.product.storeLongitude) > 0.99 ?
                      "${calculateDistance(this.widget.product.storeLatitude, this.widget.product.storeLongitude)}km":
                      "${calculateDistance(this.widget.product.storeLatitude, this.widget.product.storeLongitude) * 100}m",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Product Price (in currently selected store)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "\$${this.widget.product.price}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}
