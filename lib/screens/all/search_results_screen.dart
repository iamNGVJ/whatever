import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link/models/product.dart';

class SearchResults extends StatefulWidget {
  final String query;
  final List<Products> _products;
  SearchResults(this.query, this._products);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  List<Products> _results;


  // ignore: missing_return
  Future<List<Products>> searchProduct(value)async{
    var result = this.widget._products.where((product) => product.name == value);
    if(result != null){
      return result;
    }else{
      Fluttertoast.showToast(
        msg: "Can't fetch results",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget._products);
    _results = (this.widget._products.where((element) => element.name.toString() == this.widget.query.toString())).toList();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Product Locator",
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${this.widget.query}",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _results.length != 0 ? ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index){
              return _results != null ? ListTile(
                title: Text("${_results[index].name}"),
              ) : Icon(Icons.face);
            },
          ): Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitCircle(color: Colors.blue),
                Text(
                  "Searching",
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
