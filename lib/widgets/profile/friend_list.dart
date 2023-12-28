import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';

class FriendList extends StatelessWidget {
  const FriendList(this.list);

  final BuiltList<Friend> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text('Friends', style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: FriendCard(list.elementAt(index)),
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
  const FriendCard(this.friend);

  final Friend friend;
  final double width = kImageWidthM;
  final double height = kImageHeightM;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(friend.user.imageUrl!),
      width: width,
      height: height,
      fit: BoxFit.cover,
      child: InkWell(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Image.asset('images/box_shadow.png', width: width, height: 40.0, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                friend.user.username,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: kTextStyleShadow,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(friend.user.username),
              settings: const RouteSettings(name: 'UserProfileScreen'),
            ),
          );
        },
      ),
    );
  }
}
