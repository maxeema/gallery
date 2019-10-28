
part of 'photos_model.dart';

const _maxRecursiveTryCount = 10;

abstract class PagedPhotosModel extends PhotosModel {

  var _page = 0;
  int get page => _page;

  final ModelData<bool> noMoreEvent  = MutableModelData();

  PagedPhotosModel(Category category) : super(category);

  consumeNoMoreEvent()  => noMoreEvent.asMutable.value = null;

  Future<Result>
  _listPageImpl(int page);

  Future<Result>
  _listPage() async {
    final result = await _listPageImpl(_page);
    if (result.isSuccess)
      _page++;
    return result;
  }

  handleNewData(Set<Photo> newData) {
    _data..addAll(newData);
  }

  listPhotos() async {
//    print('list photos, cur page: $page, ${status.value}, isLoading: ${status.value == ModelStatus.loading}');
    if (status.value == ModelStatus.loading)
      return;
    status.asMutable.value = ModelStatus.loading;

    final result = await _listPhotos();
    if (result.isSuccess) {
      status.asMutable.value = ModelStatus.success;
    } else {
      status.asMutable.value = ModelStatus.error;
    }
  }

  Future<Result>
  _listPhotos([recursiveNewDataAmount=0, recursiveTryCount=0]) async {
//    print('\ncall listPhotosImpl, recursiveDataAddedAmount: $recursiveNewDataAmount');

    final result = await _listPage();

    _hasMore = result.hasMore;

    if (!result.hasMore)
      noMoreEvent.asMutable.value = true;

    if (result.isSuccess) {

//      print('\non success, before merging to '
//            '\n data now size: ${_data.length}'
//            '\n data response size: ${result.success.data.length}');

      final newData = result.success.data.difference(_data);
      
      if (newData.isNotEmpty)
        handleNewData(newData);

      recursiveNewDataAmount += newData.length;
      
//      print('\n new data size: ${newData.length}'
//            '\n now data size: ${_data.length}'
//            '\n recursiveDataAddedAmount $recursiveNewDataAmount'
//            '\n minUniquePhotosPerUiOperation ${conf.minUniquePhotosPerUiOperation}');

      if (newData.length > 0)
        successEvent.asMutable.value = SuccessInfo(ModelAction.list, _data);

      if (recursiveNewDataAmount < conf.minUniquePhotosPerUiOperation
              && result.hasMore && recursiveTryCount < _maxRecursiveTryCount)
        return _listPhotos(recursiveNewDataAmount, recursiveTryCount+1);

    } else {
      
      failureEvent.asMutable.value = FailureInfo(ModelAction.list, result.failure.locKey, result.failure.notLocalized);
      
    }

    return result;
  }

}
