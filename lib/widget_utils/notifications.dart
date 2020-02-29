import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class Notifications{
  BuildContext context;
  Notifications(this.context);

  showNetworkError(){
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
            size: const Size(40, 40),
            child: ClipOval(
              child: Container(
                color: Colors.black,
              )
            )
          ),
          title: Text('FilledStacks'),
          subtitle: Text('Thanks for checking out my tutorial'),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              OverlaySupportEntry.of(this.context).dismiss();
            },
          ),
        ),
      ),
    );
  }
}