import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/config.dart';
import 'package:mobi_pay/config/project_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  var mobilenumber;
  bool _isLoading = false;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.only(top: appbar_text_space),
          child: AppBar(
            backgroundColor: Color(page_color),
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const HeroIcon(
                HeroIcons.arrowNarrowLeft,
                color: Color(primary_color),
              ),
            ),
            title: const Text(
              'Reset Password',
              style: TextStyle(
                  color: Color(primary_text),
                  fontSize: app_tittle,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
      backgroundColor: Color(page_color),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      "Enter your email address and a password reset link will be sent to your email.",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: sub_title,
                          color: Color(regular_text)),
                    ),
                    const SizedBox(
                      height: spacing_medium,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter Email Address';
                        }
                        return null;
                      },
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                        hintText: "Enter your email address",
                        hintStyle: TextStyle(
                          color: Color(placeholder_text),
                        ),
                        floatingLabelStyle: TextStyle(
                            color: Color(regular_text),
                            fontWeight: FontWeight.w600),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(border), width: 1.2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(primary_color), width: 1.2),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: spacing_small,
                    ),
                    const SizedBox(
                      height: spacing_large,
                    ),
                    SizedBox(
                      height: button_height,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(primary_color),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                          onPressed: () {
                            _sendPasswordResetLink();
                          },
                          child: const Text(
                            "Send Password Reset Link",
                            style: TextStyle(
                                fontSize: button_text,
                                fontWeight: FontWeight.w600),
                          )),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  _sendPasswordResetLink() async {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      final response = await http.post(
        Uri.parse(ApiLinks().forgotPasswordApi),
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.jsonEncode({
          "email": _emailController.text,
          "mobile_app_key": ProjectConfig().mobileAppKey
        }),
      );
      setState(() {
        _isLoading = false;
      });
      switch (response.statusCode) {
        case 200:
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          var results = JSON.jsonDecode(response.body);
          if (results['status'] == "success") {
            Fluttertoast.showToast(
                msg: results['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: sub_title);
            _emailController.text = '';
          } else if (results['status'] == "error") {
            Fluttertoast.showToast(
                msg: 'Error: ' + results['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: sub_title);
          } else {
            Fluttertoast.showToast(
                msg: 'Error: Something went wrong. Please try again.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: sub_title);
          }
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Please enter email address.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: sub_title);
    }
  }
}
