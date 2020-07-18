import 'package:flutter/material.dart';
import 'package:myanimelist/screens/archive_screen.dart';
import 'package:myanimelist/screens/later_screen.dart';
import 'package:myanimelist/screens/schedule_screen.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';

class CustomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(child: Text('Winter 2020'), value: 'Winter 2020'),
          PopupMenuItem(child: Text('Spring 2020'), value: 'Spring 2020'),
          PopupMenuItem(child: Text('Summer 2020'), value: 'Summer 2020'),
          PopupMenuItem(child: Text('Fall 2020'), value: 'Fall 2020'),
          PopupMenuItem(child: Text('Later'), value: 'Later'),
          PopupMenuItem(child: Text('Schedule'), value: 'Schedule'),
          PopupMenuItem(child: Text('Archive'), value: 'Archive'),
        ];
      },
      onSelected: (value) async {
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
          String newValue = await Navigator.push(
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
