import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link/models/product.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:link/screens/all/map_screen.dart';

class ProductDetails extends StatefulWidget {
  final Products product;
  ProductDetails(this.product);
  @override
  _ProductDetailsState createState() => _ProductDetailsState(this.product);
}

class _ProductDetailsState extends State<ProductDetails> {
  Products product;
  _ProductDetailsState(this.product);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        allowFontScaling: true,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height);
    print(this.product.size);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil()
                          .setHeight(MediaQuery.of(context).size.height / 2),
                      width: ScreenUtil()
                          .setWidth(MediaQuery.of(context).size.width),
                      child: Hero(
                        tag: "${this.product.imageUrl}",
                        child: Image(
                          image: NetworkImage(this.product.imageUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Product Details",
                          style: TextStyle(
                              fontSize: ScreenUtil()
                                  .setSp(20, allowFontScalingSelf: true),
                              fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.close, size: 30),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Brand Name",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil()
                                    .setSp(18, allowFontScalingSelf: true),
                              ),
                            ),
                            Text("${this.product.name}",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Product Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil()
                                      .setSp(18, allowFontScalingSelf: true),
                                )),
                            Text("${this.product.model}",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Size",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil()
                                    .setSp(18, allowFontScalingSelf: true),
                              ),
                            ),
                            this.product.size != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${this.product.size}",
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "n/a",
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Price",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil()
                                    .setSp(18, allowFontScalingSelf: true),
                              ),
                            ),
                            this.product.price != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "RTGS\$ ${this.product.price}",
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "n/a",
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Product Description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil()
                                .setSp(18, allowFontScalingSelf: true),
                          ),
                        ),
                      ),
                      this.product.description != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "${this.product.description}",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Store didn't provide description",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(10),
                                  ),
                                  Icon(
                                    Icons.error_outline,
                                    size: 20,
                                    color: Colors.red,
                                  )
                                ],
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Store Details",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil()
                                .setSp(18, allowFontScalingSelf: true),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Name",
                                style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(15, allowFontScalingSelf: true),
                                    fontWeight: FontWeight.w400),
                              ),
                              this.product.storeName != null
                                  ? Text("${this.product.storeName}")
                                  : Text("n/a",
                                      style: TextStyle(color: Colors.grey))
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Address",
                              style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(15, allowFontScalingSelf: true),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            this.product.storeAddress != null
                                ? Text(
                                    "${this.product.storeAddress}",
                                  )
                                : Text(
                                    "n/a",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Location",
                              style: TextStyle(
                                fontSize: ScreenUtil()
                                    .setSp(15, allowFontScalingSelf: true),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            this.product.storeLatitude != null &&
                                    this.product.storeLongitude != null
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MapScreen(this.product.storeLatitude, this.product.storeLongitude))
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: ScreenUtil().setHeight(30),
                                      width: ScreenUtil().setWidth(100),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: Text(
                                        "View on map",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Location not accessible",
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
