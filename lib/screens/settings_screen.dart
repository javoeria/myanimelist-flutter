import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:myanimelist/widgets/profile/user_dialog.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:myanimelist/models/user_data.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen(this.prefs, this.packageInfo);

  final SharedPreferences prefs;
  final PackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    String username = prefs.getString('username');
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Username'),
            subtitle: username != null ? Text(username) : null,
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (context) => UserDialog(username: username),
              );
            },
          ),
          ListTile(
            title: Text('Kids'),
            subtitle: Text('Show entries with Kids genres.'),
            trailing: Checkbox(
              value: false,
              activeColor: Colors.indigo,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: Text('R18+'),
            subtitle: Text('Show entries with Hentai/Yaoi/Yuri genres.'),
            trailing: Checkbox(
              value: false,
              activeColor: Colors.indigo,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: Text('Night mode'),
            subtitle: Text('Enable/disable app dark theme.'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              activeColor: Colors.indigo,
              onChanged: (value) {
                DynamicTheme.of(context).setBrightness(
                    Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark);
              },
            ),
          ),
          ListTile(
            title: Text('Clear history'),
            subtitle: Text('Remove local searches from this device.'),
            onTap: () {
              Provider.of<UserData>(context).removeHistoryAll();
            },
          ),
          ListTile(
            title: Text('Rate this app'),
            subtitle: Text('Your feedback is very important to us.'),
            onTap: () {},
          ),
          ListTile(
            title: Text('MyAnimeList version'),
            subtitle: Text(packageInfo.version),
          ),
        ],
      ),
    );
  }
}
