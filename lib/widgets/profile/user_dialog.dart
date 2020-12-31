import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDialog extends StatefulWidget {
  UserDialog({this.username});

  final String username;

  @override
  _UserDialogState createState() => _UserDialogState();
}

class _UserDialogState extends State<UserDialog> {
  final TextEditingController _textFieldController = TextEditingController();
  String _error;

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('MAL Username'),
      content: TextField(
        autofocus: true,
        controller: _textFieldController,
        decoration: InputDecoration(errorText: _error),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: () async {
            String text = _textFieldController.text;
            setState(() => _error = null);
            if (text == '' || text == widget.username) {
              Navigator.pop(context);
            } else {
              try {
                await Jikan().getUserProfile(text);
                if (kReleaseMode) {
                  FirebaseFirestore.instance.collection('users').add({'username': text, 'datetime': DateTime.now()});
                }
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('username', text);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                  (Route<dynamic> route) => false,
                );
              } catch (e) {
                print(e);
                setState(() => _error = 'User not found');
              }
            }
          },
        )
      ],
    );
  }
}
