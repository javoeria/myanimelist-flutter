import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

class FeedScreen extends StatelessWidget {
  FeedScreen({this.news = true});

  final bool news;

  Future<List<XmlElement>> getXmlData() async {
    final type = news ? 'news' : 'featured';
    final response = await http.get('https://myanimelist.net/rss/$type.xml');
    final data = XmlDocument.parse(response.body);
    return data.findAllElements('item').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news ? 'Anime & Manga News' : 'Featured Articles'),
      ),
      body: FutureBuilder(
        future: getXmlData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          List<XmlElement> items = snapshot.data;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                XmlElement article = items.elementAt(index);
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.network(
                              article.getElement('media:thumbnail').text.trim(),
                              width: 100.0,
                              height: news ? 156.0 : 100.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8.0),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                article.getElement('title').text.trim(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                article.getElement('description').text.trim(),
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                article.getElement('pubDate').text.trim(),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    String url = article.getElement('link').text.trim();
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
