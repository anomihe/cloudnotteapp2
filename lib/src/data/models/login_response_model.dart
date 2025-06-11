class LoginResponseModel {
  String? token;
  bool? isVerified;

  LoginResponseModel({this.isVerified, this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> data) {
    return LoginResponseModel(
      token: data['token'],
      isVerified: data['isVerified'],
    );
  }
}
