import 'package:flutter/material.dart';

class MangaScreen extends StatelessWidget {
  MangaScreen(this.id, this.title);

  final int id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title ?? 'Manga'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Reviews'),
              Tab(text: 'Recommendations'),
              Tab(text: 'Stats'),
              Tab(text: 'Characters'),
              Tab(text: 'News'),
              Tab(text: 'Forum'),
              Tab(text: 'Pictures'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Text('1'),
            Text('2'),
            Text('3'),
            Text('4'),
            Text('5'),
            Text('6'),
            Text('7'),
            Text('8'),
          ],
        ),
      ),
    );
  }
}
