
import 'photo.dart';

class Success {
  final Set<Photo> data;

  Success(this.data);
}

class Failure {
  final FailureType type;
  final String locKey;
  final String notLocalized;

  Failure(this.type, this.locKey, this.notLocalized);
}

enum FailureType {
  api, server, lang
}
