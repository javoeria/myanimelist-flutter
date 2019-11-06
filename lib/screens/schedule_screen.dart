import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
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
            WeekDayList(day: WeekDay.monday),
            WeekDayList(day: WeekDay.tuesday),
            WeekDayList(day: WeekDay.wednesday),
            WeekDayList(day: WeekDay.thursday),
            WeekDayList(day: WeekDay.friday),
            WeekDayList(day: WeekDay.saturday),
            WeekDayList(day: WeekDay.sunday),
            WeekDayList(day: WeekDay.other),
            WeekDayList(day: WeekDay.unknown),
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

  BuiltList<AnimeItem> animeBuiltList(Schedule schedule) {
    switch (describeEnum(widget.day)) {
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
    _future = Jikan().getSchedule(weekday: widget.day);
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

        BuiltList<AnimeItem> animeList = animeBuiltList(snapshot.data);
        if (animeList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        animeList = BuiltList.from(animeList.where((anime) => anime.kids == false && anime.r18 == false));
        return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 0.0),
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              AnimeItem anime = animeList.elementAt(index);
              return SeasonInfo(anime);
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
