
part of 'photos_model.dart';

class NewPhotosModel extends PagedPhotosModel {

  final ModelData<bool> noFreshEvent = MutableModelData();

  NewPhotosModel([dynamic]) : super(Category.NEW);

  consumeNoFreshEvent() => noFreshEvent.asMutable.value = null;

  @override
  _listPageImpl(int page) => _repo.listNew(_page);

  Future<void>
  refreshPhotos() async {
    final result = await _repo.listNew(1);

    if (result.isSuccess) {
      final dataSizeBeforeRefresh = _data.length;

      if (!_data.containsAll(result.success.data))
        _data = LinkedHashSet.of(result.success.data)..addAll(_data);

      final dataSizeAfterRefresh = _data.length;
      final addedDataAmount = dataSizeAfterRefresh - dataSizeBeforeRefresh;

      if (addedDataAmount > 0)
        successEvent.asMutable.value = SuccessInfo(ModelAction.refresh, _data);
      else
        noFreshEvent.asMutable.value = true;

    } else {

      failureEvent.asMutable.value = FailureInfo(ModelAction.refresh, result.failure.locKey, result.failure.notLocalized);

    }

  }

}
