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
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/doctorModel.dart';
import 'package:doctor_consultation/models/hospitalModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';

/// Manages the state of the search screen
class SearchProvider extends BaseProvider {
  String _searchTerm = '';
  String get searchTerm => _searchTerm;
  set setSearchTerm(String value) {
    _searchTerm = value;
  }

  // By default this is the search filter type.
  SearchFilterType _filter = SearchFilterType.DOCTOR;
  SearchFilterType get filter => _filter;
  set setFilter(SearchFilterType type) {
    _filter = type;
    if (_searchTerm.isNotEmpty) {
      // NotifyLoading calls the fetch data automatically.
      notifyLoading();
    }
  }

  // Data stores:
  List<Doctor> _doctorList = [];
  List<Doctor> _specialityDoctorList = [];
  List<Hospital> _hospitalList = [];

  List<Doctor> get doctorList => _doctorList;
  List<Doctor> get specialityDoctorList => _specialityDoctorList;
  List<Hospital> get hospitalList => _hospitalList;

  // Ref to last DocumentSnapshot for query results
  DocumentSnapshot _lastSpecialityDoctorDocument;

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _searchTerm = '';
    _filter = SearchFilterType.DOCTOR;
    _doctorList = [];
    _specialityDoctorList = [];
    _hospitalList = [];
    _lastSpecialityDoctorDocument = null;
  }

  void searchData() {
    switch (_filter) {
      case SearchFilterType.DOCTOR:
        searchDoctors();
        break;

      case SearchFilterType.HOSPITAL:
        searchHospitals();
        break;

      case SearchFilterType.SPECIALITY:
        searchDoctorsSpeciality();
        break;

      default:
        searchDoctors();
    }
  }

  /// ********************************************************
  /// `Hospitals Functions`
  /// ********************************************************

  Future<void> searchHospitals() async {
    try {
      final result = await LocatorService.algoliaApi().getAllHospitals();

      if (result == null) {
        notifyError(errorText: AppStrings.searchSomething);
        return;
      } else {
        final list = <Hospital>[];
        for (final elem in result) {
          final Hospital obj = Hospital.fromMap(elem.data());
          if (obj.name.toLowerCase() == searchTerm.toLowerCase() ||
              obj.name.toLowerCase().contains(searchTerm.toLowerCase())) {
            list.add(obj);
          }
        }
        if (list.isNotEmpty) {
          _hospitalList = list;
          notifyState(ViewState.DATA);
        } else {
          notifyError(errorText: AppStrings.searchSomething);
          return;
        }
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }

    // try {
    //   final result = await LocatorService.algoliaApi()
    //       .search(searchTerm, Config.ALGOLIA_HOSPITALS_INDEX);

    //   if (result == null) {
    //     notifyError(errorText: AppStrings.searchSomething);
    //     return;
    //   } else {
    //     final list = <Hospital>[];
    //     for (final elem in result) {
    //       final Hospital obj = Hospital.fromMap(elem.data);
    //       list.add(obj);
    //     }
    //     _hospitalList = list;
    //     notifyState(ViewState.DATA);
    //   }
    // } catch (e) {
    //   notifyError(errorText: e.toString());
    // }
  }

  Future<void> searchMoreHospitals(int page) async {
    try {
      log('Searching more Hospitals');
      final result = await LocatorService.algoliaApi()
          .search(searchTerm, Config.ALGOLIA_HOSPITALS_INDEX, page: page);

      if (result.isEmpty && _hospitalList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        for (final elem in result) {
          final Hospital obj = Hospital.fromMap(elem.data);
          _hospitalList.add(obj);
        }
        notifyState(ViewState.DATA);
      }
    } catch (e) {
      if (_hospitalList.isNotEmpty) {
        notifyState(ViewState.DATA);
      } else {
        log('Error $e');
        notifyError(errorText: e.toString());
      }
    }
  }

  /// ***********************************************************
  /// `Doctors Functions`
  /// ***********************************************************

  Future<void> searchDoctors() async {
    try {
      //TODO need to change this
      log('Calling search doctors');
      final result = await LocatorService.algoliaApi().tempSearch();
      if (result.isEmpty && _doctorList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        //TEMPERORY LOGIC FOR GET DOCTORS
        final list = <Doctor>[];
        for (final element in result) {
          final Doctor obj = Doctor.fromMap(element.data());
          if (obj.name.toLowerCase() == searchTerm.toLowerCase() ||
              obj.email.contains(searchTerm.toLowerCase())) {
            list.add(obj);
          }
        }
        if (list.isEmpty) {
          log('No data');
          notifyState(ViewState.NO_DATA_AVAILABLE);
        } else {
          _doctorList = list;
          notifyState(ViewState.DATA);
        }

        // final result = await LocatorService.algoliaApi()
        //     .search(searchTerm, Config.ALGOLIA_HOSPITALS_INDEX);

        //////////////////////
        // final list = <Doctor>[];
        // for (final elem in result) {
        //   final Doctor obj = Doctor.fromMap(elem.data);
        //   list.add(obj);
        // }
        // _doctorList = list;
        // notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  Future<void> searchMoreDoctors(int page) async {
    final result = await LocatorService.algoliaApi().tempSearch();
    if (result.isEmpty && _doctorList.isEmpty) {
      log('No data');
      notifyState(ViewState.NO_DATA_AVAILABLE);
      return;
    } else {
      //TEMPERORY LOGIC FOR GET DOCTORS
      final list = <Doctor>[];
      for (final element in result) {
        final Doctor obj = Doctor.fromMap(element.data());
        if (obj.name.toLowerCase() == searchTerm.toLowerCase() ||
            obj.email.contains(searchTerm.toLowerCase())) {
          list.add(obj);
        }
      }
      if (list.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
      } else {
        _doctorList = list;
        notifyState(ViewState.DATA);
      }
    }
    // try{
    //   log('Searching more doctors');
    //   final result = await LocatorService.algoliaApi()
    //       .search(searchTerm, Config.ALGOLIA_DOCTORS_INDEX, page: page);

    //   if (result.isEmpty && _doctorList.isEmpty) {
    //     log('No data');
    //     notifyState(ViewState.NO_DATA_AVAILABLE);
    //     return;
    //   } else {
    //     for (final elem in result) {
    //       final Doctor obj = Doctor.fromMap(elem.data);
    //       _doctorList.add(obj);
    //     }
    //     notifyState(ViewState.DATA);
    //   }
    // } catch (e) {
    //   if (_doctorList.isNotEmpty) {
    //     notifyState(ViewState.DATA);
    //   } else {
    //     log('Error $e');
    //     notifyError(errorText: e.toString());
    //   }
    // }
  }

  /// ******************************************************
  /// Speciality related functions
  /// ******************************************************

  Future<void> searchDoctorsSpeciality() async {
    if (_searchTerm.isEmpty) {
      return;
    }
//Todo : this one is temperory logic for search doctors according speciality
    // final List<String> searchList = _searchTerm.split(',').map<String>((e) {
    //   return e.toLowerCase();
    // }).toList();

    try {
      log('Calling speciality search doctors');
      final result = await LocatorService.algoliaApi().tempSearch();

      if (result.isEmpty && _specialityDoctorList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastSpecialityDoctorDocument = result.last;

        final list = <Doctor>[];
        for (final element in result) {
          final Doctor obj = Doctor.fromMap(element.data());
          if (obj.specialities.contains(searchTerm)) {
            list.add(obj);
          }
        }
        if (list.isEmpty) {
          log('No data');
          notifyState(ViewState.NO_DATA_AVAILABLE);
        } else {
          _specialityDoctorList = list;
          notifyState(ViewState.DATA);
        }
      }

      // final result =
      //     await FirestoreService.searchDoctorsWithSpeciality(searchList);

      // if (result.isEmpty && _specialityDoctorList.isEmpty) {
      //   log('No data');
      //   notifyState(ViewState.NO_DATA_AVAILABLE);
      //   return;
      // } else {
      //   // set the last document reference
      //   _lastSpecialityDoctorDocument = result.last;

      //   final list = <Doctor>[];
      //   for (final elem in result) {
      //     final Doctor obj = Doctor.fromMap(elem.data());
      //     list.add(obj);
      //   }
      //   _specialityDoctorList = list;
      //   notifyState(ViewState.DATA);
      // }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  Future<void> searchMoreDoctorsSpeciality() async {
    if (_searchTerm.isEmpty) {
      return;
    }

    final List<String> searchList = _searchTerm.split(',').map<String>((e) {
      return e.toLowerCase();
    }).toList();

    try {
      log('Searching more doctors');
      final result = await FirestoreService.searchMoreDoctorsWithSpeciality(
          _lastSpecialityDoctorDocument, searchList);

      if (result.isEmpty && _specialityDoctorList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastSpecialityDoctorDocument =
            result.last ?? _lastSpecialityDoctorDocument;

        for (final elem in result) {
          final Doctor obj = Doctor.fromMap(elem.data());
          _specialityDoctorList.add(obj);
        }
        notifyState(ViewState.DATA);
      }
    } catch (e) {
      if (_specialityDoctorList.isNotEmpty) {
        notifyState(ViewState.DATA);
      } else {
        log('Error $e');
        notifyError(errorText: e.toString());
      }
    }
  }
}

/// Types of data filters that can be sorted through.
enum SearchFilterType {
  DOCTOR,
  HOSPITAL,
  BLOGS,
  DISEASE,
  SPECIALITY,
}
