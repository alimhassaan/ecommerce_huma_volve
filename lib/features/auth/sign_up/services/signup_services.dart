import 'package:ecommerce_app_huma_volve/core/constants/api_end_point.dart';
import 'package:ecommerce_app_huma_volve/core/networking/api_client.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_req_model.dart';
import 'package:ecommerce_app_huma_volve/features/auth/sign_up/models/signup_res_model.dart';
import 'package:ecommerce_app_huma_volve/core/storage/secure_storage.dart';

class SignupServices extends ApiClient {
  ApiClient apiClient;
  SignupServices(this.apiClient);
  Future<SignupResModel> signup({required SignupReqModel signupReqModel}) async {
    final response = await apiClient.dio.post(
      ApiEndPoint.register,
      data: {
        'name': signupReqModel.name,
        'email': signupReqModel.email,
        'password': signupReqModel.password,
        'avatar':'https://api.lorem.space/image/face?w=640&h=480'
      }
    );
    final result = SignupResModel.fromJson(response.data);
    await SecureStorage.saveProfile(
      name: result.name ?? signupReqModel.name,
      email: result.email ?? signupReqModel.email,
      avatar: result.avatar ?? '',
    );
    return result;
  }
}