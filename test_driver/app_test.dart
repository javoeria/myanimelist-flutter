import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// flutter drive --target=test_driver/app.dart
void main() {
  group('AnimeDB App', () {
    final menuIconFinder = find.byTooltip('Open navigation menu');
    final userTextFinder = find.text('User');
    final animeTextFinder = find.text('Anime');
    final mangaTextFinder = find.text('Manga');
    final industryTextFinder = find.text('Industry');
    final watchTextFinder = find.text('Watch');

    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      Directory('screenshots').create();
    });

    tearDownAll(() async {
      driver.close();
    });

    setUp(() {
      sleep(const Duration(seconds: 10));
    });

    Future<void> takeScreenshot(String name) async {
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      final File file = File('screenshots/${timestamp}_$name.png');
      final List<int> pixels = await driver.screenshot();
      await file.writeAsBytes(pixels);
      // print(file.path);
    }

    test('home screen', () async {
      await takeScreenshot('home');
      // await driver.tap(find.byValueKey('season_icon'));
      // await driver.tap(find.byValueKey('trailers_icon'));
      // await driver.tap(find.byValueKey('news_icon'));

      await driver.tap(find.text('Trending'));
      await takeScreenshot('trending');
      // await driver.tap(find.byValueKey('airing_icon'));
      // await driver.tap(find.byValueKey('upcoming_icon'));
      // await driver.tap(find.byValueKey('popular_icon'));
      sleep(const Duration(seconds: 3));

      await driver.tap(find.text('Feed'));
      await takeScreenshot('feed');
      // await driver.tap(find.byValueKey('articles_icon'));
      // await driver.tap(find.byValueKey('reviews_icon'));
      // await driver.tap(find.byValueKey('recommendations_icon'));
      sleep(const Duration(seconds: 3));

      await driver.tap(find.text('Home'));
      await driver.tap(find.byTooltip('Search anime'));
      await driver.tap(find.byTooltip('Back'));
      await driver.tap(find.byValueKey('anime_0'));
      await takeScreenshot('anime');
      // await driver.tap(find.text('Details'));
      // await driver.tap(find.text('Characters & Staff'));
      // await driver.tap(find.text('Episodes'));
      // await driver.tap(find.text('Videos'));
      // await driver.tap(find.text('Stats'));
      // await driver.tap(find.text('Reviews'));
      // await driver.tap(find.text('Recommendations'));
      // await driver.tap(find.text('News'));
      // await driver.tap(find.text('Forum'));
      await driver.tap(find.pageBack());
    });

    test('settings screen', () async {
      await driver.tap(menuIconFinder);
      await driver.tap(find.byTooltip('Settings'));
      await driver.tap(find.text('Login'));
    });

    test('user screen', () async {
      await driver.tap(menuIconFinder);
      await driver.tap(userTextFinder);
      await driver.tap(find.text('Profile'));
      await takeScreenshot('profile');
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(userTextFinder);
      await driver.tap(find.text('Anime List'));
      await takeScreenshot('anime_list');
      // await driver.tap(find.text('All Anime'));
      // await driver.tap(find.text('Currently Watching'));
      // await driver.tap(find.text('Completed'));
      // await driver.tap(find.text('On Hold'));
      // await driver.tap(find.text('Dropped'));
      // await driver.tap(find.text('Plan to Watch'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(userTextFinder);
      await driver.tap(find.text('Manga List'));
      await takeScreenshot('manga_list');
      // await driver.tap(find.text('All Manga'));
      // await driver.tap(find.text('Currently Reading'));
      // await driver.tap(find.text('Completed'));
      // await driver.tap(find.text('On Hold'));
      // await driver.tap(find.text('Dropped'));
      // await driver.tap(find.text('Plan to Read'));
      await driver.tap(find.pageBack());
    });

    test('anime screen', () async {
      await driver.tap(menuIconFinder);
      await driver.tap(animeTextFinder);
      await driver.tap(find.text('Anime Search'));
      await driver.waitUntilNoTransientCallbacks();
      await driver.enterText('shingeki');
      await driver.tap(find.byValueKey('suggestion_0'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(animeTextFinder);
      await driver.tap(find.text('Top Anime'));
      await takeScreenshot('top_anime');
      // await driver.tap(find.text('All Anime'));
      // await driver.tap(find.text('Top Airing'));
      // await driver.tap(find.text('Top Upcoming'));
      // await driver.tap(find.text('Top TV Series'));
      // await driver.tap(find.text('Top Movies'));
      // await driver.tap(find.text('Top OVAs'));
      // await driver.tap(find.text('Top ONAs'));
      // await driver.tap(find.text('Top Specials'));
      // await driver.tap(find.text('Most Popular'));
      // await driver.tap(find.text('Most Favorited'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(animeTextFinder);
      await driver.tap(find.text('Seasonal Anime'));
      await takeScreenshot('seasonal_anime');
      // await driver.tap(find.text('TV'));
      // await driver.tap(find.text('ONA'));
      // await driver.tap(find.text('OVA'));
      // await driver.tap(find.text('Movie'));
      // await driver.tap(find.text('Special'));
      await driver.tap(find.pageBack());

      // await driver.tap(menuIconFinder);
      // await driver.tap(animeTextFinder);
      // await driver.tap(find.text('Genres'));
      // await driver.tap(find.text('Action'));
      // await driver.tap(find.pageBack());
      // await driver.tap(find.pageBack());

      // await driver.tap(menuIconFinder);
      // await driver.tap(animeTextFinder);
      // await driver.tap(find.text('Studios'));
      // await driver.tap(find.text('Toei Animation'));
      // await driver.tap(find.pageBack());
      // await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(animeTextFinder);
      await driver.tap(find.text('Reviews'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(animeTextFinder);
      await driver.scrollUntilVisible(animeTextFinder, find.text('Recommendations'), dyScroll: -300.0);
      await driver.tap(find.text('Recommendations'));
      await driver.tap(find.pageBack());
    });

    test('manga screen', () async {
      await driver.tap(menuIconFinder);
      await driver.tap(mangaTextFinder);
      await driver.tap(find.text('Manga Search'));
      await driver.waitUntilNoTransientCallbacks();
      await driver.enterText('punpun');
      await driver.tap(find.byValueKey('suggestion_0'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(mangaTextFinder);
      await driver.tap(find.text('Top Manga'));
      await takeScreenshot('top_manga');
      // await driver.tap(find.text('All Manga'));
      // await driver.tap(find.text('Top Manga'));
      // await driver.tap(find.text('Top One-shots'));
      // await driver.tap(find.text('Top Doujinshi'));
      // await driver.tap(find.text('Top Light Novels'));
      // await driver.tap(find.text('Top Novels'));
      // await driver.tap(find.text('Top Manhwa'));
      // await driver.tap(find.text('Top Manhua'));
      // await driver.tap(find.text('Most Popular'));
      // await driver.tap(find.text('Most Favorited'));
      await driver.tap(find.pageBack());

      // await driver.tap(menuIconFinder);
      // await driver.tap(mangaTextFinder);
      // await driver.tap(find.text('Genres'));
      // await driver.tap(find.text('Action'));
      // await driver.tap(find.pageBack());
      // await driver.tap(find.pageBack());

      // await driver.tap(menuIconFinder);
      // await driver.tap(mangaTextFinder);
      // await driver.tap(find.text('Magazines'));
      // await driver.tap(find.text('Shounen Jump (Weekly)'));
      // await driver.tap(find.pageBack());
      // await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(mangaTextFinder);
      await driver.tap(find.text('Reviews'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(mangaTextFinder);
      await driver.scrollUntilVisible(mangaTextFinder, find.text('Recommendations'), dyScroll: -300.0);
      await driver.tap(find.text('Recommendations'));
      await driver.tap(find.pageBack());
    });

    test('industry screen', () async {
      await driver.tap(menuIconFinder);
      await driver.tap(industryTextFinder);
      await driver.tap(find.text('News'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(industryTextFinder);
      await driver.tap(find.text('Featured Articles'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(industryTextFinder);
      await driver.tap(find.text('People'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(industryTextFinder);
      await driver.scrollUntilVisible(industryTextFinder, find.text('Characters'), dyScroll: -300.0);
      await driver.tap(find.text('Characters'));
      await driver.tap(find.pageBack());
    });

    test('watch screen', () async {
      await driver.tap(menuIconFinder);
      await driver.tap(watchTextFinder);
      await driver.tap(find.text('Episode Videos'));
      // await driver.tap(find.text('Just Added'));
      // await driver.tap(find.text('Most Popular'));
      await driver.tap(find.pageBack());

      await driver.tap(menuIconFinder);
      await driver.tap(watchTextFinder);
      await driver.tap(find.text('Anime Trailers'));
      // await driver.tap(find.text('Just Added'));
      // await driver.tap(find.text('Most Popular'));
      await driver.tap(find.pageBack());
    });
  });
}
