import 'package:flutter/material.dart';

const kAnimePageSize = 300;
const kEpisodePageSize = 100;
const kSearchPageSize = 50;
const kTopPageSize = 50;
const kReviewPageSize = 20;

const kWatchingColor = Color(0xFF43A047);    // Colors.green[600]
const kCompletedColor = Color(0xFF0D47A1);   // Colors.blue[900]
const kOnHoldColor = Color(0xFFFBC02D);      // Colors.yellow[700]
const kDroppedColor = Color(0xFFB71C1C);     // Colors.red[900]
const kPlantoWatchColor = Color(0xFFBDBDBD); // Colors.grey[400]

const kImageWidth = 50.0;
const kImageHeight = 70.0;
const kContainerWidth = 108.0;
const kContainerHeight = 163.0;
const kExpandedHeight = 280.0;

const kSliverAppBarWidth = 135.0;
const kSliverAppBarHeight = 210.0;
const kSliverAppBarPadding = EdgeInsets.all(24.0);

const kTextStyleBold = TextStyle(fontWeight: FontWeight.bold);
const kTextStyleShadow = TextStyle(
  color: Colors.white,
  fontSize: 12.0,
  shadows: <Shadow>[
    Shadow(offset: Offset(0.0, 0.0), blurRadius: 3.0),
  ],
);