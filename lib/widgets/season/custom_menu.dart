import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/screens/archive_screen.dart';
import 'package:myanimelist/screens/later_screen.dart';
import 'package:myanimelist/screens/schedule_screen.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';

class CustomMenu extends StatelessWidget {
  SeasonType seasonClass(String season) {
    switch (season) {
      case 'Fall':
        return Fall();
        break;
      case 'Summer':
        return Summer();
        break;
      case 'Spring':
        return Spring();
        break;
      case 'Winter':
        return Winter();
        break;
      default:
        throw 'Season Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(child: Text('Spring 2019'), value: 'Spring 2019'),
          PopupMenuItem(child: Text('Summer 2019'), value: 'Summer 2019'),
          PopupMenuItem(child: Text('Fall 2019'), value: 'Fall 2019'),
          PopupMenuItem(child: Text('Winter 2020'), value: 'Winter 2020'),
          PopupMenuItem(child: Text('Later'), value: 'Later'),
          PopupMenuItem(child: Text('Schedule'), value: 'Schedule'),
          PopupMenuItem(child: Text('Archive'), value: 'Archive'),
        ];
      },
      onSelected: (value) async {
        if (value == 'Later') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LaterScreen()));
        } else if (value == 'Schedule') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ScheduleScreen()));
        } else if (value == 'Archive') {
          String newValue = await Navigator.push(context, MaterialPageRoute(builder: (context) => ArchiveScreen(), fullscreenDialog: true));
          if (newValue != null) {
            List<String> values = newValue.split(' ');
            int year = int.parse(values.elementAt(1));
            SeasonType type = seasonClass(values.elementAt(0));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SeasonalAnimeScreen(year: year, type: type)));
          }
        } else {
          List<String> values = value.split(' ');
          int year = int.parse(values.elementAt(1));
          SeasonType type = seasonClass(values.elementAt(0));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SeasonalAnimeScreen(year: year, type: type)));
        }
      },
    );
  }
}
