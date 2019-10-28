
import 'dart:ui';

import 'author.dart';
import 'photo.dart';

Set<Photo> toDomainPhotos(List<dynamic> data) {
  return data.map((item) => toDomainPhoto(item as Map<dynamic, dynamic>)).toSet();
}

Photo toDomainPhoto(Map data) {
  final urls = data['urls'];
  final links = data['links'];
  return Photo(
      id: data['id'],
      description: data['description'],
      color: data['color'],
      url: urls['raw'],
      htmlUrl: links['html'],
      downloadUrl: links['download'],
      size: Size((data['width'] as num).toDouble(), (data['height'] as num).toDouble()),
      author: toDomainAuthor(data['user'])
  );
}

Author toDomainAuthor(Map user) {
  return Author(
      name: user['name'],
      username: user['username'],
      bio: user['bio'],
      location: user['location'],
      unsplashUrl: user['links']['html'],
      avatarUrl: user['profile_image']['large'],
      portfolioUrl: user['portfolio_url'],
      twitterUsername: user['twitter_username'],
      instagramUsername: user['instagram_username']
  );
}