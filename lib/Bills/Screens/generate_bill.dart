import 'package:flutter/services.dart';
import 'package:mobi_pay/Auth/Screens/sign_in.dart';
import 'package:mobi_pay/Transactions/Providers/user_profile_provider.dart';
import 'package:mobi_pay/Transactions/Screens/trasnsaction_details.dart';
import 'package:mobi_pay/Transactions/Widgets/tabs.dart';
import 'package:mobi_pay/Transactions/models/transaction_model.dart';
import 'package:mobi_pay/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobi_pay/config/project_config.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as JSON;

import 'package:shared_preferences/shared_preferences.dart';

class GenerateBill extends StatefulWidget {
  const GenerateBill({Key? key}) : super(key: key);

  @override
  State<GenerateBill> createState() => _GenerateBillState();
}

class _GenerateBillState extends State<GenerateBill> {
  openmodal() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: MediaQuery.of(ctx).viewInsets,
          );
        });
  }

  final orderAmtController = TextEditingController();
  bool _isLoading = false;
  // String _token = "";
  // int? _mId = 0;
  // fetchIsLogin() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.containsKey('status') &&
  //       sharedPreferences.getString("status") == "success") {
  //     _mId = sharedPreferences.getInt("merchant_id");
  //     var status = sharedPreferences.getString("status");
  //     _token = sharedPreferences.getString("token").toString();
  //   } else {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => SignIn()));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Tabs(0),
      backgroundColor: const Color(page_color),
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            height: 150,
            padding: const EdgeInsets.only(top: 50, left: 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(tag_grey_bg),
            ),
            child: const Text(
              "Create Order",
              style: TextStyle(
                  color: Color(primary_text),
                  fontSize: app_tittle,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            height: 130,
            margin: const EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(container_bg),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 221, 221, 221),
                    blurRadius: 4.0,
                  ),
                ]),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Order Amount',
                    style: TextStyle(
                        fontSize: sub_title,
                        color: Color(subtitle_grey),
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'RM',
                      style: TextStyle(
                          fontSize: app_tittle,
                          color: Color(label_text),
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 120,
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'))
                        ],
                        keyboardType:
                        const TextInputType.numberWithOptions(
                            decimal: true),
                        controller: orderAmtController,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Color(primary_color)),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w700,
                              color: Color(label_text)),
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SizedBox(
              height: button_height,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(primary_color),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    )),
                onPressed: () {
                  _createBillApiFunc();
                },
                child: const Text(
                  "Create",
                  style: TextStyle(fontSize: button_text),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _createBillApiFunc() async {
    if (orderAmtController.text == "" ||
        double.parse(orderAmtController.text) < 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context, 'Error', 'Please Enter a Valid Order Amount'),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String _userId = sharedPreferences.getInt("user_id").toString();
    String _token = sharedPreferences.getString("token").toString();
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    await provider.fetchData(_token, _userId);

    final loginStatus = provider.loginStatus;
    final error = provider.errror;
    if (loginStatus == 'success') {
      // user is valid. now proceed the order creation
      final response = await http.post(
        Uri.parse(ApiLinks().createBillApi),
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.jsonEncode({
          "token": sharedPreferences.getString("token"),
          "user_id": sharedPreferences.getInt("user_id"),
          "amount": orderAmtController.text,
          "mobile_app_key": ProjectConfig().mobileAppKey
        }),
      );
      setState(() {
        _isLoading = false;
      });

      switch (response.statusCode) {
        case 200:
          var results = JSON.jsonDecode(response.body);
          if (results['status'] == "success") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TransactionDetails(
                        TransactionModel(
                          results['bill_details']['id'].toString(),
                          results['bill_details']['bill_code'].toString(),
                          results['bill_details']['amount'].toString(),
                          results['bill_details']['created_at'].toString(),
                          results['bill_details']['created_time'].toString(),
                          results['bill_details']['created_date'].toString(),
                          results['bill_details']['merchant_ref'].toString(),
                          results['bill_details']['billing_stage_id']
                              .toString(),
                          results['bill_details']['stage_name'].toString(),
                          // 'desc',
                          results['bill_details']['qr_image'],
                          results['bill_details']['pending_timer'] ?? 0,
                          results['bill_details']["qrcode_string"] ?? "",
                          results["bill_details"]["created_at"] ?? "",
                        ),
                        true,
                        0)));
          } else if (results['status'] == "error") {
            print(2);
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(
                  context, results['status'], results['message']),
            );
          } else {
            print(3);
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(
                  context, 'Error', 'Something went wrong. Please try again.'),
            );
          }
      }
      orderAmtController.text = "";
    } else if (loginStatus == 'suspended') {
      print(4);
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context,
            'Error',
            error ??
                "Your account has been suspended. Contact support for details"),
      );
    } else if (loginStatus == 'deactivated') {
      print(5);
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context,
            'Error',
            error ??
                "Your account has been deactivated. Contact support for details",buttonTxt: 'Okay'),
      );
      await _logout();
    } else if (loginStatus == 'unauthorized') {
      print(7);
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialog(
            context,
            'Error',
            error ??
                "Your account has some issues. Contact support for details"),
      );
    } else {
      print(6);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignIn()));
  }

  Widget _buildPopupDialog(BuildContext context, String title, String msg,{String buttonTxt="Retry"}) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(msg),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(buttonTxt),
        ),
      ],
    );
  }
}
