import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/profile/picture_list.dart';

class MangaDetails extends StatefulWidget {
  MangaDetails(this.id);

  final int id;

  @override
  _MangaDetailsState createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> with AutomaticKeepAliveClientMixin<MangaDetails> {
  final JikanApi jikanApi = JikanApi();
  final NumberFormat f = NumberFormat.decimalPattern();

  MangaInfo manga;
  BuiltList<Picture> pictures;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    manga = await jikanApi.getMangaInfo(widget.id);
    pictures = await jikanApi.getMangaPictures(widget.id);
    setState(() => loading = false);
  }

  String get _genresText {
    List<String> names = [];
    for (GenericInfo gen in manga.genres) {
      names.add(gen.name);
    }
    return names.join(', ');
  }

  String get _authorsText {
    List<String> names = [];
    for (GenericInfo aut in manga.authors) {
      names.add(aut.name);
    }
    return names.join(', ');
  }

  String get _serializationText {
    List<String> names = [];
    for (GenericInfo ser in manga.serializations) {
      names.add(ser.name);
    }
    return names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    String score = manga.score == null ? 'N/A' : manga.score.toString();
    String rank = manga.rank == null ? 'N/A' : '#${manga.rank}';
    String volumes = manga.volumes == null ? 'Unknown' : manga.volumes.toString();
    String chapters = manga.chapters == null ? 'Unknown' : manga.chapters.toString();
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(manga.imageUrl, width: 167.0, height: 242.0, fit: BoxFit.cover),
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
                            text: ' (${f.format(manga.scoredBy)} users)', style: Theme.of(context).textTheme.caption),
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
                        TextSpan(text: '#${manga.popularity}', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Members: ',
                      style: Theme.of(context).textTheme.subhead,
                      children: <TextSpan>[
                        TextSpan(text: f.format(manga.members), style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Favorites: ',
                      style: Theme.of(context).textTheme.subhead,
                      children: <TextSpan>[
                        TextSpan(text: f.format(manga.favorites), style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(manga.type),
                  manga.serializations.length > 0 ? Text(_serializationText) : Container(),
                  Text(_authorsText),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: Wrap(
              spacing: 8.0,
              children: manga.genres.map((genre) {
                return Chip(label: Text(genre.name));
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Synopsis', style: Theme.of(context).textTheme.title),
              SizedBox(height: 16.0),
              Text(manga.synopsis ?? '(No synopsis yet.)', softWrap: true),
            ],
          ),
        ),
        manga.background != null
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
                    child: Text(manga.background, softWrap: true),
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
                    TextSpan(text: manga.type, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Volumes: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: volumes, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Chapters: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: chapters, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Status: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: manga.status, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Published: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: manga.published.string, style: DefaultTextStyle.of(context).style),
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
                  text: 'Authors: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: _authorsText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Serialization: ',
                  style: Theme.of(context).textTheme.body2,
                  children: <TextSpan>[
                    TextSpan(text: _serializationText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
            ],
          ),
        ),
        PictureList(pictures),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
