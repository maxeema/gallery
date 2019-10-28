
part of 'photos_model.dart';

class RandomPhotosModel extends PagedPhotosModel {

  RandomPhotosModel(Category category) : super(category);

  @override
  _listPageImpl(int page) => _repo.getRandom(query: categoryToSearch(category));

}
