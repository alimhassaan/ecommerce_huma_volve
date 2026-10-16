import 'package:ecommerce_app_huma_volve/core/constants/api_end_point.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';

import '../../../../core/networking/api_client.dart';
import '../model/login_model.dart';

class LoginServices {
  final ApiClient apiClient;
  LoginServices(this.apiClient);
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.dio.post(
      ApiEndPoint.login,
      data: {'email': email, 'password': password},
    );
    final Map<String, dynamic> jsonData = response.data;
    final modelData = LoginModel.fromJson(jsonData);

    await SecureStorage.saveAccessToken(modelData.accessToken);
    await SecureStorage.saveRefreshToken(modelData.refreshToken);
    await SecureStorage.saveProfile(
      name: email.split('@').first,
      email: email,
    );
    return modelData;
  }
}
