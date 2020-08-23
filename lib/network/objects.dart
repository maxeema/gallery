
part of gallery.net;

class NetworkResult {
  final dynamic query;
  final Success success;
  final Failure failure;
  final bool hasMore;

  bool get isSuccess => success != null;

  const NetworkResult(this.query, this.success, this.failure, {this.hasMore = true});
}

class Success {
  final dynamic data;

  Success(this.data);

  @override
  String toString() => 'success';
}

class Failure {
  final dynamic error;

  Failure(this.error);

  bool get isApi    => error is ApiError;
  bool get isRemote => error is RemoteError;
  bool get isLang   => error is Exception || error is Error;

  ApiError    get asApi    => error;
  RemoteError get asRemote => error;

  @override
  String toString() => 'failure';
}

class ApiError {
  final String locKey;

  ApiError(this.locKey);
}

class RemoteError {
  final String notLocalized;

  RemoteError(this.notLocalized);
}