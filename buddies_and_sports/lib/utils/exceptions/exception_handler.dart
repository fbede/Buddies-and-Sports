import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

part 'exception_codes.dart';
part 'exception_responses.dart';

class ExceptionHandler {
  static String errorMessageFromError({required Exception exception}) {
    //TODO:Remove
    if (kDebugMode) {
      print(exception);
    }
    if (exception is FirebaseAuthException) {
      return _handleFirebaseAuthException(exception);
    } else if (exception is SocketException) {
      return 'Could not connect to the server. Please check your internet connection';
    } else {
      return exception.toString();
    }
  }

  static String _handleFirebaseAuthException(FirebaseAuthException e) {
    String errorMessage = '';
    switch (e.code) {
      case _weakPasswordErrCode:
        errorMessage = _weakPasswordResponse;
        break;
      case _emailInUseErrCode:
        errorMessage = _emailInUseResponse;
        break;
      case _failedNetworkRequestErrCode:
        errorMessage = _noInternetResponse;
        break;
      case _invalidEmailErrCode:
        errorMessage = _invalidEmailResponse;
        break;
      case _wrongPasswordErrCode:
        errorMessage = _wrongPasswordResponse;
        break;
      case _userNotFoundErrCode:
        errorMessage = _userEmailNotFoundResponse;
        break;
      case _userDisabledErrCode:
        errorMessage = _userDisabledResponse;
        break;
      case _tooManyRequestErrCode:
        errorMessage = _tooManyRequestResponse;
        break;
      case _operationNotAllowedErrCode:
        errorMessage = _operationNotAllowedResponse;
        break;

      default:
        errorMessage = e.code;
    }
    return errorMessage;
  }
}
