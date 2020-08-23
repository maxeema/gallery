
import 'dart:collection';

import 'package:gallery/domain/photo.dart';
import 'package:gallery/misc/categories.dart';
import 'package:gallery/misc/conf.dart' as conf;
import 'package:gallery/misc/injection.dart';
import 'package:gallery/repository/photos_repository.dart';

import 'model.dart';

part 'new_photos_model.dart';
part 'paged_photos_model.dart';
part 'random_photos_model.dart';
part 'random_query_photos_model.dart';

abstract class PhotosModel extends Model with Injectable {

  final Category category;

  final ModelData<SuccessInfo>   successEvent   = MutableModelData();
  final ModelData<ModelStatus>   status         = MutableModelData();
  final ModelData<FailureInfo>   failureEvent   = MutableModelData();

  PhotosRepository _repo;

  var _data = LinkedHashSet<Photo>();

  bool _hasMore;

  bool get isEmpty    => _data.isEmpty;
  bool get hasData    => _data.isNotEmpty;
  bool get hasMore    => _hasMore ?? false;

  PhotosModel(this.category) : super(category) {
    _repo = inject();
  }

  init() => listPhotos();

  Future<void>
  listPhotos();

  @override
  dispose() {
    _repo.dispose();
    super.dispose();
  }

}