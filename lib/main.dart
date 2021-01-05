import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:slack_notifier/slack_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  if (kReleaseMode) SlackNotifier(kSlackToken).send('main', channel: 'jikan');
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
      create: (context) => UserData(prefs),
      child: DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: brightness == Brightness.light ? Colors.indigo : Colors.blue,
          brightness: brightness,
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'AnimeDB',
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
  final Jikan jikan = Jikan();

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
    String username = prefs.getString('username');
    if (username != null) {
      profile = await jikan.getUserProfile(username);
    }
    season = await jikan.getSeason();
    topAiring = await jikan.getTop(TopType.anime, subtype: TopSubtype.airing);
    topUpcoming = await jikan.getTop(TopType.anime, subtype: TopSubtype.upcoming);
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
