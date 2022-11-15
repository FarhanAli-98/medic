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
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/blogModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SavedBlogsProvider extends BaseProvider {
  // final int _totalBlogs = 0;
  // int get totalBlogs => _totalBlogs;

  List _blogsList = [];
  List get blogsList => _blogsList;
  set setblogsList(List listData) {
    _blogsList = listData;
    notifyState(ViewState.DATA);
  }

  DocumentSnapshot _lastDocument;

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _blogsList = [];
    _lastDocument = null;
  }

  /// Fetch the data for the user
  Future<void> fetchData() async {
    final userId = LocatorService.userProvider().user.uid;

    if (userId == null) {
      return;
    }

    try {
      log('Fetch data', name: 'SBP');
      final result = await FirestoreService.getUsersSavedBlogs(userId);

      if (result.isEmpty && _blogsList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastDocument = result.last;

        final list = <Blog>[];
        for (final elem in result) {
          final Blog obj = Blog.fromMap(elem.data());
          list.add(obj);
        }
        _blogsList = list;
        notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  /// Get more saved blogs for the user
  Future<void> getMoreSavedBlogs() async {
    final userId = LocatorService.userProvider().user.uid;

    try {
      log('Getting more saved blogs', name: 'SBP');
      final result =
          await FirestoreService.getMoreUsersSavedBlogs(_lastDocument, userId);

      if (result.isEmpty && _blogsList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastDocument = result.last ?? _lastDocument;

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
        log('Error $e');
        notifyError(errorText: e.toString());
      }
    }
  }

  /// Save a blog entry in the users saved blogs list
  Future<bool> saveBlog(Blog blog) async {
    final String userId = LocatorService.userProvider().user?.uid;

    if (userId == null) {
      return Future.value(false);
    }

    try {
      final result = await FirestoreService.saveBlog(blog, userId);
      return result;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  /// Save a blog entry in the users saved blogs list
  Future<bool> deleteBlog(String blogId) async {
    final String userId = LocatorService.userProvider().user?.uid;

    if (userId == null) {
      return Future.value(false);
    }

    try {
      final result = await FirestoreService.deleteBlog(blogId, userId);
      return result;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }
}
