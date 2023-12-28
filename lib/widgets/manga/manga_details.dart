import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/widgets/anime/related_list.dart';
import 'package:myanimelist/widgets/manga/manga_dialog.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';

class MangaDetails extends StatefulWidget {
  const MangaDetails(this.id);

  final int id;

  @override
  State<MangaDetails> createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> with AutomaticKeepAliveClientMixin<MangaDetails> {
  late Manga manga;
  late BuiltList<Picture> pictures;
  Map<String, dynamic>? status;
  List<dynamic>? related;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final Trace mangaTrace = FirebasePerformance.instance.newTrace('manga_trace');
    mangaTrace.start();
    manga = await jikan.getManga(widget.id);
    pictures = await jikan.getMangaPictures(widget.id);
    status = await MalClient().getStatus(widget.id, anime: false);
    related = await MalClient().getRelated(widget.id, anime: false);
    mangaTrace.stop();
    setState(() => loading = false);
  }

  String get _scoreText => manga.score == null ? 'N/A' : manga.score.toString();
  String get _rankText => manga.rank == null ? 'N/A' : '#${manga.rank}';
  String get _volumesText => manga.volumes == null ? 'Unknown' : manga.volumes.toString();
  String get _chaptersText => manga.chapters == null ? 'Unknown' : manga.chapters.toString();
  String get _genresText => manga.genres.isEmpty ? 'None found' : manga.genres.map((i) => i.name).join(', ');
  String get _authorsText => manga.authors.isEmpty ? 'None found' : manga.authors.map((i) => i.name).join(', ');
  String get _serializationText =>
      manga.serializations.isEmpty ? 'None found' : manga.serializations.map((i) => i.name).join(', ');

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

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
                      text: _scoreText,
                      style: Theme.of(context).textTheme.headlineLarge,
                      children: <TextSpan>[
                        TextSpan(
                          text: manga.scoredBy == null ? '' : ' (${manga.scoredBy!.decimal()} users)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      text: 'Ranked ',
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [TextSpan(text: _rankText, style: kTextStyleBold)],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Popularity ',
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [TextSpan(text: '#${manga.popularity}', style: kTextStyleBold)],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Members ',
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [TextSpan(text: manga.members!.decimal(), style: kTextStyleBold)],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Favorites ',
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [TextSpan(text: manga.favorites!.decimal(), style: kTextStyleBold)],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(manga.type ?? 'Unknown'),
                  manga.serializations.isNotEmpty ? Text(manga.serializations.first.name) : Container(),
                  manga.authors.isNotEmpty ? Text(manga.authors.first.name) : Container(),
                ],
              ),
            ],
          ),
        ),
        status != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: BorderSide(width: 2.0, color: statusColor(status!['text']))),
                  child: Text(
                    status!['text'],
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: statusColor(status!['text'])),
                  ),
                  onPressed: () async {
                    final newStatus = await showDialog<dynamic>(
                      context: context,
                      builder: (context) => MangaDialog(status!),
                    );
                    if (newStatus != null && newStatus['status'] != null) {
                      setState(() {
                        status!['status'] = newStatus['status'];
                        status!['score'] = newStatus['score'];
                        status!['num_chapters_read'] = newStatus['num_chapters_read'];
                        status!['num_volumes_read'] = newStatus['num_volumes_read'];
                        status!['text'] = newStatus['status'].replaceAll('_', ' ').toUpperCase();
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
              Text('Synopsis', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 16.0),
              Text(manga.synopsis ?? 'No synopsis information has been added to this title.', softWrap: true),
            ],
          ),
        ),
        manga.genres.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: GenreHorizontal(manga.genres, anime: false),
              )
            : Container(),
        manga.background != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(height: 0.0),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Background', style: Theme.of(context).textTheme.titleMedium),
                        SizedBox(height: 8.0),
                        Text(manga.background!, softWrap: true),
                      ],
                    ),
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
              Text('Information', style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8.0),
              RichText(
                text: TextSpan(
                  text: 'Type: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: manga.type ?? 'Unknown', style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Volumes: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _volumesText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Chapters: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _chaptersText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Status: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: manga.status, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Published: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: manga.published, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Genres: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _genresText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Serialization: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _serializationText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Authors: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _authorsText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
            ],
          ),
        ),
        if (related != null && related!.isNotEmpty) RelatedList(related!, anime: false),
        PictureList(pictures),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
