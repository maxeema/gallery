import 'dart:collection';

import 'package:maxeem_gallery/domain/objects.dart';
import 'package:maxeem_gallery/domain/photo.dart';
import 'package:maxeem_gallery/localizations/localization.dart';
import 'package:maxeem_gallery/misc/categories.dart';
import 'package:maxeem_gallery/misc/util.dart';

import 'photos_model.dart';

part 'objects.dart';

abstract class Model {

  final dynamic key;

  Model(this.key);

  dispose() {
    _forget(key);
  }

}

PhotosModel modelByCategory(Category category) {
  switch (category) {
    case Category.NEW:
      return _create<NewPhotosModel>(category);
    case Category.RANDOM:
      return _create<RandomPhotosModel>(category);
    default:
      return _create<RandomQueryPhotosModel>(category);
  }
  throw ArgumentError();
}

// caching / mapping Models

final _cache = <dynamic, Model>{ };

final _map = <Type, Function> {
  NewPhotosModel:             (_) => NewPhotosModel(),
  RandomPhotosModel:          (_) => RandomPhotosModel(),
  RandomQueryPhotosModel:     (category) => RandomQueryPhotosModel(category),
};

T _create<T extends Model>([key]) => _cache.putIfAbsent(key, ()=> _map[T](key));

_forget(key) => _cache.remove(key);
