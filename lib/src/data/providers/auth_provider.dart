import 'dart:developer';
import 'dart:io';

import 'package:cloudnottapp2/src/data/service/google_service.dart';
import 'package:flutter/material.dart';
import 'package:cloudnottapp2/src/config/config.dart';
import 'package:cloudnottapp2/src/data/models/login_response_model.dart';
import 'package:cloudnottapp2/src/data/models/response_model.dart';
import 'package:cloudnottapp2/src/data/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';

import '../../screens/onboarding_screens/onboarding_screens.dart/signin.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  // final GoogleService googleService = GoogleService();

  AuthProvider({required this.authRepository});

  ResponseSuccess? successResponse;
  ResponseError? errorResponse;
  LoginResponseModel? loginResponse;
  bool _isLoading = false;
  bool _isLoadingStateTwo = false;
  bool _isError = false;
  bool _isSuccess = false;
  String _verifyToken = '';
  bool get isLoading => _isLoading;
  bool get isLoadingStateTwo => _isLoadingStateTwo;
  bool get isError => _isError;
  bool get isSuccess => _isSuccess;
  String get verifyToken => _verifyToken;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setLoadingStateTwo(bool value) {
    _isLoadingStateTwo = value;
    notifyListeners();
  }

  void setError(bool value) {
    _isError = value;
    notifyListeners();
  }

  void setSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  void setVerifyToken(String value) {
    _verifyToken = value;
    log('token sest $value');
    notifyListeners();
  }

  // Future<void> googleSignIn() async {
  //   try {
  //     reset();
  //     setLoadingStateTwo(true);
  //     final String? token = await googleService.signInWithGoogle();
  //     log("TOKEN: $token");
  //     final platForm = Platform.isAndroid ? "android" : "ios";
  //     Result<dynamic> result =
  //         await authRepository.googleSignin(token ?? "", platForm);
  //     if (result.response is ResponseError) {
  //       errorResponse = result.response as ResponseError;
  //       log("ERROR: ${errorResponse?.errors.toString()}");
  //       setError(true);
  //       setLoadingStateTwo(false);
  //       notifyListeners();
  //       return;
  //     }
  //     successResponse = result.response as ResponseSuccess;
  //     loginResponse = successResponse!.data as LoginResponseModel;
  //     localStore.put("token", loginResponse!.token);
  //     setSuccess(true);
  //     setLoadingStateTwo(false);
  //     notifyListeners();
  //   } catch (error) {
  //     log("ERROR: ${error.toString()}");
  //     errorResponse = ResponseError(message: error.toString());
  //     setError(true);
  //     setLoadingStateTwo(false);
  //     notifyListeners();
  //   }
  // }

  Future<void> signIn({required String email, required String password}) async {
    try {
      reset();
      setLoading(true);
      Result<dynamic> result = await authRepository.signIn(
        email: email,
        password: password,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        log("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      // var data = successResponse!.data as LoginResponseModel;
      loginResponse = successResponse!.data as LoginResponseModel;

      localStore.put("token", loginResponse!.token);
      setSuccess(true);
      setLoading(false);
      notifyListeners();
      return;
    } catch (error) {
      print("ERROR: ${error.toString()}");
      errorResponse = ResponseError(message: error.toString());
      setError(true);
      setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> changePassword({required String password}) async {
    try {
      reset();
      setLoading(true);
      // String token = localStore.get('token');
      // if (token.isEmpty) {
      //   token = verifyToken;
      // }
      log('my tokenssss  $verifyToken');
      Result<dynamic> result = await authRepository.changePassword(
        token: verifyToken,
        password: password,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      if (data == true) {
        setSuccess(true);
        setLoading(false);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERROR: ${errorResponse?.errors.toString()}");
      setError(true);
      setLoading(false);
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> changePasswordSpaceLevel(String password) async {
    try {
      reset();
      setLoading(true);
      String token = localStore.get('token');
      if (token.isEmpty) {
        token = verifyToken;
      }
      log('my tokenssss $token $verifyToken');
      Result<dynamic> result = await authRepository.changePassword(
        token: token,
        password: password,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as bool;
      if (data == true) {
        setSuccess(true);
        setLoading(false);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      errorResponse = ResponseError(message: e.toString());
      print("ERROR: ${errorResponse?.errors.toString()}");
      setError(true);
      setLoading(false);
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> resetPasswordProvider(String email) async {
    Result<dynamic> result = await authRepository.resetPassword(email: email);
    log("here in provider ${result.response}");
    try {
      reset();
      setLoading(true);

      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess?;
      var data = successResponse!.data as bool;

      if (successResponse?.data == null) {
        log("Error: successResponse.data is null");
        return false; // Handle null case properly
      }
      log("here in provider ${result.response}");
      if (data == true) {
        setSuccess(true);
        setLoading(false);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      log("here in provider ${e}");
      setError(true);
      setLoading(false);
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> resendPasswordProvider({
    required String email,
    required String activity,
  }) async {
    Result<dynamic> result = await authRepository.resendOtp(
      email: email,
      activity: activity,
    );
    log("here in provider ${result.response}");
    try {
      reset();
      setLoading(true);

      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return false;
      }
      successResponse = result.response as ResponseSuccess?;
      var data = successResponse!.data as bool;

      if (successResponse?.data == null) {
        log("Error: successResponse.data is null");
        return false; // Handle null case properly
      }
      log("here in provider ${result.response}");
      if (data == true) {
        setSuccess(true);
        setLoading(false);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      log("here in provider ${e}");
      setError(true);
      setLoading(false);
      notifyListeners();
      return false;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> verifyOtpPassword({
    required String email,
    required String otp,
    required String activity,
  }) async {
    try {
      reset();
      setLoading(true);

      Result<dynamic> result = await authRepository.verifyOtp(
        email: email,
        otp: otp,
        activity: activity,
      );
      if (result.response is ResponseError) {
        errorResponse = result.response as ResponseError;
        print("ERROR: ${errorResponse?.errors.toString()}");
        setError(true);
        setLoading(false);
        notifyListeners();
        return;
      }
      successResponse = result.response as ResponseSuccess;
      var data = successResponse!.data as String;
      if (data.isNotEmpty) {
        setSuccess(true);
        setLoading(false);
        notifyListeners();
        setVerifyToken(data);
      }
    } catch (e) {
      log("here in provider ${e}");
      setError(true);
      setLoading(false);
      notifyListeners();
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void logOut(BuildContext context) async {
    reset();
    await localStore.delete("token");
    await localStore.put("default_space_set", false);
    await localStore.delete('extraId');
    context.pushReplacement(SignInScreen.routeName);
  }

  bool isAuthenticated() {
    String value = localStore.get("token", defaultValue: "");
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  void reset() {
    errorResponse = null;
    successResponse = null;
    setError(false);
    setLoading(false);
    setLoadingStateTwo(false);
    setSuccess(false);
    notifyListeners();
  }
}
