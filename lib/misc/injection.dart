
///
/// Simple DI
///

class Injectable {

  T inject<T>([args]) => injector.inject(args);

}

//
final injector = _Injector();
//

abstract class Injector {

  T inject<T>([args]);
  //
  factory<T>(T newInstance(dynamic));   // factories get args on each injecting
  single<T>(single);                    // singles support args only via register invocation

}

class _Injector implements Injector {

  static final _singles = <dynamic, dynamic>{};
  static final _factories = <dynamic, Function>{};

  @override
  factory<T>(T newInstance(dynamic)) {
    assert(!_factories.containsKey(T));
    _factories[T] = newInstance; // apply lazy
  }
  @override
  single<T>(single) {
    assert(!_singles.containsKey(T));
   _singles[T] = single; // apply as is
  }

  @override
  T inject<T>([args]) {
    // factories only as a lazy initializer and supports args here
    if (_factories.containsKey(T))
      return _factories[T](args);
    // singles could be already instantiated or it is a lazy initializer
    if (_singles.containsKey(T)) {
      dynamic single = _singles[T];
      if (single is Function)
        _singles[T] = single();
      return _singles[T];
    }
    //
    throw UnimplementedError();
  }

}
