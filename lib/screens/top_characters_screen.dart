import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;

final NumberFormat f = NumberFormat.decimalPattern();

class TopCharactersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Characters'),
      ),
      body: FutureBuilder(
        future: JikanApi().getTop(TopType.characters, page: 1),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          BuiltList<Top> topList = snapshot.data;
          return ListView.builder(
            itemCount: topList.length,
            itemBuilder: (context, index) {
              Top top = topList.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Image.network(top.imageUrl, height: 70.0, width: 50.0, fit: BoxFit.cover),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(top.title, style: Theme.of(context).textTheme.subtitle),
                          ),
                          Row(
                            children: <Widget>[
                              Text(f.format(top.favorites), style: Theme.of(context).textTheme.subhead),
                              Icon(Icons.favorite, color: Colors.pink),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
