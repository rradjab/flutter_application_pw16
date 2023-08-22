import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:task_4/models/user_model.dart';

Future<List<User>?> readJson() async {
  final String response = await rootBundle.loadString('assets/users.json');
  final data = await json.decode(response) as Map<String, dynamic>;
  try {
    return UserModel.fromJson(data).users;
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
  return [];
}
