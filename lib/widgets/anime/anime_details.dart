import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';
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
    animeTrace.stop();
    setState(() => loading = false);
  }

  String get _producersText {
    List<String> names = [];
    for (GenericInfo prod in anime.producers) {
      names.add(prod.name);
    }
    return names.join(', ');
  }

  String get _licensorsText {
    List<String> names = [];
    for (GenericInfo lic in anime.licensors) {
      names.add(lic.name);
    }
    return names.join(', ');
  }

  String get _studiosText {
    List<String> names = [];
    for (GenericInfo stud in anime.studios) {
      names.add(stud.name);
    }
    return names.join(', ');
  }

  String get _genresText {
    List<String> names = [];
    for (GenericInfo gen in anime.genres) {
      names.add(gen.name);
    }
    return names.join(', ');
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
                      style: Theme.of(context).textTheme.headline.copyWith(fontSize: 34),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' (${f.format(anime.scoredBy)} users)', style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      text: 'Ranked: ',
                      style: Theme.of(context).textTheme.subhead,
                      children: <TextSpan>[
                        TextSpan(text: rank, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Popularity: ',
                      style: Theme.of(context).textTheme.subhead,
                      children: <TextSpan>[
                        TextSpan(text: '#${anime.popularity}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Members: ',
                      style: Theme.of(context).textTheme.subhead,
                      children: <TextSpan>[
                        TextSpan(text: f.format(anime.members), style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Favorites: ',
                      style: Theme.of(context).textTheme.subhead,
                      children: <TextSpan>[
                        TextSpan(text: f.format(anime.favorites), style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(anime.type),
                  anime.premiered != null ? Text(anime.premiered) : Container(),
                  anime.studios.length > 0 ? Text(anime.studios.first.name) : Container(),
                ],
              ),
            ],
          ),
        ),
        GenreHorizontal(anime.genres),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Synopsis', style: Theme.of(context).textTheme.title),
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
                    child: Text('Background', style: Theme.of(context).textTheme.title),
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
              Text('Information', style: Theme.of(context).textTheme.title),
              SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  text: 'Type: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: anime.type, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Episodes: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: episodes, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Status: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: anime.status, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Aired: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: anime.aired.string, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              anime.premiered != null
                  ? RichText(
                      text: TextSpan(
                        text: 'Premiered: ',
                        style: Theme.of(context).textTheme.body2,
                        children: <TextSpan>[
                          TextSpan(text: anime.premiered, style: DefaultTextStyle.of(context).style),
                        ],
                      ),
                    )
                  : Container(),
              anime.broadcast != null
                  ? RichText(
                      text: TextSpan(
                        text: 'Broadcast: ',
                        style: Theme.of(context).textTheme.body2,
                        children: <TextSpan>[
                          TextSpan(text: anime.broadcast, style: DefaultTextStyle.of(context).style),
                        ],
                      ),
                    )
                  : Container(),
              RichText(
                text: TextSpan(
                  text: 'Producers: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: _producersText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Licensors: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: _licensorsText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Studios: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: _studiosText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Source: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: anime.source, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Genres: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: _genresText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Duration: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: anime.duration, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Rating: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: anime.rating, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
            ],
          ),
        ),
        anime.openingThemes.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(height: 0.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Opening Theme', style: Theme.of(context).textTheme.title),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: anime.openingThemes.map((op) {
                        return Text(op);
                      }).toList(),
                    ),
                  ),
                ],
              )
            : Container(),
        anime.endingThemes.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(height: 0.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Ending Theme', style: Theme.of(context).textTheme.title),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: anime.endingThemes.map((ed) {
                        return Text(ed);
                      }).toList(),
                    ),
                  ),
                ],
              )
            : Container(),
        PictureList(pictures),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
