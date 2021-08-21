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
            tabs: const [
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
        body: FutureBuilder(
          future: Jikan().getSchedule(),
          builder: (context, AsyncSnapshot<Schedule> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            Schedule schedule = snapshot.data!;
            return TabBarView(
              children: [
                SeasonList(schedule.monday!),
                SeasonList(schedule.tuesday!),
                SeasonList(schedule.wednesday!),
                SeasonList(schedule.thursday!),
                SeasonList(schedule.friday!),
                SeasonList(schedule.saturday!),
                SeasonList(schedule.sunday!),
                SeasonList(schedule.other!),
                SeasonList(schedule.unknown!),
              ],
            );
          },
        ),
      ),
    );
  }
}
