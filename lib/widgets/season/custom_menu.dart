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
    if (month == 1) {
      return ['Summer ${year - 1}', 'Fall ${year - 1}', 'Winter $year', 'Spring $year'] + common;
    } else if (month >= 2 && month < 5) {
      return ['Fall ${year - 1}', 'Winter $year', 'Spring $year', 'Summer $year'] + common;
    } else if (month >= 5 && month < 8) {
      return ['Winter $year', 'Spring $year', 'Summer $year', 'Fall $year'] + common;
    } else if (month >= 8 && month < 11) {
      return ['Spring $year', 'Summer $year', 'Fall $year', 'Winter ${year + 1}'] + common;
    } else {
      return ['Summer $year', 'Fall $year', 'Winter ${year + 1}', 'Spring ${year + 1}'] + common;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return lastSeasons().map((season) => PopupMenuItem(child: Text(season), value: season)).toList();
      },
      onSelected: (String value) async {
        if (value == 'Later') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LaterScreen(),
              settings: RouteSettings(name: 'LaterScreen'),
            ),
          );
        } else if (value == 'Schedule') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleScreen(),
              settings: RouteSettings(name: 'ScheduleScreen'),
            ),
          );
        } else if (value == 'Archive') {
          String? newValue = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArchiveScreen(),
              settings: RouteSettings(name: 'ArchiveScreen'),
              fullscreenDialog: true,
            ),
          );
          if (newValue != null) {
            List<String> values = newValue.split(' ');
            int year = int.parse(values.elementAt(1));
            String type = values.elementAt(0);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SeasonalAnimeScreen(year: year, type: type),
                settings: RouteSettings(name: 'SeasonalAnimeScreen'),
              ),
            );
          }
        } else {
          List<String> values = value.split(' ');
          int year = int.parse(values.elementAt(1));
          String type = values.elementAt(0);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SeasonalAnimeScreen(year: year, type: type),
              settings: RouteSettings(name: 'SeasonalAnimeScreen'),
            ),
          );
        }
      },
    );
  }
}
