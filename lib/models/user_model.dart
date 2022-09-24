import 'package:flutter/material.dart';

class UserLoginModel {
  dynamic message;
  bool status;
  UserData? data;

  UserLoginModel({this.data, required this.status, required this.message});

  factory UserLoginModel.fromJson(dynamic jsonData) {
    final status = jsonData['status'];
    print('statusssss:$status');
    final message = jsonData['message'];
    final data =
        jsonData['data'] == null ? null : UserData.fromJson(jsonData['data']);
    return UserLoginModel(status: status, message: message, data: data);
  }
//   UserLoginModel.fromJson(dynamic data){
//   message=data['message'];
//   status=data['status'];
//   data=data['data'];
// }

}

class UserData {
  int id;
  String name;
  String email;
  String phone;
  int points;
  int credit;
  String token;
  UserData(
      {required this.email,
      required this.token,
      required this.name,
      required this.id,
      required this.credit,
      required this.phone,
      required this.points});

  factory UserData.fromJson(dynamic jsonData) {
    final email = jsonData['email'];

    final token = jsonData['token'];

    final name = jsonData['name'];

    final id = jsonData['id'];

    final credit = jsonData['credit'];

    final phone = jsonData['phone'];

    final points = jsonData['points'];
    print('points:$points');

    return UserData(
      email: email,
      token: token,
      name: name,
      id: id,
      credit: credit,
      phone: phone,
      points: points,
    );
  }
}
