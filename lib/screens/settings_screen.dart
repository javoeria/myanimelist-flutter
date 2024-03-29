import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/home_screen.dart';
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
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <ListTile>[
          ListTile(
            title: Text(username == null ? 'Login' : 'Logout'),
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
                  MaterialPageRoute(builder: (context) => HomeScreen(prefs.getString('username'))),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
          ListTile(
            title: const Text('Kids'),
            subtitle: const Text('Show entries with Kids genres'),
            trailing: Switch(
              value: Provider.of<UserData>(context).kidsGenre,
              onChanged: (value) {
                FirebaseAnalytics.instance.logEvent(name: 'kids');
                Provider.of<UserData>(context, listen: false).toggleKids();
              },
            ),
          ),
          ListTile(
            title: const Text('R18+'),
            subtitle: const Text('Show entries with Hentai/Erotica genres'),
            trailing: Switch(
              value: Provider.of<UserData>(context).r18Genre,
              onChanged: (value) {
                FirebaseAnalytics.instance.logEvent(name: 'r18+');
                Provider.of<UserData>(context, listen: false).toggleR18();
              },
            ),
          ),
          ListTile(
            title: const Text('Dark mode'),
            subtitle: const Text('Choose between light and dark color palettes'),
            trailing: Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                FirebaseAnalytics.instance.logEvent(name: 'theme');
                Provider.of<UserData>(context, listen: false).toggleBrightness();
              },
            ),
          ),
          // ListTile(
          //   title: const Text('Clear history'),
          //   subtitle: const Text('Remove local searches from this device'),
          //   onTap: () {
          //     Provider.of<UserData>(context, listen: false).removeHistoryAll();
          //   },
          // ),
          ListTile(
            title: const Text('Rate app'),
            subtitle: const Text('Your feedback is very important to us'),
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
    builder: (context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <TextButton>[
          TextButton(
            child: const Text('NO'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('YES'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
    },
  );
}
