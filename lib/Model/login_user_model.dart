// To parse this JSON data, do
//
//     final LoginUserDataModel = LoginUserDataModelFromJson(jsonString);

import 'dart:convert';

LoginUserDataModel loginUserDataModelFromJson(String str) =>
    LoginUserDataModel.fromJson(json.decode(str));

String loginUserDataModelToJson(LoginUserDataModel data) =>
    json.encode(data.toJson());

class LoginUserDataModel {
  int errorcode;
  String msg;
  UserDattum user;
  String token;

  LoginUserDataModel({
    required this.errorcode,
    required this.msg,
    required this.user,
    required this.token,
  });

  factory LoginUserDataModel.fromJson(Map<String, dynamic> json) =>
      LoginUserDataModel(
        errorcode: json["errorcode"],
        msg: (["", null, false, 0].contains(json["message"]))
            ? ""
            : json["message"],
        user: json["user"] == null || json["user"] == {}
            ? UserDattum(
                id: 0,
                name: "",
                email: "",
                mallIds: "",
                roleId: 0,
                location: "",
                phone: "")
            : UserDattum.fromJson(json["user"]),
        token:
            (["", null, false, 0].contains(json["token"])) ? "" : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "message": msg,
        "user": user.toJson(),
        "token": token,
      };
}

class UserDattum {
  int id;
  String name;
  String email;
  String mallIds;
  int roleId;
  // String emailVerifiedAt;
  // String picture;
  String location;
  String phone;
  // String createdAt;
  // String updatedAt;

  UserDattum({
    required this.id,
    required this.name,
    required this.email,
    required this.mallIds,
    required this.roleId,
    // required this.emailVerifiedAt,
    // required this.picture,
    required this.location,
    required this.phone,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory UserDattum.fromJson(Map<String, dynamic> json) => UserDattum(
        id: json["id"],
        name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
        email:
            (["", null, false, 0].contains(json["email"])) ? "" : json["email"],
        mallIds: (["", null, false, 0].contains(json["mall_ids"]))
            ? ""
            : json["mall_ids"],
        roleId: (["", null, false, 0].contains(json["role_id"]))
            ? 0
            : json["role_id"],
        // emailVerifiedAt:
        //     (["", null, false, 0].contains(json["email_verified_at"]))
        //         ? ""
        //         : json["email_verified_at"],
        // picture: (["", null, false, 0].contains(json["picture"]))
        //     ? ""
        //     : json["picture"],
        location: (["", null, false, 0].contains(json["location"]))
            ? ""
            : json["location"],
        phone:
            (["", null, false, 0].contains(json["phone"])) ? "" : json["phone"],
        // createdAt: (["", null, false, 0].contains(json["created_at"]))
        //     ? ""
        //     : json["created_at"],
        // updatedAt: (["", null, false, 0].contains(json["updated_at"]))
        //     ? ""
        //     : json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mall_ids": mallIds,
        "role_id": roleId,
        // "email_verified_at": emailVerifiedAt,
        // "picture": picture,
        "location": location,
        "phone": phone,
        // "created_at": createdAt,
        // "updated_at": updatedAt,
      };
}
