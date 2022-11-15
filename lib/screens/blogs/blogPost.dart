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

import 'dart:async';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:doctor_consultation/models/blogModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BlogPost extends StatefulWidget {
  const BlogPost({Key key, this.blog}) : super(key: key);

  final Blog blog;

  @override
  _BlogPostState createState() => _BlogPostState();
}

class _BlogPostState extends State<BlogPost> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.blog.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          NavigationControls(_controller.future),
          SaveBlog(blog: widget.blog)
        ],
      ),
      body: Builder(
        builder: (context) {
          return WebView(
            initialUrl: widget.blog.url ?? 'https://www.google.com',
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          );
        },
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text('No back history item')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('No forward history item')),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}

class SaveBlog extends StatefulWidget {
  const SaveBlog({Key key, @required this.blog}) : super(key: key);

  final Blog blog;

  @override
  _SaveBlogState createState() => _SaveBlogState();
}

class _SaveBlogState extends State<SaveBlog> {
  bool isSaved = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            padding: ThemeGuide.padding,
            child: const SpinKitCircle(
              color: Colors.black,
              size: 26,
            ),
          )
        : IconButton(
            icon: isSaved
                ? const Icon(
                    Icons.bookmark,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.bookmark_border,
                    color: Colors.black,
                  ),
            onPressed: onPress,
          );
  }

  Future<void> onPress() async {
    if (isSaved) {
      setState(() {
        isLoading = !isLoading;
      });
      // delete as already saved
      final result =
          await LocatorService.savedBlogsProvider().deleteBlog(widget.blog.uid);

      if (result) {
        UiController.showSnackBar(context, AppStrings.deleted);
        setState(() {
          isSaved = !isSaved;
          isLoading = !isLoading;
        });
        return;
      }

      setState(() {
        isLoading = !isLoading;
      });
    } else {
      setState(() {
        isLoading = !isLoading;
      });
      // add as was not added
      final result =
          await LocatorService.savedBlogsProvider().saveBlog(widget.blog);

      if (result) {
        UiController.showSnackBar(context, AppStrings.saved);
        setState(() {
          isSaved = !isSaved;
          isLoading = !isLoading;
        });
        return;
      }

      setState(() {
        isLoading = !isLoading;
      });
    }
  }
}
