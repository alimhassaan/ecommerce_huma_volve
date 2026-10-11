class SignupReqModel {
  String name;
  String email;
  String password;

  SignupReqModel({required this.name, required this.email, required this.password});

  factory SignupReqModel.fromJson(Map<String, dynamic> json) {
    return SignupReqModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}