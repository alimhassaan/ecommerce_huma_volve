class SignupResModel {
  int? id;
  String? name;
  String? email;
  String? avatar;
  String? creationAt;
  String? updatedAt;
  SignupResModel({this.id, this.name, this.email, this.avatar, this.creationAt, this.updatedAt});
  SignupResModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    creationAt = json['creationAt'];
    updatedAt = json['updatedAt'];
  }
  
}