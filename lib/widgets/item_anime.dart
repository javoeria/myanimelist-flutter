import 'package:flutter/material.dart';

class ItemAnime extends StatelessWidget {
  ItemAnime(this.id, this.title, this.image, {this.width = 160.0, this.height = 220.0});

  final int id;
  final String title;
  final String image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(id);
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Image.network(image, width: width, height: height, fit: BoxFit.cover),
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Image.asset('images/box_shadow.png', width: width, height: 40.0, fit: BoxFit.cover),
              Container(
                width: width,
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
        ],
      ),
    );
  }
}
