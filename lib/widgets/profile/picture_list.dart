import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PictureList extends StatelessWidget {
  const PictureList(this.list);

  final BuiltList<Picture> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text('Pictures', style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Picture picture = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Ink.image(
                  image: NetworkImage(picture.largeImageUrl ?? picture.imageUrl),
                  width: kImageWidthM,
                  height: kImageHeightM,
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImageScreen(list.map((i) => i.largeImageUrl ?? i.imageUrl).toList(), index),
                          settings: const RouteSettings(name: 'ImageScreen'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class ImageScreen extends StatefulWidget {
  const ImageScreen(this.imagePaths, this.currentIndex);

  final List<String> imagePaths;
  final int currentIndex;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          _buildPhotoViewGallery(),
          _buildDotIndicator(),
        ],
      ),
    );
  }

  Widget _buildPhotoViewGallery() {
    return PhotoViewGallery.builder(
      itemCount: widget.imagePaths.length,
      builder: (context, index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(widget.imagePaths[index]),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered,
        );
      },
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: _pageController,
      loadingBuilder: (context, event) => const Center(child: CircularProgressIndicator()),
      onPageChanged: (index) => setState(() => _currentIndex = index),
    );
  }

  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.imagePaths.map((image) {
        return Container(
          width: 6.0,
          height: 6.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == widget.imagePaths.indexOf(image) ? Colors.indigo : Colors.grey.shade300,
          ),
        );
      }).toList(),
    );
  }
}
