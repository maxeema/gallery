
import 'dart:async';

import 'package:gallery/domain/domain_utils.dart';
import 'package:gallery/domain/objects.dart';
import 'package:gallery/misc/conf.dart' as conf;
import 'package:gallery/misc/injection.dart';
import 'package:gallery/network/api.dart' as net;

import 'photos_repository.dart';

typedef Future<net.NetworkResult> PhotosTransaction();

const _minErrorTransactionTime = 500;

class PhotosRepositoryImpl extends PhotosRepository with Injectable {

  net.Network _net;

  PhotosRepositoryImpl() {
    this._net = inject();
  }

  @override
  listNew(int page) =>
      _process(() => _net.fetchNew(net.NewPhotoQuery(page, conf.apiPhotosPerPage)));

  @override
  search(String query, int page) =>
      _process(() => _net.search(net.SearchPhotoQuery(query, page, conf.apiPhotosPerPage)));

  @override
  getRandom({int count = conf.apiPhotosPerPage, String query}) =>
      _process(() => _net.getRandom(net.RandomQuery(count, query)));

  Future<Result>
  _process(PhotosTransaction transaction) async {
    final watcher = Stopwatch()..start();
    net.NetworkResult result;
    try {
      result = await transaction();
    } finally {
      watcher.stop();
    }
    if (result.isSuccess) {
      final data = toDomainPhotos(result.success.data);
      return Result(Success(data), null, result.hasMore);
    } else {
      if (watcher.elapsedMilliseconds < _minErrorTransactionTime)
        await Future.delayed(Duration(milliseconds: _minErrorTransactionTime - watcher.elapsedMilliseconds));
      final failure = toRepositoryFailure(result.failure);
      return Result(null, failure, result.hasMore);
    }
  }

  @override
  dispose() => _net.dispose();

}