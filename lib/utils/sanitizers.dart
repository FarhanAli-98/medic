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

///
/// ## `Description`
///
/// Holds functions to sanitize user input before
/// updating database
///
class Sanitizer {
  static List<String> sanitizeSpecialities(List<String> specialities) {
    final Set<String> newList = {};

    // Sanitize the list items
    for (final element in specialities) {
      newList.add(element?.trim()?.toLowerCase());
    }

    return newList.toList();
  }

  /// Returns the string with the initial letter as the capital
  static String initialCapital(String value) {
    assert(value != null);
    assert(value.isNotEmpty);
    return value.substring(0, 1).toUpperCase() +
        value.substring(1, value.length).toLowerCase();
  }
}
