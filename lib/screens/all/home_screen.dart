import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:link/models/categories.dart';
import 'package:link/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:link/screens/all/product_details.dart';
import 'package:connectivity/connectivity.dart';
import 'package:link/widget_utils/notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentLocation;
  String _currentCountry;
  List<Products> fetchedProducts;
  List<Products> _products = List<Products>();
  List<Category> _categories = List<Category>();

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentLocation = "${place.locality}";
        _currentCountry = "${place.country}";
      });
      print(place.locality);
      print(place.postalCode);
      print(place.country);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkNetworkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return false;
    }
  }

  Future<Placemark> getActualLocation(latitude, longitude) async {
    List<Placemark> placemarc =
        await geoLocator.placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarc[0];
    return place;
  }

  getCurrentLocation() async {
    await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  // ignore: missing_return
  Future<List<Products>> getProducts() async {
    print("fetching products");
    const url = 'http://hitwo-api.herokuapp.com/products';
    var products = List<Products>();
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print('decoding response');
        var productsJson = json.decode(response.body);
        for (var productJson in productsJson) {
          products.add(Products.fromJSON(productJson));
        }
      }
    } on Exception catch (e) {
      print("$e");
    }
    _products = [];
    for (var product in products) {
      _products.add(product);
    }
  }

  List<Category> retrieveCategories(){
    List<Category> categoryList = [
      Category("Motors", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Fashion", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Electronics", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Collectables", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Art", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Home and Gardening", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Sport", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Toys", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Business and Industrial", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg"),
      Category("Music", "https://c.static-nike.com/a/images/t_PDP_1280_v1/f_auto/vomd5flqslkneosbdkdr/air-max-97-shoe-C1Xtkx.jpg")
    ];

    return categoryList;
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      allowFontScaling: true,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
    );
    var notify = new Notifications(context);
    int _currentIndex = 0;
    getProducts();
    checkNetworkConnection().then((status) {
      if (!status) {
        notify.showNetworkError();
      } else {
        print('Connected!');
      }
    });
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    print(_height);
    print(_width);

    _categories = retrieveCategories();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'VarelaRound'),
      home: SafeArea(
          child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.0, right: 0.0, left: 16.0),
                                  child: Text(
                                    "Product Locator",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(
                                          _width >= 360 ? 21 : 25,
                                          allowFontScalingSelf: true),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(15),
                                ),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 16.0, right: 0.0, left: 16.0),
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 16.0,
                                        left: 8.0,
                                      ),
                                      child: _currentLocation != null
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("$_currentLocation"),
                                                Text("$_currentCountry")
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  getCurrentLocation();
                                                });
                                              },
                                              child: Text("Enable Location"),
                                            ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top: 30),
                          width: ScreenUtil().setWidth(MediaQuery.of(context).size.width),
                          height: ScreenUtil().setHeight(MediaQuery.of(context).size.height * 1.375),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0)),
                              color: Color(0xFF6C00E9)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil().setHeight(40),
                              ),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                width: ScreenUtil().setWidth(
                                    MediaQuery.of(context).size.width / 1.3),
                                child: Text(
                                  "What are you looking for?",
                                  style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(27, allowFontScalingSelf: true),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "e.g. Nike Airmax",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        labelText: "Search",
                                        labelStyle:
                                            TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                            gapPadding: 3.5,
                                            borderRadius:
                                                BorderRadius.circular(8.0))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0
                                ),
                                alignment: Alignment.centerLeft,
                                height: ScreenUtil().setHeight(_height < 640 ? 320 : 340),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Popular Products",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              children: <Widget>[
                                                Text("View More",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                Icon(Icons.arrow_forward,
                                                    color: Colors.white)
                                              ],
                                            ))
                                      ],
                                    ),
                                    Container(
                                        width: double.infinity,
                                        height: 260,
                                        child: _products.length != 0
                                            ? ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: _products.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    elevation: 24.0,
                                                    child: Container(
                                                      height: ScreenUtil().setHeight(200),
                                                      width: ScreenUtil().setWidth(150),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white70,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            height: ScreenUtil().setHeight(140),
                                                            width: ScreenUtil().setWidth(150),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                bottomLeft: Radius.circular(16.0),
                                                                bottomRight: Radius.circular(16.0),
                                                              ),
                                                            ),
                                                            child: Hero(
                                                              tag: "${_products[index].imageUrl}",
                                                              child: Image(
                                                                image: NetworkImage(
                                                                  _products[index].imageUrl,
                                                                ),
                                                                fit: BoxFit.fitWidth,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Text(
                                                                    "${_products[index].name}",
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      padding: EdgeInsets.all(5.0),
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.blue,
                                                                        borderRadius: BorderRadius.circular(15.0),
                                                                      ),
                                                                      child: Text(
                                                                        "\$${_products[index].price}",
                                                                        style: TextStyle(
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                  ),
                                                                ],
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                                              child: Text(
                                                                "${_products[index].model}",
                                                                style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => ProductDetails(_products[index])),
                                                                  );
                                                                },
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.blue,
                                                                  ),
                                                                  child: Padding(
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: <Widget>[
                                                                          Text(
                                                                            "More Details",
                                                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Icon(
                                                                            Icons.open_in_browser,
                                                                            size: 15,
                                                                            color: Colors.white,
                                                                          )
                                                                        ],
                                                                      ),
                                                                  ),
                                                                ),
                                                              ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })
                                            : Center(
                                                child: Card(
                                                  elevation: 24.0,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    height: 200,
                                                    width: 400,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(16.0),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text(
                                                            "Wait While We Find Awesome Products For You",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: SpinKitCircle(color: Colors.blue,),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                alignment: Alignment.centerLeft,
                                height: 320,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Discover",
                                        style: TextStyle(
                                          fontSize: 27,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: ScreenUtil().setHeight(200),
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _categories.length,
                                            itemBuilder: (context, index){
                                              return Card(
                                                elevation: 24.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(16.0),
                                                  ),
                                                  width: ScreenUtil().setWidth(150),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Image(
                                                          image: NetworkImage(_categories[index].backgroundImageUrl),
                                                          fit: BoxFit.fill
                                                        ),
                                                        height: 150,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(25.0),
                                                            bottomRight: Radius.circular(25.0)
                                                          )
                                                        )
                                                      ),
                                                      Text(
                                                        _categories[index].title,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                        )
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        )
                                      )
                                    ]
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
          ),
      ),
    );
  }
}
