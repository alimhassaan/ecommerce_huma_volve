import 'package:ecommerce_app_huma_volve/core/constants/api_end_point.dart';

import '../../../../core/networking/api_client.dart';
import '../model/login_model.dart';

class LoginServices {
  final ApiClient apiClient;
  LoginServices(this.apiClient);
  Future<LoginModel> login({required String email, required String password}) async {
   final response= await apiClient.dio.post(
      ApiEndPoint.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return LoginModel.fromJson(response.data);
  }
}
