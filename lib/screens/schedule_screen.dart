import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/widgets/season/custom_menu.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

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
            tabs: const <Tab>[
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
          children: const <Widget>[
            ScheduleList(type: WeekDay.monday),
            ScheduleList(type: WeekDay.tuesday),
            ScheduleList(type: WeekDay.wednesday),
            ScheduleList(type: WeekDay.thursday),
            ScheduleList(type: WeekDay.friday),
            ScheduleList(type: WeekDay.saturday),
            ScheduleList(type: WeekDay.sunday),
            ScheduleList(type: WeekDay.other),
            ScheduleList(type: WeekDay.unknown),
          ],
        ),
      ),
    );
  }
}

class ScheduleList extends StatefulWidget {
  const ScheduleList({this.type});

  final WeekDay? type;

  @override
  _ScheduleListState createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> with AutomaticKeepAliveClientMixin<ScheduleList> {
  late Future<BuiltList<Anime>> _future;

  @override
  void initState() {
    super.initState();
    _future = Jikan().getSchedules(weekday: widget.type);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<BuiltList<Anime>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        return SeasonList(BuiltList(snapshot.data!.reversed));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
