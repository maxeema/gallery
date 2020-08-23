
import 'dart:io';

import 'package:gallery/domain/objects.dart';
import 'package:gallery/localizations/localization.dart';
import 'package:gallery/network/api.dart' as net;

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
