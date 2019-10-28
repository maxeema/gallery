part of 'photos_repository.dart';

Failure
toRepositoryFailure(net.Failure failure) {

  FailureType failureType;
  String errLocKey;
  String notLocalizedErrMsg;

  if (failure.isLang) {
    failureType = FailureType.lang;
    if (failure.error is IOException)
      errLocKey = LocKeys.noNet;
    else
      errLocKey = LocKeys.errInLog;
  } else if (failure.isApi) {
    failureType = FailureType.api;
    errLocKey = failure.asApi.locKey;
  } else {
    failureType = FailureType.server;
    errLocKey = LocKeys.remoteError;
    notLocalizedErrMsg = failure.asRemote.notLocalized;
  }

  return Failure(failureType, errLocKey, notLocalizedErrMsg);

}
