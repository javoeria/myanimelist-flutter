import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xml/xml.dart';

Future<List<XmlElement>> getXmlData(String type) async {
  final response = await http.get(Uri.parse('https://myanimelist.net/rss/$type.xml'));
  final data = XmlDocument.parse(response.body);
  return data.findAllElements('item').toList();
}

class FeedScreen extends StatelessWidget {
  const FeedScreen({this.news = true});

  final bool news;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(news ? 'Anime & Manga News' : 'Featured Articles')),
      body: FutureBuilder(
        future: getXmlData(news ? 'news' : 'featured'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<XmlElement> items = snapshot.data!;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                XmlElement item = items.elementAt(index);
                return InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Image.network(
                          item.getElement('media:thumbnail')!.innerText.trim(),
                          width: 80.0,
                          height: 124.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.getElement('title')!.innerText.trim(),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item.getElement('description')!.innerText.trim(),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item.getElement('pubDate')!.innerText.trim(),
                                style: Theme.of(context).textTheme.bodySmall,
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
          );
        },
      ),
    );
  }
}
