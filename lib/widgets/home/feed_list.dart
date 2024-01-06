import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/feed_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xml/xml.dart';

class FeedList extends StatelessWidget {
  const FeedList(this.items, {this.news = true});

  final List<XmlElement> items;
  final bool news;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kHomePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(news ? 'Anime & Manga News' : 'Featured Articles', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                key: Key(news ? 'news_icon' : 'articles_icon'),
                tooltip: 'View all',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedScreen(news: news),
                      settings: RouteSettings(name: news ? 'NewsScreen' : 'FeaturedArticlesScreen'),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            XmlElement item = items.elementAt(index);
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    Image.network(
                      item.getElement('media:thumbnail')!.innerText.trim(),
                      width: kImageWidthS,
                      height: kImageHeightS,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Text>[
                          Text(item.getElement('title')!.innerText.trim()),
                          Text(
                            item.getElement('description')!.innerText.formatHtml().trim(),
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () async {
                String url = item.getElement('link')!.innerText.trim();
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            );
          },
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
