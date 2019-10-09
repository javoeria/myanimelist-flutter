import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:charts_flutter/flutter.dart' as charts;

final NumberFormat f = NumberFormat.decimalPattern();

class AnimeStats extends StatefulWidget {
  AnimeStats(this.id);

  final int id;

  @override
  _AnimeStatsState createState() => _AnimeStatsState();
}

class _AnimeStatsState extends State<AnimeStats> with AutomaticKeepAliveClientMixin<AnimeStats> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: JikanApi().getAnimeStats(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        Stats stats = snapshot.data;
        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Summary Stats', style: Theme.of(context).textTheme.title),
                  SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: 'Watching: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: f.format(stats.watching), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        RichText(
                          text: TextSpan(
                            text: 'Completed: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: f.format(stats.completed), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        RichText(
                          text: TextSpan(
                            text: 'On-Hold: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: f.format(stats.onHold), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        RichText(
                          text: TextSpan(
                            text: 'Dropped: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: f.format(stats.dropped), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        RichText(
                          text: TextSpan(
                            text: 'Plan to Watch: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: f.format(stats.planToWatch), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0),
                        RichText(
                          text: TextSpan(
                            text: 'Total: ',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: f.format(stats.total), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Score Stats', style: Theme.of(context).textTheme.title),
                  Container(
                    child: HorizontalBarChart(stats.scores),
                    height: 400.0,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HorizontalBarChart extends StatelessWidget {
  HorizontalBarChart(this.scores);

  final Scores scores;

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      _scoreData(),
      animate: false,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      // domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );
  }

  List<charts.Series<ScoreStats, String>> _scoreData() {
    final data = [
      ScoreStats('10', scores.score10),
      ScoreStats('9', scores.score9),
      ScoreStats('8', scores.score8),
      ScoreStats('7', scores.score7),
      ScoreStats('6', scores.score6),
      ScoreStats('5', scores.score5),
      ScoreStats('4', scores.score4),
      ScoreStats('3', scores.score3),
      ScoreStats('2', scores.score2),
      ScoreStats('1', scores.score1),
    ];

    return [
      charts.Series<ScoreStats, String>(
        id: 'Score Stats',
        domainFn: (ScoreStats stats, _) => stats.label,
        measureFn: (ScoreStats stats, _) => stats.score.votes,
        data: data,
        labelAccessorFn: (ScoreStats stats, _) => '${stats.score.percentage}% (${stats.score.votes} votes)',
      ),
    ];
  }
}

class ScoreStats {
  final String label;
  final Score score;

  ScoreStats(this.label, this.score);
}
