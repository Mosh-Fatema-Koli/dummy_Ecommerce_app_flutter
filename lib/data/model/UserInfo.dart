// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  String? id;
  String? email;
  String? phoneNumber;
  int? userId;
  String? fullName;
  int? isActive;
  String? designation;
  String? organization;
  String? username;
  String? token;
  String? deviceId;
  String? password;
  String? staffId;
  int? userApplicationRoleId;
  String? userApplicationRoleName;
  String? roleIds;

  UserInfo({
    this.id,
    this.email,
    this.phoneNumber,
    this.userId,
    this.fullName,
    this.isActive,
    this.designation,
    this.organization,
    this.username,
    this.token,
    this.deviceId,
    this.password,
    this.staffId,
    this.userApplicationRoleId,
    this.userApplicationRoleName,
    this.roleIds,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["Id"],
    email: json["Email"],
    phoneNumber: json["PhoneNumber"],
    userId: json["UserId"],
    fullName: json["FullName"],
    isActive: json["IsActive"],
    designation: json["Designation"],
    organization: json["Organization"],
    username: json["Username"],
    token: json["Token"],
    deviceId: json["DeviceId"],
    password: json["Password"],
    staffId: json["StaffID"],
    userApplicationRoleId: json["UserApplicationRoleId"],
    userApplicationRoleName: json["UserApplicationRoleName"],
    roleIds: json["RoleIds"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Email": email,
    "PhoneNumber": phoneNumber,
    "UserId": userId,
    "FullName": fullName,
    "IsActive": isActive,
    "Designation": designation,
    "Organization": organization,
    "Username": username,
    "Token": token,
    "DeviceId": deviceId,
    "Password": password,
    "StaffID": staffId,
    "UserApplicationRoleId": userApplicationRoleId,
    "UserApplicationRoleName": userApplicationRoleName,
    "RoleIds": roleIds,
  };
}
