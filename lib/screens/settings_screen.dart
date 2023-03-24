import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/main.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/oauth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slack_notifier/slack_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen(this.prefs, this.packageInfo);

  final SharedPreferences prefs;
  final PackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    String? username = prefs.getString('username');
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: username == null ? Text('Login') : Text('Logout'),
            onTap: () async {
              bool? action = true;
              if (username == null) {
                if (kReleaseMode) {
                  FirebaseAnalytics.instance.logLogin();
                  username = await MalClient().login();
                } else {
                  username = 'javoeria';
                  await prefs.setString('username', username!);
                }
              } else {
                FirebaseAnalytics.instance.logEvent(name: 'logout');
                action = await _logoutDialog(context);
                if (action == true) {
                  await prefs.remove('username');
                  if (kReleaseMode) SlackNotifier(kSlackToken).send('User Logout $username', channel: 'jikan');
                }
              }

              if (username != null && action == true) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
          ListTile(
            title: Text('Kids'),
            subtitle: Text('Show entries with Kids genres'),
            trailing: Switch(
              value: Provider.of<UserData>(context).kidsGenre,
              // activeColor: Colors.indigo,
              onChanged: (value) {
                FirebaseAnalytics.instance.logEvent(name: 'kids');
                Provider.of<UserData>(context, listen: false).toggleKids();
              },
            ),
          ),
          ListTile(
            title: Text('R18+'),
            subtitle: Text('Show entries with Hentai/Erotica genres'),
            trailing: Switch(
              value: Provider.of<UserData>(context).r18Genre,
              // activeColor: Colors.indigo,
              onChanged: (value) {
                FirebaseAnalytics.instance.logEvent(name: 'r18+');
                Provider.of<UserData>(context, listen: false).toggleR18();
              },
            ),
          ),
          ListTile(
            title: Text('Dark mode'),
            subtitle: Text('Choose between light and dark color palettes'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              // activeColor: Colors.indigo,
              onChanged: (value) {
                FirebaseAnalytics.instance.logEvent(name: 'theme');
                Provider.of<UserData>(context, listen: false).toggleBrightness();
              },
            ),
          ),
          // ListTile(
          //   title: Text('Clear history'),
          //   subtitle: Text('Remove local searches from this device'),
          //   onTap: () {
          //     Provider.of<UserData>(context, listen: false).removeHistoryAll();
          //   },
          // ),
          ListTile(
            title: Text('Rate app'),
            subtitle: Text('Your feedback is very important to us'),
            onTap: () {
              FirebaseAnalytics.instance.logEvent(name: 'rate');
              RateMyApp(googlePlayIdentifier: kGooglePlayId).launchStore();
            },
          ),
          ListTile(
            title: Text('${packageInfo.appName} version'),
            subtitle: Text('${packageInfo.version}-${packageInfo.buildNumber}'),
          ),
        ],
      ),
    );
  }
}

Future<bool?> _logoutDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            child: Text('NO'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('YES'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
