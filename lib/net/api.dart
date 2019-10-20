library unsplash_gallery.net;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:unsplash_gallery/data.dart';

export 'package:unsplash_gallery/data.dart';

part 'fake_network.dart';
part 'real_network.dart';

///
/// Network API
///

abstract class Api {

  Future<ApiResult>
  getPhotos(int page);

  dispose();
}

enum ApiStatus {
  loading,
  success,
  error,
}

class Query {
  final Uri uri;      // requested uri
  final int page,     // page number
            perPage;  // items per page

  const Query(this.uri, this.page, this.perPage);

  @override
  String toString() => uri.toString();
}

class Response {

  final Query query;
  final Iterable<Foto> data;

  final int rateLimit,          // Limit of requests per hour, for ex: now it is 500 per hour in release mode, or 50 in dev mode
            rateLimitRemaining; // Remaining limit of requests, for ex: 499, 488, ... or 50, 49, ... respectively
  final int total;              // Total elements at the requested path

  const Response(this.query, this.data, {this.rateLimit, this.rateLimitRemaining, this.total});

}

abstract class ApiResult {
  final ApiStatus status;

  const ApiResult(this.status);

  static well(Response response, bool noMore) => WellResult(response, noMore);
  static bad(String msg, [dynamic error]) => BadResult(msg, error);

  BadResult get toBad => this;
  WellResult get toWell => this;
}

class WellResult extends ApiResult {
  final Response response;
  final bool noMore;
  const WellResult(this.response, [this.noMore=false]) : super(ApiStatus.success);
}

class BadResult extends ApiResult {
  final String msg;
  final dynamic error;
  const BadResult(this.msg, [this.error]) : super(ApiStatus.error);
}
