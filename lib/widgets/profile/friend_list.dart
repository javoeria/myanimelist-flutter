import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/screens/user_profile_screen.dart';

class FriendList extends StatefulWidget {
  FriendList(this.username);

  final String username;

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> with AutomaticKeepAliveClientMixin<FriendList> {
  Future _future;

  @override
  void initState() {
    super.initState();
    _future = JikanApi().getUserFriends(widget.username);
  }

  Widget friendsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('Friends', style: Theme.of(context).textTheme.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              friendsTitle(),
              Container(height: 175.0, child: Center(child: CircularProgressIndicator())),
            ],
          );
        }

        BuiltList<FriendResult> friends = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            friendsTitle(),
            Container(
              height: 163.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  FriendResult friend = friends.elementAt(index);
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
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FriendCard extends StatelessWidget {
  FriendCard(this.item);

  final FriendResult item;
  final double width = 108.0;
  final double height = 163.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Ink.image(
          image: NetworkImage(item.imageUrl),
          width: width,
          height: height,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(item.username)));
            },
          ),
        ),
        Stack(
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 0.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
