
part of 'photos_model.dart';

class RandomQueryPhotosModel extends PagedPhotosModel {

  RandomQueryPhotosModel(Category category) : super(category);

  @override
  _listPageImpl(int page) => _repo.getRandom(query: categoryToSearch(category));

}
