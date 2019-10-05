import 'package:flutter/material.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:provider/provider.dart';

class CustomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Provider.of<UserData>(context).gridView ? Icon(Icons.view_headline) : Icon(Icons.apps),
      onPressed: () {
        Provider.of<UserData>(context).toogleView();
      },
    );
  }
}
