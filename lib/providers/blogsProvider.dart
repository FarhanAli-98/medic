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

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/models/blogModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';

class BlogsProvider extends BaseProvider {
  List<Blog> _blogsList = [];
  List<Blog> get blogsList => _blogsList;

  final List<Blog> _blogsSmallList = [];
  List<Blog> get blogsSmallList => _blogsSmallList;

  DocumentSnapshot _lastDocument;

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _blogsList = [];
    _blogsSmallList.clear();
    _lastDocument = null;
  }

  /// Get blogs for the full screen blogs list.
  Future<void> getBlogs() async {
    try {
      final result = await FirestoreService.getBlogs();

      if (result == null || result.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // Last document ref to get more documents.
        _lastDocument = result.last;

        // Convert and add each blog to the list
        final _list = <Blog>[];
        for (final elem in result) {
          final Blog obj = Blog.fromMap(elem.data());
          _list.add(obj);
        }

        // Set the new blog list
        _blogsList = _list;

        notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  /// Get more blogs
  Future<void> getMoreBlogs() async {
    try {
      final result = await FirestoreService.getMoreBlogs(_lastDocument);

      if (result.isEmpty && _blogsList.isEmpty) {
        log('No data', name: 'BP');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // Last document ref to get more documents.
        _lastDocument = result.last ?? _lastDocument;

        // Convert and add each blog to the list
        for (final elem in result) {
          final Blog obj = Blog.fromMap(elem.data());
          _blogsList.add(obj);
        }

        notifyState(ViewState.DATA);
      }
    } catch (e) {
      if (_blogsList.isNotEmpty) {
        notifyState(ViewState.DATA);
      } else {
        log('Error $e', name: 'BP');
        notifyError(errorText: e.toString());
      }
    }
  }

  /// Get blogss for small list in the home
  Future<void> getBlogsSmallList() async {
    // This will get the blogs
    await getBlogs();

    // now add them to the small blogs list and notifylisteners
    if (_blogsList.length > 6) {
      for (var i = 0; i < 5; i++) {
        _blogsSmallList.add(_blogsList[i]);
      }
    } else {
      _blogsList.forEach(addBlogToSmallList);
    }
    notifyListeners();
  }

  //****************************************************
  //  Helper function sto support main functions
  //****************************************************

  /// Adds each blog to the small list for home screen
  void addBlogToSmallList(Blog elem) {
    _blogsSmallList.add(elem);
  }
}
