// ignore_for_file: unused_field, camel_case_types

import 'dart:io';
import 'package:doctor_consultation/controllers/mediaController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/doctorsDataProvider.dart';
import 'package:doctor_consultation/providers/mediaProvider.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'images/add_image.dart';
import 'images/view_photo.dart';

class Media extends StatefulWidget {
  final bool isDoctor;

  const Media({Key key, this.isDoctor}) : super(key: key);
  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  File _video;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: widget.isDoctor
          ? Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // mediaController.uploadToStorage();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UploadingImageToFirebaseStorage(),
                    ),
                  );
                },
                child: const Icon(Icons.image),
                backgroundColor: const Color.fromARGB(255, 222, 124, 85),
              ),
              body: const tabs(),
            )
          : const Scaffold(
              body: tabs(),
            ),
    );
  }
}

class tabs extends StatelessWidget {
  const tabs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: NestedScrollView(
          // physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                  backgroundColor: Colors.white,
                  expandedHeight: 150,
                  collapsedHeight: 160,
                  flexibleSpace: MyHeader()),
              SliverPersistentHeader(
                delegate: MyDelegate(
                    tabBar: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.image)),
                    Tab(icon: Icon(Icons.video_library_sharp)),
                  ],
                  indicatorColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelColor: Colors.black,
                )),
                floating: true,
                pinned: true,
              )
            ];
          },
          body: ChangeNotifierProvider.value(
            value: LocatorService.mediaProvider(),
            child: ViewStateSelector<MediaProvider>(
              getData: () => locator<MediaProvider>().images,
              child: Selector<MediaProvider, List>(
                selector: (context, d) => d.images,
                builder: (context, list, _) {
                  return TabBarView(
                      children: [1, 2]
                          .map((e) => GridView.count(
                                crossAxisCount: 4,
                                shrinkWrap: true,
                                mainAxisSpacing: 2.0,
                                crossAxisSpacing: 2.0,
                                children: list
                                    .map((
                                      e,
                                    ) =>
                                        Container(
                                            child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ViewPhoto(
                                                  image: e,
                                                  //currentPage: ,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                              child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'lib/assets/images/spinner.gif',
                                                  image: e)),
                                        )))
                                    .toList(),
                              ))
                          .toList());
                },
              ),
            ),
          ),
        ));
  }
}

class MyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 50.0, left: 20, right: 20, bottom: 0),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'A D V E R T I S M E N T',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 80,
                    width: 350,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'With growing competition, it can be difficult to maximize your exposure and reach a target audience thats willing to pay for high-end medical services.Thats where Big Buzz comes in.',
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  MyDelegate({this.tabBar});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
