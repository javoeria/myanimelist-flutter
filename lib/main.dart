import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(kReleaseMode);
  FirebasePerformance.instance.setPerformanceCollectionEnabled(kReleaseMode);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await setupRemoteConfig();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs));
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 30),
    minimumFetchInterval: const Duration(hours: 6),
  ));
  remoteConfig.setDefaults({
    'v4_genres': false,
    'v4_magazines': false,
    'v4_producers': false,
    'v4_recommendations': false,
    'v4_reviews': false,
    'v4_watch': false,
  });
  await remoteConfig.fetchAndActivate();
  return remoteConfig;
}

class MyApp extends StatelessWidget {
  const MyApp(this.prefs, {super.key});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserData(prefs),
      builder: (context, child) {
        return MaterialApp(
          title: 'AnimeDB',
          themeMode: Provider.of<UserData>(context).themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: kMyAnimeListColor,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: kMyAnimeListColor,
            brightness: Brightness.dark,
          ),
          home: HomeScreen(prefs.getString('username')),
          navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
        );
      },
    );
  }
}
