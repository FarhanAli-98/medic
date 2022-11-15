// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/blogModel.dart';
import 'package:doctor_consultation/providers/blogsProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:provider/provider.dart';

///
/// ## `Description`
///
/// Screen to show the list of blogs available
///
class BlogsScreen extends StatelessWidget {
  const BlogsScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.blogs),
        elevation: 0,
      ),
      body: ChangeNotifierProvider.value(
        value: LocatorService.blogsProvider(),
        child: ViewStateSelector<BlogsProvider>(
          getData: () => LocatorService.blogsProvider().getBlogs(),
          child: ListContainer(),
        ),
      ),
    );
  }
}

class ListContainer extends StatefulWidget {
  @override
  _ListContainerState createState() => _ListContainerState();
}

class _ListContainerState extends State<ListContainer> {
  final ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getMoreData();
    }
  }

  Future<void> _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);

      // Gets more data
      await LocatorService.blogsProvider().getMoreBlogs();
      // double edge = 50.0;
      // double offsetFromBottom = _scrollController.position.maxScrollExtent -
      //     _scrollController.position.pixels;
      // if (offsetFromBottom < edge) {
      //   _scrollController.animateTo(
      //       _scrollController.offset - (edge - offsetFromBottom) + 10,
      //       duration: new Duration(milliseconds: 500),
      //       curve: Curves.easeOut);
      // }
      setState(() {
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: const CustomLoader(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<BlogsProvider, List<Blog>>(
      selector: (context, d) => d.blogsList,
      // shouldRebuild: (a, b) => true,
      builder: (context, list, _) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: list.length + 1,
          itemBuilder: (context, i) {
            if (i == list.length) {
              return _buildProgressIndicator();
            } else {
              return GestureDetector(
                onTap: () => NavigationController.navigator.push(
                  Routes.blogPost,
                  arguments: BlogPostArguments(blog: list[i]),
                ),
                child: BlogListItem(
                  blog: list[i],
                ),
              );
            }
          },
          controller: _scrollController,
        );
      },
    );
  }
}

///
/// ## `Description`
///
/// Returns the layout widget for the list of blogs.
///
class BlogListItem extends StatelessWidget {
  const BlogListItem({Key key, @required this.blog}) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      height: 120,
      decoration: ThemeGuide.boxDecorationBlack,
      padding: ThemeGuide.padding,
      margin: ThemeGuide.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: ThemeGuide.lightGrey,
              borderRadius: ThemeGuide.borderRadius,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  blog.imageUrl ?? 'https://via.placeholder.com/100',
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Text(
                    blog.title ?? ' ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    blog.description ?? ' ',
                    style: _theme.textTheme.caption,
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
