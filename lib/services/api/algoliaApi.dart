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

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/models/doctorModel.dart';

///
/// ## `Description`
///
/// Class to search for doctors and hospitals with full text
/// search option available
///
class AlgoliaApi {
  static Algolia algolia = const Algolia.init(
    applicationId: Config.ALGOLIA_APP_ID,
    apiKey: Config.ALGOLIA_SEARCH_API_KEY,
  );

  Future<List<AlgoliaObjectSnapshot>> search(
      String searchTerm, String indexName,
      {int page = 0}) async {
    try {
      final AlgoliaQuery query =
          algolia.instance.index(indexName).search(searchTerm);
      final AlgoliaQuerySnapshot snapshot =
          await query.setPage(page).getObjects();
      return snapshot.hits;
    } catch (e) {
      log(e.toString(), name: 'Algolia Api');
      return [];
    }
  }

  Future<List<DocumentSnapshot>> tempSearch() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final Query query =
        _firestore.collection('doctors').orderBy('name').limit(15);
    final QuerySnapshot snapshots = await query.get();
    return snapshots.docs;
  }
   Future<List<DocumentSnapshot>> getAllHospitals() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query =
        _firestore.collection('hospitals').orderBy('name').limit(15);
    final QuerySnapshot snapshots = await query.get();
    return snapshots.docs;
  }
}
