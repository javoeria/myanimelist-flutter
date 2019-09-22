import 'package:flutter/material.dart';

class ItemAnime extends StatelessWidget {
  ItemAnime(this.id, this.title, this.image);

  final int id;
  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(id);
      },
      child: Stack(
        children: <Widget>[
          Image.network(image, height: 220.0, width: 160.0, fit: BoxFit.cover),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                Image.asset('images/box_shadow.png', width: 160.0, height: 40.0, fit: BoxFit.cover),
                Container(
                  width: 160.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
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
          ),
        ],
      ),
    );
  }
}
