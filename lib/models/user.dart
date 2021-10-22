import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants.dart' as Constants;

class User {
  late String name;
  late String email;

  User({String name = '', String email = ''}) {
    this.name = name;
    this.email = email;
  }

  static Future<User?> fromApiToken(String apiToken) async {
    final url = Uri.parse('${Constants.API_BASE_URL}api/user');

    print('fromApiToken');

    try {
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer ' + apiToken});

      print(response);

      return User.fromJson(jsonDecode(response.body));
    } on SocketException {
      return null;
    }
  }

  // create the user object from json input
  User.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.email = json['email'];
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
