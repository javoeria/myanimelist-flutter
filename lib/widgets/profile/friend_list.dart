import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';

class FriendList extends StatelessWidget {
  FriendList(this.list);

  final BuiltList<Friend> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('Friends', style: Theme.of(context).textTheme.headline6),
        ),
        Container(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Friend friend = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: FriendCard(friend),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class FriendCard extends StatelessWidget {
  FriendCard(this.item);

  final Friend item;
  final double width = kImageWidthM;
  final double height = kImageHeightM;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(item.imageUrl),
      width: width,
      height: height,
      fit: BoxFit.cover,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(item.username),
              settings: RouteSettings(name: 'UserProfileScreen'),
            ),
          );
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Image.asset('images/box_shadow.png', width: width, height: 40.0, fit: BoxFit.cover),
            Container(
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.username,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: kTextStyleShadow,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
