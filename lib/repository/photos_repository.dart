
import 'dart:io';

import 'package:maxeem_gallery/domain/objects.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/network/api.dart' as net;

part 'objects.dart';
part 'repository_utils.dart';

abstract class PhotosRepository {

  Future<Result>
  listNew(int page);

  Future<Result>
  search(String query, int page);

  Future<Result>
  getRandom({int count, String query});

  dispose();

}
