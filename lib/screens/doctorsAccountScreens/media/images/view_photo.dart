import 'package:doctor_consultation/screens/doctorsAccountScreens/media/images/base_helper.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewPhoto extends StatefulWidget {
  String image;
  int currentPage = 0;
  ViewPhoto({Key key, this.image, this.currentPage = 0})
      : super(key: key);

  @override
  State<ViewPhoto> createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  final PhotoViewController controller = PhotoViewController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider:  BaseHelper.loadNetworkImageObject(widget.image),
    );

    // PhotoViewGallery.builder(
    //   builder: (BuildContext context, int index) {
    //     return PhotoViewGalleryPageOptions(
    //       imageProvider:
    //           BaseHelper.loadNetworkImageObject(widget.image[index]),
    //       initialScale: PhotoViewComputedScale.contained * 0.8,
    //       heroAttributes:
    //           PhotoViewHeroAttributes(tag: widget.image[index]),
    //       minScale: PhotoViewComputedScale.contained * 0.8,
    //     );
    //   },
    //   itemCount: widget.galleryItems.length,
    //   loadingBuilder: (context, event) => Center(
    //     child: Container(
    //       width: 20.0,
    //       height: 20.0,
    //       child: const CircularProgressIndicator(
    //         color: Colors.black,
    //       ),
    //     ),
    //   ),
    //   backgroundDecoration:
    //       BoxDecoration(color: Colors.black38.withOpacity(0.5)),
    //   // pageController: widget.pageController,
    //   onPageChanged: (val) {
    //     setState(() {
    //       // widget.currentPage = val;
    //     });
    //   },
    // );
  
  
  
  }
}
