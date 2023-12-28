import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';
import 'package:provider/provider.dart';

class MangaList extends StatelessWidget {
  const MangaList(this.items);

  final BuiltList<Manga> items;

  @override
  Widget build(BuildContext context) {
    BuiltList<Manga> mangaList = BuiltList(items.where((manga) => !manga.genres.any((i) => i.name == 'Hentai')));
    if (!Provider.of<UserData>(context).kidsGenre) {
      mangaList = BuiltList(mangaList.where((manga) => !manga.demographics.any((i) => i.name == 'Kids')));
    }
    if (!Provider.of<UserData>(context).r18Genre) {
      mangaList = BuiltList(mangaList.where((manga) => !manga.genres.any((i) => i.name == 'Erotica')));
    }

    if (mangaList.isEmpty) {
      return ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 0.0),
        itemCount: mangaList.length,
        itemBuilder: (context, index) => MangaInfo(mangaList.elementAt(index)),
      ),
    );
  }
}

class MangaInfo extends StatelessWidget {
  const MangaInfo(this.manga);

  final Manga manga;

  String get _authorsText => manga.authors.isEmpty ? '-' : manga.authors.first.name;
  String get _volumesText => manga.volumes == null ? '?' : manga.volumes.toString();
  String get _publishedText => manga.published == null ? '??' : manga.published!.split(' to ').first;
  String get _scoreText => manga.score == null ? 'N/A' : manga.score.toString();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: <Widget>[
            Text(manga.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            Text('${manga.type ?? 'Unknown'} | $_authorsText | $_volumesText vols'),
            manga.genres.isNotEmpty ? GenreHorizontal(manga.genres, anime: false) : Container(),
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
                Text(_publishedText),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, size: 20.0, color: Colors.grey),
                    Text(_scoreText),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.person_outline, size: 20.0, color: Colors.grey),
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
