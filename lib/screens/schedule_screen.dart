import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:myanimelist/widgets/custom_menu.dart';

final NumberFormat f = NumberFormat.decimalPattern();
final DateFormat dateFormat = DateFormat('MMM d, yyyy, HH:mm');

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
          actions: <Widget>[
            CustomMenu(),
          ],
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
  BuiltList<Anime> animeBuiltList(Schedule schedule) {
    String dayString = widget.day.toString();
    switch (dayString) {
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

  String producersText(BuiltList<Producer> producers) {
    if (producers.length == 0) {
      return '-';
    } else {
      List<String> names = [];
      for (Producer p in producers) {
        names.add(p.name);
      }
      return names.join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: JikanApi().getSchedule(weekday: widget.day),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Anime> animeList = animeBuiltList(snapshot.data);
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: animeList.length,
          itemBuilder: (context, index) {
            Anime anime = animeList.elementAt(index);
            String episodes = anime.episodes == null ? '?' : anime.episodes.toString();
            String score = anime.score == null ? 'N/A' : anime.score.toString();
            DateTime dateTime = DateTime.parse(anime.airingStart).add(Duration(hours: 9));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(anime.title, style: Theme.of(context).textTheme.title),
                  SizedBox(height: 4.0),
                  Text(producersText(anime.producers) + ' | $episodes eps | ' + anime.source, style: Theme.of(context).textTheme.body1),
                  Wrap(
                    children: anime.genres.map((genre) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Chip(label: Text(genre.name, style: Theme.of(context).textTheme.overline)),
                      );
                    }).toList(),
                  ),
                  Container(
                    height: 242.0,
                    child: Row(
                      children: <Widget>[
                        Image.network(anime.imageUrl, height: 242.0, width: 167.0, fit: BoxFit.cover),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Text(anime.synopsis, style: Theme.of(context).textTheme.caption),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(anime.type + ' - ' + dateFormat.format(dateTime) + ' (JST)', style: Theme.of(context).textTheme.body1),
                      Row(
                        children: <Widget>[
                          Icon(Icons.star_border, color: Colors.grey, size: 20.0),
                          Text(score, style: Theme.of(context).textTheme.body1),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.person_outline, color: Colors.grey, size: 20.0),
                          Text(f.format(anime.members), style: Theme.of(context).textTheme.body1),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
