
part of 'photos_model.dart';

class RandomPhotosModel extends PagedPhotosModel {

  RandomPhotosModel() : super(Category.RANDOM);

  @override
  _listPageImpl(int page) => _repo.getRandom();

}
