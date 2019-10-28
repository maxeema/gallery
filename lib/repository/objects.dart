
part of 'photos_repository.dart';

class Result {
  final Success success;
  final Failure failure;
  final bool hasMore;

  Result(this.success, this.failure, this.hasMore);

  bool get isSuccess => success != null;
}
