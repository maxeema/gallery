library maxeem_gallery.net;

import 'dart:convert';
import 'dart:io';

import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/util.dart';

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
