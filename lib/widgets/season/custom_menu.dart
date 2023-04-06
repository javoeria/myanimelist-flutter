import 'package:flutter/material.dart';
import 'package:myanimelist/screens/archive_screen.dart';
import 'package:myanimelist/screens/later_screen.dart';
import 'package:myanimelist/screens/schedule_screen.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';

class CustomMenu extends StatelessWidget {
  List<String> lastSeasons() {
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    List<String> common = ['Later', 'Schedule', 'Archive'];
    if (month < 4) {
      return ['Fall ${year - 1}', 'Winter $year', 'Spring $year', 'Summer $year'] + common;
    } else if (month >= 4 && month < 7) {
      return ['Winter $year', 'Spring $year', 'Summer $year', 'Fall $year'] + common;
    } else if (month >= 7 && month < 10) {
      return ['Spring $year', 'Summer $year', 'Fall $year', 'Winter ${year + 1}'] + common;
    } else {
      return ['Summer $year', 'Fall $year', 'Winter ${year + 1}', 'Spring ${year + 1}'] + common;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return lastSeasons().map((season) => PopupMenuItem(value: season, child: Text(season))).toList();
      },
      onSelected: (value) async {
        if (value == 'Later') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LaterScreen(),
              settings: const RouteSettings(name: 'LaterScreen'),
            ),
          );
        } else if (value == 'Schedule') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleScreen(),
              settings: const RouteSettings(name: 'ScheduleScreen'),
            ),
          );
        } else if (value == 'Archive') {
          String? newValue = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArchiveScreen(),
              settings: const RouteSettings(name: 'ArchiveScreen'),
              fullscreenDialog: true,
            ),
          );
          if (newValue != null) {
            List<String> values = newValue.split(' ');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SeasonalAnimeScreen(year: int.parse(values[1]), season: values[0]),
                settings: const RouteSettings(name: 'SeasonalAnimeScreen'),
              ),
            );
          }
        } else {
          List<String> values = value.split(' ');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SeasonalAnimeScreen(year: int.parse(values[1]), season: values[0]),
              settings: const RouteSettings(name: 'SeasonalAnimeScreen'),
            ),
          );
        }
      },
    );
  }
}
