import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/widgets/anime/related_list.dart';
import 'package:myanimelist/widgets/manga/manga_dialog.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';
import 'package:firebase_performance/firebase_performance.dart';

class MangaDetails extends StatefulWidget {
  MangaDetails(this.id);

  final int id;

  @override
  _MangaDetailsState createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> with AutomaticKeepAliveClientMixin<MangaDetails> {
  final Jikan jikan = Jikan();
  final NumberFormat f = NumberFormat.decimalPattern();

  Manga manga;
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
    final Trace mangaTrace = FirebasePerformance.instance.newTrace('manga_trace');
    mangaTrace.start();
    manga = await jikan.getMangaInfo(widget.id);
    pictures = await jikan.getMangaPictures(widget.id);
    status = await MalClient().getStatus(widget.id, anime: false);
    related = await MalClient().getRelated(widget.id, anime: false);
    mangaTrace.stop();
    setState(() => loading = false);
  }

  String get _genresText {
    return manga.genres.isEmpty ? 'None found' : manga.genres.map((i) => i.name).join(', ');
  }

  String get _authorsText {
    return manga.authors.isEmpty ? 'None found' : manga.authors.map((i) => i.name).join(', ');
  }

  String get _serializationText {
    return manga.serializations.isEmpty ? 'None found' : manga.serializations.map((i) => i.name).join(', ');
  }

  Color get _statusColor {
    switch (status['text']) {
      case 'READING':
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
      case 'PLAN TO READ':
      case 'ADD TO MY LIST':
        return kPlantoWatchColor;
        break;
      default:
        throw 'MangaStatus Error';
    }
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
              Image.network(manga.imageUrl, width: kImageWidthXL, height: kImageHeightXL, fit: BoxFit.cover),
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
                          text: manga.scoredBy == null ? '' : ' (${f.format(manga.scoredBy)} users)',
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
                        TextSpan(text: '#${manga.popularity}', style: kTextStyleBold),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Members: ',
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        TextSpan(text: f.format(manga.members), style: kTextStyleBold),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Favorites: ',
                      style: Theme.of(context).textTheme.subtitle1,
                      children: <TextSpan>[
                        TextSpan(text: f.format(manga.favorites), style: kTextStyleBold),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(manga.type),
                  manga.serializations.isNotEmpty ? Text(manga.serializations.first.name) : Container(),
                  manga.authors.isNotEmpty ? Text(manga.authors.first.name) : Container(),
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
                      builder: (context) => MangaDialog(status),
                    );
                    if (newStatus != null && newStatus['status'] != null) {
                      setState(() {
                        status['status'] = newStatus['status'];
                        status['score'] = newStatus['score'];
                        status['num_chapters_read'] = newStatus['num_chapters_read'];
                        status['num_volumes_read'] = newStatus['num_volumes_read'];
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
              Text(manga.synopsis ?? '(No synopsis yet.)', softWrap: true),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: GenreHorizontal(manga.genres, anime: false),
        ),
        manga.background != null
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
              Text('Information', style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  text: 'Type: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: manga.type, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Volumes: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: volumes, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Chapters: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: chapters, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Status: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: manga.status, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Published: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: manga.published.string, style: DefaultTextStyle.of(context).style),
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
                  text: 'Authors: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: _authorsText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Serialization: ',
                  style: Theme.of(context).textTheme.bodyText1,
                  children: <TextSpan>[
                    TextSpan(text: _serializationText, style: DefaultTextStyle.of(context).style),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (related != null && related.isNotEmpty) RelatedList(related, anime: false),
        PictureList(pictures),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
