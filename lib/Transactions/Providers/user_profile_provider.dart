import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:mobi_pay/config/project_config.dart';

class UserProfileProvider with ChangeNotifier {
  String mId = "**";
  String code = "xx";
  int userId = 0;
  String firstName = "xx";
  String lastName = "xxxx";
  String merchantName = "xx xxxx";
  String userName = "xxxxxx";
  String mobileNumber = "";
  String email = "";
  String photoUrl = "";
  String countryId = "";
  String country = "";
  String dob = "";
  String gender = "Unknown";
  String genderShortName = "U";
  String loginStatus = 'fetching';
  String? errror;

  fetchData(String token, String userId) async {
    loginStatus = 'fetching';

    if (userId != "null") {
      this.userId = int.parse(userId);
    } else {
      this.userId = 1;
    }
    final response = await http.post(
      Uri.parse(ApiLinks().merchantDetailsApi),
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.jsonEncode({"token": token, "user_id": userId}),
    );

    // print('---- checking user is valid');
    // print(response.request);
    // print(response.statusCode);
    // print(response.body);

    switch (response.statusCode) {
      case 200:
        var results = JSON.jsonDecode(response.body);
        if (results['status'] == "success") {
          bool isSuspended = results['user_details'] != null &&
              results['user_details']['is_suspended'] != null &&
              results['user_details']['is_suspended'] == 1;
          if (isSuspended) {
            loginStatus = 'suspended';
            errror =
            'Your account has been suspended. Please contact support for more details.';
          } else {
            loginStatus = 'success';
          }

          merchantName =
          results['user_details']['get_merchant_details']['name'];
          mId = results['user_details']['get_merchant_details']['code'];
          code = results['user_details']['get_merchant_details']['code'];
          photoUrl =
              results['user_details']['get_merchant_details']['logo'] ?? "";
        } else if (results['status'] == 'error') {
          // may be suspended
          loginStatus = 'error';
          errror = "Your account has some problem. Please contact the support";
        } else {
          if (results['error'] != null) {
            // User may be deactivated
            print(results);
            final userDeactivated =
                results['type'] != null && results['type'] == 'deactivated';
            final unAuthorised = results['error'] == 'Unauthorized';
            if (userDeactivated) {
              loginStatus = 'deactivated';
              final msg = results['errMsg'] ??
                  "Your account has been deactivated. You'll be logged out of the account for now";
              errror = msg;
            } else if (unAuthorised) {
              loginStatus = 'unauthorized';
              errror =
              "Your account has some issue. Please contact support for details";
            } else {
              loginStatus = 'failed';
              errror = "Somthing went wrong";
            }
          }
        }
        print(loginStatus);
        break;
    }
    notifyListeners();
  }
}
