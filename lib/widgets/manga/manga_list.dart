import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';
import 'package:provider/provider.dart';

class MangaList extends StatefulWidget {
  const MangaList(this.mangaList);

  final BuiltList<Manga> mangaList;

  @override
  _MangaListState createState() => _MangaListState();
}

class _MangaListState extends State<MangaList> with AutomaticKeepAliveClientMixin<MangaList> {
  late BuiltList<Manga> _mangaList;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _mangaList = BuiltList(widget.mangaList.where((manga) => !manga.genres.map((i) => i.name).contains('Hentai')));
    if (!Provider.of<UserData>(context).kidsGenre) {
      _mangaList = BuiltList(_mangaList.where((manga) => !manga.demographics.map((i) => i.name).contains('Kids')));
    }
    if (!Provider.of<UserData>(context).r18Genre) {
      _mangaList = BuiltList(_mangaList.where((manga) => !manga.genres.map((i) => i.name).contains('Erotica')));
    }

    if (_mangaList.isEmpty) {
      return ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 0.0),
        itemCount: _mangaList.length,
        itemBuilder: (context, index) => MangaInfo(_mangaList.elementAt(index)),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MangaInfo extends StatelessWidget {
  const MangaInfo(this.manga);

  final Manga manga;

  String get _authorsText {
    return manga.authors.isEmpty ? '-' : manga.authors.first.name;
  }

  String get _publishingText {
    return manga.published == null ? '??' : manga.published!.split(' to ').first;
  }

  @override
  Widget build(BuildContext context) {
    String volumes = manga.volumes == null ? '?' : manga.volumes.toString();
    String score = manga.score == null ? 'N/A' : manga.score.toString();
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Text(manga.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 4.0),
            Text('${manga.type ?? 'Unknown'} | $_authorsText | $volumes vols'),
            SizedBox(height: 4.0),
            GenreHorizontal(manga.genres, anime: false),
            SizedBox(height: 4.0),
            SizedBox(
              height: kImageHeightXL,
              child: Row(
                children: <Widget>[
                  Image.network(manga.imageUrl, width: kImageWidthXL, height: kImageHeightXL, fit: BoxFit.cover),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child: Text(
                          manga.synopsis ?? '(No synopsis yet.)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_publishingText),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, color: Colors.grey, size: 20.0),
                    Text(score),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.person_outline, color: Colors.grey, size: 20.0),
                    Text(manga.members!.compact()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaScreen(manga.malId, manga.title),
            settings: const RouteSettings(name: 'MangaScreen'),
          ),
        );
      },
    );
  }
}
