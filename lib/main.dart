import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => UserData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoadingScreen(),
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

  bool loading = true;
  ProfileResult profile;
  Season season;
  BuiltList<Top> topAiring;
  BuiltList<Top> topUpcoming;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    profile = await jikanApi.getUserProfile('javoeria');
    season = await jikanApi.getSeason(2019, Fall());
    topAiring = await jikanApi.getTop(TopType.anime, page: 1, subtype: TopSubtype.airing);
    topUpcoming = await jikanApi.getTop(TopType.anime, page: 1, subtype: TopSubtype.upcoming);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return HomeScreen(profile, season, topAiring, topUpcoming);
    }
  }
}
