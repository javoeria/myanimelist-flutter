import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/widgets/anime/anime_dialog.dart';
import 'package:myanimelist/widgets/anime/related_list.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';

class AnimeDetails extends StatefulWidget {
  const AnimeDetails(this.id);

  final int id;

  @override
  State<AnimeDetails> createState() => _AnimeDetailsState();
}

class _AnimeDetailsState extends State<AnimeDetails> with AutomaticKeepAliveClientMixin<AnimeDetails> {
  late Anime anime;
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
    final Trace animeTrace = FirebasePerformance.instance.newTrace('anime_trace');
    animeTrace.start();
    anime = await jikan.getAnime(widget.id);
    pictures = await jikan.getAnimePictures(widget.id);
    status = await MalClient().getStatus(widget.id);
    related = await MalClient().getRelated(widget.id);
    animeTrace.stop();
    setState(() => loading = false);
  }

  String get _scoreText => anime.score == null ? 'N/A' : anime.score.toString();
  String get _rankText => anime.rank == null ? 'N/A' : '#${anime.rank}';
  String get _episodesText => anime.episodes == null ? 'Unknown' : anime.episodes.toString();
  String get _producersText => anime.producers.isEmpty ? 'None found' : anime.producers.map((i) => i.name).join(', ');
  String get _licensorsText => anime.licensors.isEmpty ? 'None found' : anime.licensors.map((i) => i.name).join(', ');
  String get _studiosText => anime.studios.isEmpty ? 'None found' : anime.studios.map((i) => i.name).join(', ');
  String get _genresText => anime.genres.isEmpty ? 'None found' : anime.genres.map((i) => i.name).join(', ');

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    String? premiered =
        anime.season == null || anime.year == null ? null : '${anime.season!.toTitleCase()} ${anime.year}';
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(anime.imageUrl, width: kImageWidthXL, height: kImageHeightXL, fit: BoxFit.cover),
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
                          text: anime.scoredBy == null ? '' : ' (${anime.scoredBy!.decimal()} users)',
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
                      children: [TextSpan(text: '#${anime.popularity}', style: kTextStyleBold)],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Members ',
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [TextSpan(text: anime.members!.decimal(), style: kTextStyleBold)],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Favorites ',
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [TextSpan(text: anime.favorites!.decimal(), style: kTextStyleBold)],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(anime.type ?? 'Unknown'),
                  premiered != null ? Text(premiered) : Container(),
                  anime.studios.isNotEmpty ? Text(anime.studios.first.name) : Container(),
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
                      builder: (context) => AnimeDialog(status!),
                    );
                    if (newStatus != null && newStatus['status'] != null) {
                      setState(() {
                        status!['status'] = newStatus['status'];
                        status!['score'] = newStatus['score'];
                        status!['num_episodes_watched'] = newStatus['num_episodes_watched'];
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
              Text(anime.synopsis ?? 'No synopsis information has been added to this title.', softWrap: true),
            ],
          ),
        ),
        anime.genres.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                child: GenreHorizontal(anime.genres),
              )
            : Container(),
        anime.background != null
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
                        Text(anime.background!, softWrap: true),
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
                  children: [TextSpan(text: anime.type ?? 'Unknown', style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Episodes: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _episodesText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Status: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: anime.status, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Aired: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: anime.aired, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              premiered != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Premiered: ',
                          style: Theme.of(context).textTheme.titleSmall,
                          children: [TextSpan(text: premiered, style: DefaultTextStyle.of(context).style)],
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
                          style: Theme.of(context).textTheme.titleSmall,
                          children: [TextSpan(text: anime.broadcast, style: DefaultTextStyle.of(context).style)],
                        ),
                      ),
                    )
                  : Container(),
              RichText(
                text: TextSpan(
                  text: 'Producers: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _producersText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Licensors: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _licensorsText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Studios: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: _studiosText, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Source: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: anime.source, style: DefaultTextStyle.of(context).style)],
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
                  text: 'Duration: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: anime.duration, style: DefaultTextStyle.of(context).style)],
                ),
              ),
              SizedBox(height: 4.0),
              RichText(
                text: TextSpan(
                  text: 'Rating: ',
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [TextSpan(text: anime.rating ?? 'None', style: DefaultTextStyle.of(context).style)],
                ),
              ),
            ],
          ),
        ),
        if (related != null && related!.isNotEmpty) RelatedList(related!),
        PictureList(pictures),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
