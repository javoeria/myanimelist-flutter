import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/person_screen.dart';
import 'package:myanimelist/widgets/custom_view.dart';
import 'package:myanimelist/widgets/top_grid.dart';
import 'package:provider/provider.dart';

final NumberFormat f = NumberFormat.decimalPattern();

class TopPeopleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top People'),
        actions: <Widget>[CustomView()],
      ),
      body: FutureBuilder(
        future: JikanApi().getTop(TopType.people, page: 1),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          BuiltList<Top> topList = snapshot.data;
          if (Provider.of<UserData>(context).gridView) {
            return TopGrid(topList, type: TopType.people);
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: topList.length,
              itemBuilder: (context, index) {
                Top top = topList.elementAt(index);
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PersonScreen(top.malId)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Image.network(top.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
