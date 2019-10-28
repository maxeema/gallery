
part of 'model.dart';

abstract class ActionInfo {
  final ModelAction action;
  ActionInfo(this.action);
}
class SuccessInfo extends ActionInfo {
  Set<Photo> photos;
  SuccessInfo(ModelAction action, this.photos) : super(action);
}
class FailureInfo extends ActionInfo {
  final String locKey;
  final String notLocalized;
  FailureInfo(ModelAction action, this.locKey, this.notLocalized) : super(action);
  //
  String toLocalizedMessage(AppLocalizations localizations) {
    String error = localizations.localized(locKey);
    if (isNotEmpty(notLocalized))
      error += '\n$notLocalized';

    return error;
  }
}

enum ModelStatus {
  loading, success, error,
}

enum ModelAction {
  list, refresh
}

class MutableModelData<T> extends ModelData<T> {

  set value(newValue) {
    _value = newValue;
    _observers.forEach((observe) => observe(value));
  }

}

class ModelData<T> {

  final _observers = <Function(T)>[];
  T _value;

  ModelData([T value]) : _value = value;

  observe(Function(T) observe)   => _observers.add(observe);
  unObserve(Function(T) observe) => _observers.remove(observe);

  T get value => _value;

  MutableModelData<T> get asMutable => this as MutableModelData;

}
