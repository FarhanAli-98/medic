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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:provider/provider.dart';

///
/// ## `Description`
///
/// This widget provides 3-4 blogs in list and is
/// intended to work as the small link to move to
/// the all blogs post screen.
///
class SmallBlogList extends StatelessWidget {
  const SmallBlogList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: LocatorService.blogsProvider(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 20, 00),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppStrings.blogs,
                  style: _theme.textTheme.subtitle2.copyWith(fontSize: 16),
                ),
                FlatButton(
                  child: Text(
                    AppStrings.seeAll,
                    style: _theme.textTheme.bodyText1,
                  ),
                  onPressed: () =>
                      NavigationController.navigator.push(Routes.blogsScreen),
                )
              ],
            ),
          ),
          Container(
            height: 330,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Selector<BlogsProvider, List<Blog>>(
              selector: (context, d) => d.blogsSmallList,
              shouldRebuild: (a, b) => true,
              builder: (context, list, _) {
                if (list.isEmpty) {
                  LocatorService.blogsProvider().getBlogsSmallList();
                  return const Center(
                    child: CustomLoader(),
                  );
                } else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: () => NavigationController.navigator.push(
                        Routes.blogPost,
                        arguments: BlogPostArguments(blog: list[i]),
                      ),
                      child: BlogListItem(
                        blog: list[i],
                      ),
                    ),
                  );
                }
              },
            ),
        
        
          ),
        ],
      ),
    );
  }
}

///
/// ## `Description`
///
/// Blog List Item takes in a Map{} of blog post data.
/// Displays each Map as a card with specified length
/// and width.
/// Best to use as an item of a list
///
class BlogListItem extends StatelessWidget {
  const BlogListItem({Key key, this.blog}) : super(key: key);

  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 210,
      margin: ThemeGuide.padding10,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(235, 235, 235, 1),
            spreadRadius: 0,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  blog.imageUrl ?? 'https://via.placeholder.com/100',
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    blog.title ?? ' ',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                    child: Text(
                      blog.description ?? ' ',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
