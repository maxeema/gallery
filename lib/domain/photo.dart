
import 'dart:ui';

import 'package:flutter/material.dart';

import 'author.dart';

class Photo {

  final String
          id,
          description,
          color, // in format #00ff00
          url, // raw url
          htmlUrl,
          downloadUrl;

  final Size size;
  final Author author;

  Photo({this.id, this.description, this.color, this.url, this.htmlUrl, this.downloadUrl, this.size, this.author});

  @override
  bool operator ==(Object other) => other is Photo && other.id == id;

  @override
  int get hashCode => id.hashCode;

}