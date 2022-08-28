import 'package:flutter/material.dart';

enum ItemType { anime, manga, people, characters }

const kGooglePlayId = 'com.javier.myanimelist';
const kDefaultImage = 'https://cdn.myanimelist.net/images/questionmark_50.gif';
const kSlackToken = 'T014XKJ2C31/B014XKLF2S3/jtDgfbsVzEUusc2i2mUk3o2b';

const kDefaultPageSize = 25;
const kEpisodePageSize = 100;
const kReviewPageSize = 20;

const kWatchingColor = Color(0xFF2DB039);
const kCompletedColor = Color(0xFF26448F);
const kOnHoldColor = Color(0xFFF9D457);
const kDroppedColor = Color(0xFFA12F31);
const kPlantoWatchColor = Color(0xFFC3C3C3);

const kImageWidthS = 50.0;
const kImageHeightS = 70.0;
const kImageWidthM = 108.0;
const kImageHeightM = 163.0;
const kImageWidthL = 160.0;
const kImageHeightL = 220.0;
const kImageWidthXL = 167.0;
const kImageHeightXL = 242.0;

const kExpandedHeight = 280.0;
const kSliverAppBarWidth = 135.0;
const kSliverAppBarHeight = 210.0;
const kSliverAppBarPadding = EdgeInsets.all(24.0);

const kTextStyleBold = TextStyle(fontWeight: FontWeight.bold);
const kTextStyleShadow = TextStyle(
  color: Colors.white,
  fontSize: 12.0,
  shadows: <Shadow>[Shadow(offset: Offset(0.0, 0.0), blurRadius: 3.0)],
);
