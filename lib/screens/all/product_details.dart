import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:link/models/product.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    ScreenUtil.init(context, allowFontScaling: true, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);

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
                    height: ScreenUtil().setHeight(MediaQuery.of(context).size.height / 2),
                    width: ScreenUtil().setWidth(MediaQuery.of(context).size.width),
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
                          size:30
                        ),
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
                      padding: const EdgeInsets.only(
                        top: 16.0
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Brand Name:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
                            ),
                          ),
                          Text(
                              "${this.product.name}",
                            style: TextStyle(
                              color: Colors.grey,
                            )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Product Name:",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
                            )
                          ),
                          Text(
                            "${this.product.model}",
                            style: TextStyle(
                              color: Colors.grey,
                            )
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0
                      ),
                      child: Text(
                        "Product Description",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
                        ),
                      ),
                    ),
                    this.product.description != null ? Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0
                      ),
                      child: Text(
                        "${this.product.description}",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ): Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Store didn't provide description",
                            style: TextStyle(
                              color: Colors.grey,
                            )
                          ),
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
                      padding: const EdgeInsets.only(
                        top: 16.0
                      ),
                      child: Text(
                        "Store Details",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(18, allowFontScalingSelf: true),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Name"
                        ),
                        this.product.storeName != null ? Text(
                          "${this.product.storeName}"
                        ): Text(
                          "n/a",
                          style: TextStyle(
                            color: Colors.grey
                          )
                        )
                      ]
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
