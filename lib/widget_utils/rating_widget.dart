import 'package:flutter/material.dart';

class StarsRating extends StatelessWidget {
  final int rating;
  StarsRating(this.rating);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: this.rating,
        itemBuilder: (context, index){
          return Icon(Icons.star, color: Colors.yellow, size: 5);
        },
      )
    );
  }
}
