
import 'dart:ui';

import 'package:flutter/material.dart';

class Foto {

  final String
          id,
          description,
          color, // in format #00ff00
          url, // raw url
          htmlUrl,
          downloadUrl;

  final Size size;
  final Author author;

  Foto.from(Map<String, dynamic> img, Map<String, dynamic> user,
            Map<String, dynamic> urls, Map<String, dynamic> links) :
    id = img['id'],
    color = img['color'],
    author = Author.of(user),
    description = img['description'],
    size = Size((img['width'] as num).toDouble(), (img['height'] as num).toDouble()),
    url = urls['raw'],
    htmlUrl = links['html'],
    downloadUrl = links['download']
  ;

  @override
  bool operator ==(Object other) => other is Foto && other.id == id;

  @override
  int get hashCode => id.hashCode;

  String prepareUrl(Size size, Window window) => '$url&w=${size.width}&dpr=${window.devicePixelRatio}';

//  static double extractWidth(String url) => double.tryParse(.queryParameters['w']) ?? -1.0;

}

class Author {

  final String
        name,
        username,
        bio,
        location,
        unsplashUrl,
        avatarUrl,
        portfolioUrl,
        twitterUsername,
        instagramUsername;

  Author.of(Map<String, dynamic> user) :
        name = user['name'],
        username = user['username'],
        bio = user['bio'],
        location = user['location'],
        unsplashUrl = user['links']['html'],
        avatarUrl = user['profile_image']['large'],
        portfolioUrl = user['portfolio_url'],
        twitterUsername = user['twitter_username'],
        instagramUsername = user['instagram_username']
  ;

  String prepareAvatarUrl(int size, Window window) {
    final uri = Uri.parse(avatarUrl);
    final params = Map.of(uri.queryParameters);
    params['w'] = '$size';
    params['h'] = '$size';
    params['dpr'] = '${window.devicePixelRatio}';
    return Uri.https(uri.host, uri.path, params).toString();
  }

}