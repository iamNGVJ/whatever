import 'package:flutter/material.dart';
import 'package:link/models/product.dart';

class AllProductsScreen extends StatelessWidget {
  final List<Products> _products;
  AllProductsScreen(this._products);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("All Products"),
        backgroundColor: Color(0xFF6C00E9),
      ),
      body: this._products.length != 0 ? ListView.builder(
        itemCount: this._products.length,
        itemBuilder: (context, index){
          return ListTile(
            leading: Image(
              image: NetworkImage(this._products[index].imageUrl),
              height: 60,
              width: 60,
            ),
            title: Text(this._products[index].name, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text(this._products[index].model,),
          );
        },
      ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.warning),
            Text("No products available",),
          ]
        ),
      )
    );
  }
}
