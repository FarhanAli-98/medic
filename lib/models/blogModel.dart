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

class Blog {
  Blog({
    this.uid,
    this.title,
    this.url,
    this.imageUrl,
    this.description,
  });

  Blog.fromMap(Map json) {
    uid = json['uid'] ?? '';
    title = json['title'] ?? '';
    url = json['url'] ?? '';
    imageUrl = json['imageUrl'] ?? '';
    description = json['description'] ?? '';
    timestamp = json['timestamp'] ?? '';
  }
  String uid, title, url, imageUrl, description, timestamp;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid ?? '',
      'title': title ?? '',
      'url': url ?? '',
      'imageUrl': imageUrl ?? '',
      'description': description ?? '',
      'timestamp': timestamp ?? '',
    };
  }
}
