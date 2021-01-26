import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/widgets/anime/anime_dialog.dart';
import 'package:myanimelist/widgets/anime/related_list.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:firebase_performance/firebase_performance.dart';

class AnimeDetails extends StatefulWidget {
  AnimeDetails(this.id);

  final int id;

  @override
  _AnimeDetailsState createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends State<AnimeDetails> with AutomaticKeepAliveClientMixin<AnimeDetails> {
  final Jikan jikan = Jikan();
  final NumberFormat f = NumberFormat.decimalPattern();

  Anime anime;
  BuiltList<Picture> pictures;
  Map<String, dynamic> status;
  List<dynamic> related;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final Trace animeTrace = FirebasePerformance.instance.newTrace('anime_trace');
    animeTrace.start();
    anime = await jikan.getAnimeInfo(widget.id);
    pictures = await jikan.getAnimePictures(widget.id);
    status = await MalClient().getStatus(widget.id);
    related = await MalClient().getRelated(widget.id);
    animeTrace.stop();
    setState(() => loading = false);
  }

  String get _producersText {
    return anime.producers.isEmpty ? 'None found' : anime.producers.map((i) => i.name).join(', ');
  }

  String get _licensorsText {
    return anime.licensors.isEmpty ? 'None found' : anime.licensors.map((i) => i.name).join(', ');
  }

  String get _studiosText {
    return anime.studios.isEmpty ? 'None found' : anime.studios.map((i) => i.name).join(', ');
  }

  String get _genresText {
    return anime.genres.isEmpty ? 'None found' : anime.genres.map((i) => i.name).join(', ');
  }

  Color get _statusColor {
    switch (status['text']) {
      case 'WATCHING':
        return kWatchingColor;
        break;
      case 'COMPLETED':
        return kCompletedColor;
        break;
      case 'ON HOLD':
        return kOnHoldColor;
        break;
      case 'DROPPED':
        return kDroppedColor;
        break;
      case 'PLAN TO WATCH':
      case 'ADD TO MY LIST':
        return kPlantoWatchColor;
        break;
      default:
        throw 'AnimeStatus Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    String score = anime.score == null ? 'N/A' : anime.score.toString();
    String rank = anime.rank == null ? 'N/A' : '#${anime.rank}';
    String episodes = anime.episodes == null ? 'Unknown' : anime.episodes.toString();
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(anime.imageUrl, width: 167.0, height: 242.0, fit: BoxFit.cover),
              SizedBox(width: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: score,
                      style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 34),
                      children: <TextSpan>[
                        TextSpan(
                          text: anime.scoredBy == null ? '' : ' (${f.format(anime.scoredBy)} users)',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      text: 'Ranked: ',
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        TextSpan(text: rank, style: kTextStyleBold),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Popularity: ',
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        TextSpan(text: '#${anime.popularity}', style: kTextStyleBold),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Members: ',
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        TextSpan(text: f.format(anime.members), style: kTextStyleBold),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Favorites: ',
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        TextSpan(text: f.format(anime.favorites), style: kTextStyleBold),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(anime.type),
                  anime.premiered != null ? Text(anime.premiered) : Container(),
                  anime.studios.isNotEmpty ? Text(anime.studios.first.name) : Container(),
                ],
              ),
            ],
          ),
        ),
        status != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: OutlinedButton(
                  child: Text(
                    status['text'],
                    style: Theme.of(context).textTheme.button.copyWith(color: _statusColor),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 2, color: _statusColor),
                  ),
                  onPressed: () async {
                    final newStatus = await showDialog<dynamic>(
                      context: context,
                      builder: (context) => AnimeDialog(status),
                    );
                    if (newStatus != null && newStatus['status'] != null) {
                      setState(() {
                        status['status'] = newStatus['status'];
                        status['score'] = newStatus['score'];
                        status['num_episodes_watched'] = newStatus['num_episodes_watched'];
                        status['text'] = newStatus['status'].replaceAll('_', ' ').toUpperCase();
                      });
                      Fluttertoast.showToast(msg: 'Update Successful');
                    }
                  },
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Synopsis', style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 16.0),
              Text(anime.synopsis ?? '(No synopsis yet.)', softWrap: true),
            ],
          ),
        ),
        anime.background != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(height: 0.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Background', style: Theme.of(context).textTheme.headline6),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Text(anime.background, softWrap: true),
                  ),
                ],
              )
            : Container(),
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Information', style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  text: 'Type: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: anime.type, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Episodes: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: episodes, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Status: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: anime.status, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Aired: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: anime.aired.string, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              anime.premiered != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Premiered: ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: <TextSpan>[
                            TextSpan(text: anime.premiered, style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              anime.broadcast != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Broadcast: ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: <TextSpan>[
                            TextSpan(text: anime.broadcast, style: DefaultTextStyle.of(context).style),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              RichText(
                text: TextSpan(
                  text: 'Producers: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: _producersText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Licensors: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: _licensorsText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Studios: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: _studiosText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Source: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: anime.source, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Genres: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: _genresText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Duration: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: anime.duration, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Rating: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: anime.rating, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
            ],
          ),
        ),
        anime.openingThemes.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(height: 0.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Opening Theme', style: Theme.of(context).textTheme.headline6),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: anime.openingThemes.map((op) => Text(op)).toList(),
                    ),
                  ),
                ],
              )
            : Container(),
        anime.endingThemes.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(height: 0.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Ending Theme', style: Theme.of(context).textTheme.headline6),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: anime.endingThemes.map((ed) => Text(ed)).toList(),
                    ),
                  ),
                ],
              )
            : Container(),
        if (related != null && related.isNotEmpty) RelatedList(related),
        PictureList(pictures),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
