import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() async {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setString('username', 'javoeria');
  print(prefs.getKeys());
  runApp(MyApp(prefs));
}

class MyApp extends StatelessWidget {
  MyApp(this.prefs);

  final SharedPreferences prefs;
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserData(prefs),
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: brightness == Brightness.light ? Colors.indigo : Colors.blue,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'MyAnimeList',
            theme: theme,
            home: LoadingScreen(),
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
          );
        },
      ),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final JikanApi jikanApi = JikanApi();

  UserProfile profile;
  Season season;
  BuiltList<Top> topAiring;
  BuiltList<Top> topUpcoming;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  SeasonType seasonClass(String season) {
    switch (season.toLowerCase()) {
      case 'spring':
        return SeasonType.spring;
        break;
      case 'summer':
        return SeasonType.summer;
        break;
      case 'fall':
        return SeasonType.fall;
        break;
      case 'winter':
        return SeasonType.winter;
        break;
      default:
        throw 'SeasonType Error';
    }
  }

  void load() async {
    final Trace mainTrace = FirebasePerformance.instance.newTrace('main_trace');
    mainTrace.start();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
    remoteConfig.setDefaults(<String, dynamic>{'year': 2019, 'season': 'fall'});
    try {
      await remoteConfig.fetch();
      await remoteConfig.activateFetched();
    } catch (e) {
      print(e);
    }

    String username = prefs.getString('username');
    int year = remoteConfig.getInt('year');
    SeasonType seasonType = seasonClass(remoteConfig.getString('season'));
    if (username != null) {
      profile = await jikanApi.getUserProfile(username);
    }
    season = await jikanApi.getSeason(year, seasonType);
    topAiring = await jikanApi.getTop(TopType.anime, page: 1, subtype: TopSubtype.airing);
    topUpcoming = await jikanApi.getTop(TopType.anime, page: 1, subtype: TopSubtype.upcoming);
    mainTrace.stop();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return HomeScreen(profile, season, topAiring, topUpcoming);
    }
  }
}
