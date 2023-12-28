import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';

class AnimeStats extends StatefulWidget {
  const AnimeStats(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  State<AnimeStats> createState() => _AnimeStatsState();
}

class _AnimeStatsState extends State<AnimeStats> with AutomaticKeepAliveClientMixin<AnimeStats> {
  late Future<Stats> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? jikan.getAnimeStatistics(widget.id) : jikan.getMangaStatistics(widget.id);
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
        if (snapshot.hasError) {
          // print(snapshot.error);
          return ListTile(title: Text('No items found.'));
        }

        final Stats stats = snapshot.data!;
        return ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Summary Stats', style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.anime
                          ? RichText(
                              text: TextSpan(
                                text: 'Watching: ',
                                style: Theme.of(context).textTheme.titleSmall,
                                children: <TextSpan>[
                                  TextSpan(text: stats.watching!.decimal(), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                text: 'Reading: ',
                                style: Theme.of(context).textTheme.titleSmall,
                                children: <TextSpan>[
                                  TextSpan(text: stats.reading!.decimal(), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Completed: ',
                          style: Theme.of(context).textTheme.titleSmall,
                          children: <TextSpan>[
                            TextSpan(text: stats.completed.decimal(), style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'On-Hold: ',
                          style: Theme.of(context).textTheme.titleSmall,
                          children: <TextSpan>[
                            TextSpan(text: stats.onHold.decimal(), style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Dropped: ',
                          style: Theme.of(context).textTheme.titleSmall,
                          children: <TextSpan>[
                            TextSpan(text: stats.dropped.decimal(), style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      widget.anime
                          ? RichText(
                              text: TextSpan(
                                text: 'Plan to Watch: ',
                                style: Theme.of(context).textTheme.titleSmall,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: stats.planToWatch!.decimal(), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                text: 'Plan to Read: ',
                                style: Theme.of(context).textTheme.titleSmall,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: stats.planToRead!.decimal(), style: DefaultTextStyle.of(context).style),
                                ],
                              ),
                            ),
                      SizedBox(height: 8.0),
                      RichText(
                        text: TextSpan(
                          text: 'Total: ',
                          style: Theme.of(context).textTheme.titleSmall,
                          children: <TextSpan>[
                            TextSpan(text: stats.total.decimal(), style: DefaultTextStyle.of(context).style),
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
                  Text('Score Stats', style: Theme.of(context).textTheme.titleMedium),
                  stats.scores.isEmpty
                      ? Text('No scores have been recorded to this title.')
                      : SizedBox(
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
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    return charts.BarChart(
      _scoreData(),
      animate: false,
      vertical: false,
      defaultInteractions: false,
      barRendererDecorator: isLight
          ? charts.BarLabelDecorator<String>()
          : charts.BarLabelDecorator<String>(
              insideLabelStyleSpec: charts.TextStyleSpec(color: charts.MaterialPalette.white),
              outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.MaterialPalette.white),
            ),
      primaryMeasureAxis: isLight
          ? charts.NumericAxisSpec()
          : charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.gray.shade700),
              ),
            ),
      domainAxis: isLight
          ? charts.OrdinalAxisSpec()
          : charts.OrdinalAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
                lineStyle: charts.LineStyleSpec(color: charts.MaterialPalette.transparent),
              ),
            ),
    );
  }

  List<charts.Series<Score, String>> _scoreData() {
    return [
      charts.Series<Score, String>(
        id: 'Score Stats',
        data: scores.reversed.toList(),
        domainFn: (score, _) => score.score.toString(),
        measureFn: (score, _) => score.votes,
        labelAccessorFn: (score, _) => '${score.percentage}% (${score.votes} votes)',
        seriesColor: charts.Color(r: 63, g: 81, b: 181),
      ),
    ];
  }
}
