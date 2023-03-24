import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';

class MangaStatsSection extends StatelessWidget {
  MangaStatsSection(this.stats);

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
              Text('Manga Stats', style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Days: ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: stats.daysRead.toString(), style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Mean Score: ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: stats.meanScore.toString(), style: Theme.of(context).textTheme.titleSmall),
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
                        width: stats.reading! / stats.totalEntries * screenWidth,
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
                        width: stats.planToRead! / stats.totalEntries * screenWidth,
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
                      Text('Reading: ${f.format(stats.reading)}'),
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
                      Text('Plan to Read: ${f.format(stats.planToRead)}'),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Total Entries: ${f.format(stats.totalEntries)}'),
                  SizedBox(height: 16.0),
                  Text('Reread: ${f.format(stats.reread)}'),
                  SizedBox(height: 16.0),
                  Text('Chapters: ${f.format(stats.chaptersRead)}'),
                  SizedBox(height: 16.0),
                  Text('Volumes: ${f.format(stats.volumesRead)}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
