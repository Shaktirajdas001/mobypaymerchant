import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobi_pay/config/sync_configue_model.dart';
import '../../config/project_config.dart';
import 'dart:convert' as JSON;

class SysConfigProvider with ChangeNotifier {
  List<ConfigModel> sysConfig = [];
  var contact_url = "";
  var faq_url = "";

  fetchData() async {
    final response = await http.post(
      Uri.parse(ApiLinks().syncConfigue),
      headers: {
        "Content-Type": "application/json",
        // "ApiKey": AppConfig().apiKey,
      },
      body: JSON.jsonEncode({
        "mobile_app_key": ProjectConfig().mobileAppKey,
      }),
    );
    switch (response.statusCode) {
      case 200:
        var results = JSON.jsonDecode(response.body);
        if (results['status'] == "success") {
          var data = results['sys_config'];
          List<ConfigModel> temp = [];
          data.forEach((item) {
            temp.add(ConfigModel(
              item['id'],
              item['key'],
              item['value'],
              item['valueBox'] ?? '',
              item['text'] ?? '',
            ));
            if (item['key'] == "platform.url.contact_us.merchant") {
              contact_url = item['value'];
            }
            if (item['key'] == "platform.url.faq.merchant") {
              faq_url = item['value'];
            }
          });
          sysConfig = temp;
        }
        break;
      default:
        break;
    }

    notifyListeners();
  }

  String getValue(String key) {
    String value = '';
    for (var element in sysConfig) {
      if (element.key == key) {
        value = element.value.toString();
      }
    }
    return value;
  }
}
