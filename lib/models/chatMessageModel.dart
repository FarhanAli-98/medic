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

import 'package:flutter/foundation.dart';

class ChatMessage {
  ChatMessage({
    @required this.content,
    @required this.idFrom,
    @required this.idTo,
    @required this.timestamp,
    @required this.type,
  })  : assert(content != null),
        assert(idFrom != null),
        assert(idTo != null),
        assert(timestamp != null),
        assert(type != null);

  ChatMessage.fromMap(Map<String, dynamic> json) {
    content = json['content'];
    idFrom = json['idFrom'];
    idTo = json['idTo'];
    timestamp = json['timestamp'] != null
        ? int.parse(json['timestamp'].toString())
        : null;
    type = json['type'] != null ? int.parse(json['type'].toString()) : null;
  }

  String content, idFrom, idTo;
  int type, timestamp;

  /// Returns a map format of the chat message object
  Map<String, dynamic> toMap() {
    return {
      'content': content ?? '',
      'idFrom': idFrom ?? '',
      'idTo': idTo ?? '',
      'timestamp': timestamp.toString() ?? '',
      'type': type.toString() ?? '',
    };
  }
}
