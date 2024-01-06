import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;
import 'package:jikan_api/jikan_api.dart';

enum ItemType { anime, manga, people, characters }

const kGooglePlayId = 'com.javier.myanimelist';
const kDefaultImage = 'https://cdn.myanimelist.net/images/questionmark_50.gif';
const kDefaultPicture = 'https://cdn.myanimelist.net/img/sp/icon/apple-touch-icon-256.png';
const kSlackToken = 'T014XKJ2C31/B014XKLF2S3/jtDgfbsVzEUusc2i2mUk3o2b';

final jikan = Jikan(debug: kDebugMode);
const kDefaultPageSize = 25;
const kEpisodePageSize = 100;
const kReviewPageSize = 20;

const kMyAnimeListColor = Color(0xFF2E51A2);
const kWatchingColor = Color(0xFF2DB039);
const kCompletedColor = Color(0xFF26448F);
const kOnHoldColor = Color(0xFFF1C83E);
const kDroppedColor = Color(0xFFA12F31);
const kPlantoWatchColor = Color(0xFFC3C3C3);

const kImageWidthS = 50.0;
const kImageHeightS = 70.0;
const kImageWidthM = 108.0;
const kImageHeightM = 163.0;
const kImageWidthL = 160.0;
const kImageHeightL = 220.0;
const kImageWidthXL = 167.0;
const kImageHeightXL = 240.0;

const kExpandedHeight = 268.0;
const kSliverAppBarWidth = 135.0;
const kSliverAppBarHeight = 210.0;
const kSliverAppBarPadding = EdgeInsets.symmetric(horizontal: 24.0);

const kHomePadding = EdgeInsets.only(left: 16.0, top: 4.0);
const kTitlePadding = EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0);
const kTextStyleBold = TextStyle(fontWeight: FontWeight.bold);
const kTextStyleShadow = TextStyle(color: Colors.white, fontSize: 12.0, shadows: [Shadow(blurRadius: 3.0)]);

Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'watching':
    case 'reading':
      return kWatchingColor;
    case 'completed':
      return kCompletedColor;
    case 'on_hold':
    case 'on hold':
      return kOnHoldColor;
    case 'dropped':
      return kDroppedColor;
    default:
      return kPlantoWatchColor;
  }
}

String statusText(String status) {
  switch (status) {
    case 'on_hold':
      return 'On-Hold';
    case 'plan_to_watch':
      return 'Plan to Watch';
    case 'plan_to_read':
      return 'Plan to Read';
    default:
      return status.toTitleCase();
  }
}

String scoreText(String score) {
  switch (score) {
    case '10':
      return '(10) Masterpiece';
    case '9':
      return '(9) Great';
    case '8':
      return '(8) Very Good';
    case '7':
      return '(7) Good';
    case '6':
      return '(6) Fine';
    case '5':
      return '(5) Average';
    case '4':
      return '(4) Bad';
    case '3':
      return '(3) Very Bad';
    case '2':
      return '(2) Horrible';
    case '1':
      return '(1) Appalling';
    default:
      return 'Select';
  }
}

String episodesText(dynamic top) {
  if (top is Anime) {
    String episodes = top.episodes == null ? '?' : top.episodes.toString();
    return '($episodes eps)';
  } else if (top is Manga) {
    String volumes = top.volumes == null ? '?' : top.volumes.toString();
    return '($volumes vols)';
  } else {
    throw 'ItemType Error';
  }
}

Widget reviewIcon(String tag) {
  if (tag == 'Recommended') {
    return const Icon(Icons.star, size: 16.0, color: Colors.indigo);
  } else if (tag == 'Not Recommended') {
    return const Icon(Icons.star_border, size: 16.0, color: Colors.red);
  } else {
    return const Icon(Icons.star_half, size: 16.0, color: Colors.grey);
  }
}

Widget playButton() {
  return Container(
    padding: const EdgeInsets.all(4.0),
    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4.0)),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.play_circle_outline, color: Colors.white),
        Text(' Play', style: TextStyle(color: Colors.white)),
      ],
    ),
  );
}

extension TextParsing on String {
  String toTitleCase() => this[0].toUpperCase() + substring(1).toLowerCase();
  String formatDate({pattern = 'MMM d, yyyy'}) => DateFormat(pattern).format(DateTime.parse(this));
  String formatHtml() => replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>');
}

extension NumberParsing on int {
  String decimal() => NumberFormat.decimalPattern().format(this);
  String compact() => NumberFormat.compact().format(this);
}

extension ListParsing on Iterable<Anime> {
  BuiltList<Anime> toBuiltList() => BuiltList(this);
}
