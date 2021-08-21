import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:slack_notifier/slack_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAnalytics().setAnalyticsCollectionEnabled(kReleaseMode);
  FirebasePerformance.instance.setPerformanceCollectionEnabled(kReleaseMode);
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await setupRemoteConfig();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs));
}

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  remoteConfig.setDefaults(<String, dynamic>{
    'v4_genres': false,
    'v4_magazines': false,
    'v4_producers': false,
    'v4_recommendations': false,
    'v4_reviews': false,
    'v4_watch': false,
  });
  try {
    await remoteConfig.fetchAndActivate();
  } on PlatformException catch (e) {
    print(e);
  }
  return remoteConfig;
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
        defaultBrightness: WidgetsBinding.instance!.window.platformBrightness,
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

  UserProfile? profile;
  late Season season;
  late BuiltList<Top> topAiring;
  late BuiltList<Top> topUpcoming;
  List<dynamic>? suggestions;
  late RemoteConfig remoteConfig;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final Trace mainTrace = FirebasePerformance.instance.newTrace('main_trace');
    mainTrace.start();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      profile = await jikan.getUserProfile(username);
      suggestions = await MalClient().getSuggestions();
      if (kReleaseMode) SlackNotifier(kSlackToken).send('Main $username', channel: 'jikan');
    }
    season = await jikan.getSeason();
    topAiring = await jikan.getTop(TopType.anime, subtype: TopSubtype.airing);
    topUpcoming = await jikan.getTop(TopType.anime, subtype: TopSubtype.upcoming);
    remoteConfig = RemoteConfig.instance;
    mainTrace.stop();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      return HomeScreen(profile, season, topAiring, topUpcoming, suggestions, remoteConfig);
    }
  }
}
