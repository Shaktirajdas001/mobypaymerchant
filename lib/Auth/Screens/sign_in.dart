import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/Auth/Screens/reset_password.dart';
import 'package:mobi_pay/Transactions/Providers/transaction_provider.dart';
import 'package:mobi_pay/Transactions/Providers/user_profile_provider.dart';
import 'package:mobi_pay/Transactions/Screens/home.dart';
import 'package:mobi_pay/config.dart';
import 'package:mobi_pay/config/project_config.dart';
import 'package:mobi_pay/viewModel/SignInVm.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool _isHidden = true;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      Fluttertoast.showToast(
          msg:
          'Service currently unavailable.  Please check your internet connection or try again later.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: sub_title);
    }
  }

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(page_color),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Form(
          key: formGlobalKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: Text(
                    "Merchant Sign In",
                    style: TextStyle(
                        fontSize: app_tittle,
                        fontWeight: FontWeight.w700,
                        color: Color(primary_text)),
                  ),
                ),
                const SizedBox(
                  height: spacing_large,
                ),
                const SizedBox(
                  height: spacing_large,
                ),
                Consumer<UsernameVM>(builder: (context, MobileData, child) {
                  return TextFormField(
                    onChanged: (value) {
                      MobileData.onType(value);
                    },
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your username';
                      }
                      return null;
                    },
                    style: const TextStyle(
                        color: Color(primary_text),
                        fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Enter your username",
                      hintStyle: TextStyle(
                          color: Color(placeholder_text),
                          fontWeight: FontWeight.w600,
                          fontSize: sub_title),
                      floatingLabelStyle: TextStyle(
                          color: Color(regular_text),
                          fontWeight: FontWeight.w600),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(input_border),
                            width: input_border_width),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(primary_color),
                            width: input_border_width),
                      ),
                    ),
                  );
                }),
                const SizedBox(
                  height: spacing_medium,
                ),
                Consumer<LoginPasswordVM>(
                    builder: (context, MobileData, child) {
                      return TextFormField(
                        onChanged: (value) {
                          MobileData.onType(value);
                        },
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your Password';
                          }
                          return null;
                        },
                        style: const TextStyle(
                            color: Color(primary_text),
                            fontWeight: FontWeight.w700),
                        obscureText: _isHidden,
                        decoration: InputDecoration(
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                _isHidden = !_isHidden;
                              });
                            },
                            child: HeroIcon(
                              _isHidden ? HeroIcons.eye : HeroIcons.eyeOff,
                              solid: true,
                              size: 18,
                            ),
                          ),
                          labelText: "Password",
                          hintText: "Enter your Password",
                          hintStyle: const TextStyle(
                              color: Color(placeholder_text),
                              fontWeight: FontWeight.w600,
                              fontSize: sub_title),
                          floatingLabelStyle: const TextStyle(
                              color: Color(regular_text),
                              fontWeight: FontWeight.w600),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(input_border),
                                width: input_border_width),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(primary_color),
                                width: input_border_width),
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: spacing_small,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ConfirmOtp(),
                      //     ));
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassword()));
                      },
                      child: const Text(
                        "Forgot your password?",
                        style: TextStyle(
                            color: Color(primary_color),
                            fontWeight: FontWeight.w700,
                            fontSize: sub_title),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: spacing_extra_large,
                ),
                Consumer2<LoginPasswordVM, UsernameVM>(
                    builder: (context, login_password, userName, child) {
                      String User_name = userName.username;
                      String Login_password = login_password.password;

                      return SizedBox(
                        height: button_height,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: _isLoading == false
                                ? const Color(primary_color)
                                : const Color(0xFF2563EB),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                          ),
                          onPressed:
                          Login_password.isNotEmpty && User_name.isNotEmpty
                              ? () {
                            setState(() {
                              _isLoading = true;
                            });
                            // if (formGlobalKey.currentState!.validate()) {
                            _login(User_name, Login_password);
                            // }
                          }
                              : null,
                          child: _isLoading == false
                              ? const Text("Next",
                              style: TextStyle(
                                fontSize: button_text,
                                fontWeight: FontWeight.w600,
                              ))
                              : const Text(
                            "Loading ...",
                            style: TextStyle(
                              fontSize: button_text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiLinks().loginApi),
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.jsonEncode({
        "email": username,
        "password": password,
        "mobile_app_key": ProjectConfig().mobileAppKey
      }),
    );

    // print('..........${response.statusCode}');
    // Clipboard.setData(ClipboardData(text: response.body));

    switch (response.statusCode) {
      case 200:
        SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
        var results = JSON.jsonDecode(response.body);
        if (results['status'] == "success") {
          bool userDeactivated = results['user_details'] != null &&
              results['user_details']['is_deactivated'] != null &&
              results['user_details']['is_deactivated'] == 1;

          bool userSuspended = results['user_details'] != null &&
              results['user_details']['is_suspended'] != null &&
              results['user_details']['is_suspended'] == 1;

          if (userDeactivated) {
            Fluttertoast.showToast(
                msg: "Your account has been deactivated. Please contact support for more details.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: sub_title);
          }
          // else if(userSuspended){
          //   Fluttertoast.showToast(
          //       msg: "Your account has been suspended. Contact the support",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.BOTTOM,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.black87,
          //       textColor: Colors.white,
          //       fontSize: sub_title);
          // }
          else {
            Fluttertoast.showToast(
                msg: 'Successfully logged in.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: sub_title);
            sharedPreferences.setString("status", "success");
            sharedPreferences.setInt("user_id", results['user_details']['id']);
            sharedPreferences.setString("token", results['token']);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));

            // Checks the user is valid
            await Provider.of<UserProfileProvider>(context, listen: false)
                .fetchData(
                results['token'], results['user_details']['id'].toString());

            // Fetching today orders
            await Provider.of<TransactionProvider>(context, listen: false)
                .fetchData(
                results['user_details']['id'],
                results['token'],
                Provider.of<UserProfileProvider>(context, listen: false)
                    .mId);

            Provider.of<UserProfileProvider>(context, listen: false)
                .loginStatus = 'success';
          }
        } else if (results['status'] == "error") {
          Fluttertoast.showToast(
              msg: results['status'] + ': ' + results['message'],
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

        setState(() {
          _isLoading = false;
        });
        break;
    }
  }

  Widget _buildPopupDialog(BuildContext context, String title, String msg) {
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
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
