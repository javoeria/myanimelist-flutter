import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_info.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Schedule'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Monday'),
              Tab(text: 'Tuesday'),
              Tab(text: 'Wednesday'),
              Tab(text: 'Thursday'),
              Tab(text: 'Friday'),
              Tab(text: 'Saturday'),
              Tab(text: 'Sunday'),
              Tab(text: 'Other'),
              Tab(text: 'Unknown'),
            ],
          ),
          actions: <Widget>[CustomMenu()],
        ),
        body: TabBarView(
          children: [
            WeekDayList(day: Monday()),
            WeekDayList(day: Tuesday()),
            WeekDayList(day: Wednesday()),
            WeekDayList(day: Thursday()),
            WeekDayList(day: Friday()),
            WeekDayList(day: Saturday()),
            WeekDayList(day: Sunday()),
            WeekDayList(day: Other()),
            WeekDayList(day: Unknown()),
          ],
        ),
      ),
    );
  }
}

class WeekDayList extends StatefulWidget {
  WeekDayList({this.day});

  final WeekDay day;

  @override
  _WeekDayListState createState() => _WeekDayListState();
}

class _WeekDayListState extends State<WeekDayList> with AutomaticKeepAliveClientMixin<WeekDayList> {
  Future<Schedule> _future;

  BuiltList<Anime> animeBuiltList(Schedule schedule) {
    switch (widget.day.toString()) {
      case 'monday':
        return schedule.monday;
        break;
      case 'tuesday':
        return schedule.tuesday;
        break;
      case 'wednesday':
        return schedule.wednesday;
        break;
      case 'thursday':
        return schedule.thursday;
        break;
      case 'friday':
        return schedule.friday;
        break;
      case 'saturday':
        return schedule.saturday;
        break;
      case 'sunday':
        return schedule.sunday;
        break;
      case 'other':
        return schedule.other;
        break;
      case 'unknown':
        return schedule.unknown;
        break;
      default:
        throw 'Schedule Error';
    }
  }

  @override
  void initState() {
    super.initState();
    _future = JikanApi().getSchedule(weekday: widget.day);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Anime> animeList = animeBuiltList(snapshot.data);
        animeList = BuiltList.from(animeList.where((anime) => anime.kids == false && anime.r18 == false));
        return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 0.0),
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              Anime anime = animeList.elementAt(index);
              return InkWell(
                child: SeasonInfo(anime),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AnimeScreen(anime.malId, anime.title)));
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
