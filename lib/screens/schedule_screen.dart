import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
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
          actions: [CustomMenu()],
        ),
        body: TabBarView(
          children: const <ScheduleList>[
            ScheduleList(day: WeekDay.monday),
            ScheduleList(day: WeekDay.tuesday),
            ScheduleList(day: WeekDay.wednesday),
            ScheduleList(day: WeekDay.thursday),
            ScheduleList(day: WeekDay.friday),
            ScheduleList(day: WeekDay.saturday),
            ScheduleList(day: WeekDay.sunday),
            ScheduleList(day: WeekDay.other),
            ScheduleList(day: WeekDay.unknown),
          ],
        ),
      ),
    );
  }
}

class ScheduleList extends StatefulWidget {
  const ScheduleList({this.day});

  final WeekDay? day;

  @override
  _ScheduleListState createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> with AutomaticKeepAliveClientMixin<ScheduleList> {
  late Future<BuiltList<Anime>> _future;

  @override
  void initState() {
    super.initState();
    _future = jikan.getSchedules(weekday: widget.day);
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

        return SeasonList(snapshot.data!.reversed.toBuiltList());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
