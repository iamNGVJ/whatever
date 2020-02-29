import 'package:flutter/material.dart';
import 'package:link/models/product.dart';

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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
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
                            fontSize: 20,
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
              )
            ],
          ),
        ),
      ),
      ),
    );
  }
}
