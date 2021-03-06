library gallery.net;

import 'dart:convert';
import 'dart:io';

import 'package:gallery/localizations/localization.dart';
import 'package:gallery/misc/util.dart';

import 'package:http/http.dart' as http;

part 'objects.dart';
part 'processors.dart';
part 'queries.dart';
part 'real_api.dart';

abstract class Network {
  Future<NetworkResult>
  fetchNew(NewPhotoQuery query);

  Future<NetworkResult>
  search(SearchPhotoQuery query);

  Future<NetworkResult>
  getRandom(RandomQuery query);

  dispose();
}
