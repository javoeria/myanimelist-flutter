import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';

class AnimeStatsSection extends StatelessWidget {
  AnimeStatsSection(this.stats);

  final UserStats stats;
  final NumberFormat f = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 32.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Anime Stats', style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Days: ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: stats.daysWatched.toString(), style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Mean Score: ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: stats.meanScore.toString(), style: Theme.of(context).textTheme.bodyText1),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: stats.totalEntries == 0
                ? Container(
                    height: 32.0,
                    width: screenWidth,
                    color: Colors.grey[300],
                  )
                : Row(
                    children: <Widget>[
                      Container(
                        height: 32.0,
                        width: stats.watching / stats.totalEntries * screenWidth,
                        color: kWatchingColor,
                      ),
                      Container(
                        height: 32.0,
                        width: stats.completed / stats.totalEntries * screenWidth,
                        color: kCompletedColor,
                      ),
                      Container(
                        height: 32.0,
                        width: stats.onHold / stats.totalEntries * screenWidth,
                        color: kOnHoldColor,
                      ),
                      Container(
                        height: 32.0,
                        width: stats.dropped / stats.totalEntries * screenWidth,
                        color: kDroppedColor,
                      ),
                      Container(
                        height: 32.0,
                        width: stats.planToWatch / stats.totalEntries * screenWidth,
                        color: kPlantoWatchColor,
                      ),
                    ],
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(backgroundColor: kWatchingColor, radius: 10.0),
                      SizedBox(width: 8.0),
                      Text('Watching: ${f.format(stats.watching)}'),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      CircleAvatar(backgroundColor: kCompletedColor, radius: 10.0),
                      SizedBox(width: 8.0),
                      Text('Completed: ${f.format(stats.completed)}'),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      CircleAvatar(backgroundColor: kOnHoldColor, radius: 10.0),
                      SizedBox(width: 8.0),
                      Text('On-Hold: ${f.format(stats.onHold)}'),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      CircleAvatar(backgroundColor: kDroppedColor, radius: 10.0),
                      SizedBox(width: 8.0),
                      Text('Dropped: ${f.format(stats.dropped)}'),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: <Widget>[
                      CircleAvatar(backgroundColor: kPlantoWatchColor, radius: 10.0),
                      SizedBox(width: 8.0),
                      Text('Plan to Watch: ${f.format(stats.planToWatch)}'),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total Entries: ${f.format(stats.totalEntries)}'),
                  SizedBox(height: 16.0),
                  Text('Rewatched: ${f.format(stats.rewatched)}'),
                  SizedBox(height: 16.0),
                  Text('Episodes: ${f.format(stats.episodesWatched)}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
