// updatePassword
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Auth/Screens/change_password_model.dart';
import 'config/project_config.dart';

class ChangePasswordApiService {
  Future<ChangePasswordModel> changepassword(Map<String, dynamic> param) async {
    String url = ApiLinks().changepassword;
    final response = await http.post(Uri.parse(url), body: param);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return ChangePasswordModel.fromJson(data);
    } else {
      return ChangePasswordModel.fromError(data);
    }
  }
}
