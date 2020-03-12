import 'package:flutter/material.dart';
import 'package:link/models/product.dart';

// ignore: must_be_immutable
class ViewByCategory extends StatefulWidget {
  final String category;
  final List<Products> _products;
  List<Products> _byCategory;
  ViewByCategory(this.category, this._products);
  @override
  _ViewByCategoryState createState() => _ViewByCategoryState();
}

class _ViewByCategoryState extends State<ViewByCategory> {

  @override
  Widget build(BuildContext context) {
    this.widget._byCategory = (this.widget._products.where((element) => element.category == this.widget.category)).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6C00E9),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(this.widget.category),
      ),
    body: this.widget._byCategory.length == 0 ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.warning,color: Color(0xFF6C00E9),),
          Text("No data found"),
        ],
      ),
    ): ListView.builder(
      itemCount: this.widget._byCategory.length,
      itemBuilder: (context, index){
        return ListTile(
          leading: Image(image: NetworkImage(this.widget._byCategory[index].imageUrl)),
          title: Text(this.widget._byCategory[index].name, style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(this.widget._byCategory[index].model),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("\$${this.widget._byCategory[index].price}", style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        );
      }
    ),
    );
  }
}
