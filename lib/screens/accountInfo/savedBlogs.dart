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

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/savedBlogsProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/screens/blogs/blogScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedBlogs extends StatelessWidget {
  const SavedBlogs({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.savedBlogs),
      ),
      body: ChangeNotifierProvider.value(
        value: LocatorService.savedBlogsProvider(),
        child: ViewStateSelector<SavedBlogsProvider>(
          getData: () => locator<SavedBlogsProvider>().fetchData(),
          child: Selector<SavedBlogsProvider, List>(
            selector: (context, d) => d.blogsList,
            builder: (context, list, _) {
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () => NavigationController.navigator.push(
                      Routes.blogPost,
                      arguments: BlogPostArguments(blog: list[i]),
                    ),
                    child: BlogListItem(
                      blog: list[i],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
