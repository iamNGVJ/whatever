import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:link/models/categories.dart';
import 'package:link/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:link/screens/all/product_details.dart';
import 'package:connectivity/connectivity.dart';
import 'package:link/screens/all/search_results_screen.dart';
import 'package:link/screens/all/viewby_category_screen.dart';
import 'package:link/screens/auth/signin_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'all_products_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  var prefs;
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentLocation;
  String _currentCountry;
  List<Products> fetchedProducts;
  List<Products> _products = List<Products>();
  List<Category> _categories = List<Category>();
  String searchQuery = "";
  bool isCollapsed = true;

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
    const url = 'http://hitwo-api.herokuapp.com/mobile/products';
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
      Category("Motors", null, "https://www.loebermotors.com/public/images/mercedesbenz-main_o.jpg", "motors"),
      Category("Fashion", null, "https://1.bp.blogspot.com/-sc4bW7Ji3kk/WZT33z4bqOI/AAAAAAABlAg/ynj4j4K25c07XLzNl8w4SfoCEBzYa420wCLcBGAs/s1600/17_AFWL_SDR_0342_SDR_Mabhunu1.jpg", "fashion"),
      Category("Electronics",  null, "https://www.nutsvolts.com/uploads/articles/NV_0704_Christopherson_Large.jpg", "electronics"),
      Category("Collectables", null, "https://www.africancollectables.com/wp-content/uploads/2018/03/Dark-Wood-and-Silver-Jewellery-Box-African-Collectables.jpg", "collectables"),
      Category("Art", null, "https://live.mrf.io/statics/i/ps/www.herald.co.zw/wp-content/uploads/sites/2/2019/09/1609HR0700MUGABE-PAINTING.jpg?width=1200&enable=upscale", "art"),
      Category("Home &", "Gardening", "https://media.angieslist.com/s3fs-public/styles/widescreen_large/s3/s3fs-public/home-garden.JPG?37enwB2E.rbKnI5YrW6JZ_irCpGbr5ct&itok=Usbna66n", "home"),
      Category("Sport",  null, "https://thinkwy.org/wp-content/uploads/2017/10/hpfulq-1234.jpg", "sport"),
      Category("Toys", null,  "https://cdn.vox-cdn.com/thumbor/Wa_GKNeLJfd_xKZyqP88ak84LZE=/0x0:6953x4750/1200x800/filters:focal(2921x1819:4033x2931)/cdn.vox-cdn.com/uploads/chorus_image/image/65820406/AdobeStock_259518799.0.jpeg", "toys"),
      Category("Industrial &", "Business", "https://www.continental-industry.com/getmedia/1acbdcf3-c675-4905-a711-3b21e50ecd5a/Steam-cleaning-hoses_Industrial-hoses_CT_Mother-2019.jpg.aspx?ext=.jpg&width=712", "industrial"),
      Category("Music",  null, "https://cdn3.pitchfork.com/longform/683/Year_In_Streaming_v2.jpg", "music"),
      Category("Self-care", null, "https://image.kilimall.com/kenya/shop/store/goods/2157/2018/11/2157_05948174760463840_720.jpg", "selfcare"),
      Category("Accessories", null, "https://image.roku.com/ww/ramp/images/category/accessories-players.png", "accessories")
    ];

    return categoryList;
  }

  getUserInfo() async{
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState(){
    getCurrentLocation();
    getUserInfo();
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
    getProducts();
    checkNetworkConnection().then((status) {
      if (!status) {
        Fluttertoast.showToast(
          msg: "No internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 2,
          backgroundColor: Colors.red,
          fontSize: 16
        );
      } else {
        print('Connected!');
        Fluttertoast.showToast(
            msg: "Connected",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.green,
            fontSize: 16
        );
      }
    });
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    print(_height);
    print(_width);

    _categories = retrieveCategories();

    return Stack(
      children: <Widget>[
        SafeArea(
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
                                          top: 16.0, right: 0.0, left: 12.0),
                                      child: Row(
                                        children: <Widget>[
                                          InkWell(
                                            child: Icon(Icons.menu, size: 30),
                                            onTap: (){
                                              setState(() {
                                                isCollapsed = !isCollapsed;
                                              });
                                            },
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Product Locator",
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(
                                                  _width >= 360 ? 21 : 25,
                                                  allowFontScalingSelf: true),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
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
                              height: ScreenUtil().setHeight(MediaQuery.of(context).size.height * 1.4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                  ),
                                  color: Color(0xFF6C00E9),
                              ),
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
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "e.g. Nike Airmax",
                                              hintStyle: TextStyle(color: Colors.white),
                                              labelText: "Search",
                                              labelStyle: TextStyle(color: Colors.white),
                                              border: OutlineInputBorder(
                                                gapPadding: 3.5,
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                          ),
                                            // ignore: missing_return
                                            validator: (value){
                                              if(value.isEmpty){
                                                Fluttertoast.showToast(
                                                  msg: "Search query can't be empty",
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.red,
                                                );
                                              }else{
                                                this.searchQuery = value;
                                              }
                                            },
                                        ),
                                      ),
                                    ),
                                      Positioned(
                                        right: 10,
                                        top: 20,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_forward),
                                          color: Colors.white,
                                          onPressed: (){
                                            if(_formKey.currentState.validate()){
                                              if(this.searchQuery != ""){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResults(this.searchQuery, this._products)));
                                              }
                                            }
                                          },
                                        ),
                                      )
                                    ],
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
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllProductsScreen(this._products)));
                                                },
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
                                            height: ScreenUtil().setHeight(210),
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: _categories.length,
                                                itemBuilder: (context, index){
                                                  return GestureDetector(
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewByCategory(_categories[index].query, _products)));
                                                  },
                                                  child: Card(
                                                    elevation: 24.0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      width: ScreenUtil().setWidth(150),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 150,
                                                            child: Image(
                                                              image: NetworkImage(_categories[index].backgroundImageUrl),
                                                              fit: BoxFit.cover,
                                                            )
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(10.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                Text(
                                                                  "Category",
                                                                  style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                                _categories[index].title2 != null ? Column(
                                                                  children: <Widget>[
                                                                    Text(_categories[index].title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                                                                    Text(_categories[index].title2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                                                                  ],
                                                                ) : Text(_categories[index].title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
        AnimatedPositioned(
          duration: Duration(milliseconds: 700),
          left: isCollapsed ? -1 * _width : 0,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                height: _height,
                width: _width,
                color: Color(0xFF6C00E9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Menu",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.white,
                            ),
                            onTap: (){
                              setState(() {
                                isCollapsed = true;
                              });
                              },
                          ),
                        ],
                      ),
                      SizedBox(height: _width * 0.2),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Card(
                                elevation: 10.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  width: _width,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "User Information",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: Card(
                                elevation: 10.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  width: _width,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Card(
                                  elevation: 10.0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                    width: _width,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async{
                                ProgressDialog pr = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
                                pr.style(
                                  message: 'Signing out...',
                                  borderRadius: 10.0,
                                  backgroundColor: Colors.white,
                                  progressWidget: SpinKitCircle(color: Color(0xFF6C00E9)),
                                  elevation: 24.0,
                                  insetAnimCurve: Curves.easeInOut,
                                  messageTextStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(19.0, allowFontScalingSelf: true),
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                                pr.show();
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('id', null);
                                await prefs.setString('username', null);
                                await prefs.setString('email', null);
                                await prefs.setString('mobileNumber', null);
                                await prefs.setBool('isVerified', null);
                                final username = prefs.getString('username');
                                if(username == null){
                                  pr.dismiss();
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
                                }else{
                                  pr.update(
                                    message: 'Failed to sign out. Try again',
                                    progressWidget: SpinKitCircle(color: Colors.red),
                                    messageTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(19.0, allowFontScalingSelf: true),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
