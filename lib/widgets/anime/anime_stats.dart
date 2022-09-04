import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:jikan_api/jikan_api.dart';

class AnimeStats extends StatefulWidget {
  const AnimeStats(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  _AnimeStatsState createState() => _AnimeStatsState();
}

class _AnimeStatsState extends State<AnimeStats> with AutomaticKeepAliveClientMixin<AnimeStats> {
  final NumberFormat f = NumberFormat.decimalPattern();
  late Future<Stats> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? Jikan().getAnimeStatistics(widget.id) : Jikan().getMangaStatistics(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<Stats> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // print(snapshot.error);
          return ListTile(title: Text('No items found.'));
        }

        Stats stats = snapshot.data!;
        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Summary Stats', style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.anime
                          ? RichText(
                              text: TextSpan(
                                text: 'Watching: ',
                                style: Theme.of(context).textTheme.bodyText1,
                                children: <TextSpan>[
                                  TextSpan(text: f.format(stats.watching), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                text: 'Reading: ',
                                style: Theme.of(context).textTheme.bodyText1,
                                children: <TextSpan>[
                                  TextSpan(text: f.format(stats.reading), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Completed: ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: <TextSpan>[
                            TextSpan(text: f.format(stats.completed), style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'On-Hold: ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: <TextSpan>[
                            TextSpan(text: f.format(stats.onHold), style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Dropped: ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: <TextSpan>[
                            TextSpan(text: f.format(stats.dropped), style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      widget.anime
                          ? RichText(
                              text: TextSpan(
                                text: 'Plan to Watch: ',
                                style: Theme.of(context).textTheme.bodyText1,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: f.format(stats.planToWatch), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                text: 'Plan to Read: ',
                                style: Theme.of(context).textTheme.bodyText1,
                                children: <TextSpan>[
                                  TextSpan(text: f.format(stats.planToRead), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Total: ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: <TextSpan>[
                            TextSpan(text: f.format(stats.total), style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                    ],
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
                  Text('Score Stats', style: Theme.of(context).textTheme.headline6),
                  SizedBox(
                    height: 400.0,
                    child: HorizontalBarChart(stats.scores),
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
  const HorizontalBarChart(this.scores);

  final BuiltList<Score> scores;

  @override
  Widget build(BuildContext context) {
    bool light = Theme.of(context).brightness == Brightness.light;
    return charts.BarChart(
      _scoreData(),
      animate: false,
      vertical: false,
      defaultInteractions: false,
      barRendererDecorator: light
          ? charts.BarLabelDecorator<String>()
          : charts.BarLabelDecorator<String>(
              insideLabelStyleSpec: charts.TextStyleSpec(color: charts.MaterialPalette.white),
              outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
      primaryMeasureAxis: light
          ? charts.NumericAxisSpec()
          : charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.gray.shade700),
              ),
            ),
      domainAxis: light
          ? charts.OrdinalAxisSpec()
          : charts.OrdinalAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.transparent),
              ),
            ),
    );
  }

  List<charts.Series<ScoreStats, String>> _scoreData() {
    final List<ScoreStats> data = [
      ScoreStats('10', scores[9]),
      ScoreStats('9', scores[8]),
      ScoreStats('8', scores[7]),
      ScoreStats('7', scores[6]),
      ScoreStats('6', scores[5]),
      ScoreStats('5', scores[4]),
      ScoreStats('4', scores[3]),
      ScoreStats('3', scores[2]),
      ScoreStats('2', scores[1]),
      ScoreStats('1', scores[0]),
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
