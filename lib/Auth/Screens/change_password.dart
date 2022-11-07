// ignore_for_file: prefer_const_constructors

// import 'package:airapay_customer/Account/Screens/security-setting.dart';
// import 'package:airapay_customer/Account/Screens/verify-otp.dart';
// import 'package:airapay_customer/Auth/Api/service.dart';
// import 'package:airapay_customer/Auth/Screens/verify_mobile_number.dart';
// import 'package:airapay_customer/config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/Auth/Screens/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../Auth/Providers/CustomerDetailsProvider.dart';
// import '../../Auth/Screens/confirm_otp.dart';
import '../../config.dart';
import '../../config/project_config.dart';
import '../../service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _RegisterState();
}

class _RegisterState extends State<ChangePassword> {
  @override
  final _confirmPassController = TextEditingController();
  final _passwordController = TextEditingController();
  final OldpasswordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  late String _password;
  double _strength = 0;
  bool _isHidden = true;
  bool _isOldHidden = true;
  RegExp numReg =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  RegExp letterReg =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  String _displayText = '';
  var userId;
  var Token;
  bool isLoading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf8fafc),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formGlobalKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const Settings()));
                      },
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: HeroIcon(
                            HeroIcons.arrowNarrowLeft,
                            color: Color(primary_color),
                          )),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Change password',
                      style: TextStyle(
                          fontSize: heading_title,
                          fontWeight: FontWeight.bold,
                          color: Color(primary_text)),
                    ),
                  ),
                ),
                SizedBox(
                  height: spacing_small,
                ),
                TextFormField(
                  controller: OldpasswordController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                  obscureText: _isOldHidden,
                  decoration: InputDecoration(
                    labelText: 'Old password',
                    labelStyle: TextStyle(
                        color: Color(regular_text),
                        fontWeight: FontWeight.w600,
                        fontSize: sub_title),
                    hintText: 'Enter your password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(input_border),
                          width: input_border_width),
                    ),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          _isOldHidden = !_isOldHidden;
                        });
                      },
                      child: HeroIcon(
                        _isOldHidden ? HeroIcons.eye : HeroIcons.eyeOff,
                        solid: true,
                        size: 18,
                        color: Color(text_grey),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(primary_color),
                          width: input_border_width),
                    ),
                  ),
                ),
                SizedBox(
                  height: spacing_small,
                ),
                TextFormField(
                  controller: _passwordController,
                  onChanged: (value) => _checkpassword(value),
                  obscureText: _isHidden,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    labelText: 'New password',
                    labelStyle: TextStyle(
                        color: Color(regular_text),
                        fontWeight: FontWeight.w600,
                        fontSize: sub_title),
                    hintText: 'Enter your new password',
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
                        color: Color(text_grey),
                      ),
                    ),
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
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _displayText.isNotEmpty
                        ? Container(
                            width: 200,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: LinearProgressIndicator(
                                value: _strength,
                                backgroundColor: Colors.grey[300],
                                color: _strength <= 1 / 4
                                    ? Color(week)
                                    : _strength == 2 / 4
                                        ? Color(good)
                                        : _strength == 3 / 4
                                            ? Color(strong)
                                            : Color(very_strong),
                                minHeight: 10,
                              ),
                            ),
                          )
                        : Container(),
                    Text(
                      _displayText,
                      style: TextStyle(
                          color: _strength <= 1 / 4
                              ? Color(week)
                              : _strength == 2 / 4
                                  ? Color(good)
                                  : _strength == 3 / 4
                                      ? Color(strong)
                                      : Color(very_strong),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(
                  height: spacing_extra_small,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _confirmPassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'plese enter Confirm password';
                    } else if (value != _passwordController.text) {
                      return 'passwords do not match.';
                    }
                    return null;
                  },
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    labelText: 'Confirm your new password',
                    labelStyle: TextStyle(
                        color: Color(regular_text),
                        fontWeight: FontWeight.w600,
                        fontSize: sub_title),
                    hintText: 'Re-enter your password',
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
                ),
                SizedBox(
                  height: 60,
                ),
                SizedBox(
                  height: button_height,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: isLoading == false
                            ? Color(primary_color)
                            : Color(0xFF2563EB),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        )),
                    onPressed: _strength < 1 / 2
                        ? null
                        : () {
                            if (formGlobalKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              setState(() {
                                isLoading = true;
                              });
                             
                              final service = ChangePasswordApiService();

                              service.changepassword(
                                {
                                  "token": Token.toString(),
                                  "password":
                                      _passwordController.text.toString(),
                                  "old_password":
                                      OldpasswordController.text.toString(),
                                  "user_id": userId.toString()
                                },
                              ).then(
                                (value) async {
                                  setState(() {
                                    isLoading = false;
                                  });
                                 
                                  if (value.status == "success") {
                                    toastsuccess(
                                        "Woohoo! password successfully changed.");

                                   
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const Settings()));
                                  } else if (value.status == "error") {
                                    toasterror(value.message);

                                   
                                  } else {
                                    toasterror(
                                        "Something went wrong. Please try again.");
                                  }
                                },
                              );
                            }
                          },
                    child: isLoading == false
                        ? Text(
                            "Confirm",
                            style: TextStyle(
                              fontSize: button_text,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            "Loading...",
                            style: TextStyle(
                              fontSize: button_text,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkpassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = 'Enter password';
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
        _displayText = 'So Weak';
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
        _displayText = 'Pretty Good';
      });
    } else {
      if (!numReg.hasMatch(_password)) {
        setState(() {
          // password length >= 8
          // But doesn't contain both letter and digit characters
          _strength = 3 / 4;
          _displayText = 'Strong';
        });
      } else {
        // password length >= 8
        // password contains both letter and digit characters
        setState(() {
          _strength = 1;
          _displayText = 'Very Strong!';
        });
      }
    }
  }

  late FToast fToast;
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _getmobilenumber();
  }

  _getmobilenumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Token = sharedPreferences.getString(
      "token",
    );
    userId = sharedPreferences.getInt(
      "user_id",
    );
  }

  toastsuccess(data) {
    fToast.showToast(
      child: Card(
        elevation: 2.5,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color(white_color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(success_text),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: HeroIcon(
                      HeroIcons.check,
                      solid: true,
                      color: Color(white_color),
                    ),
                  )),
              SizedBox(
                width: 12.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  data,
                  style: TextStyle(
                      color: Color(primary_text),
                      fontSize: small_text,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  toasterror(data) {
    fToast.showToast(
      child: Card(
        elevation: 2.5,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Color(white_color),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(error_text),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: HeroIcon(
                      HeroIcons.x,
                      solid: true,
                      color: Color(white_color),
                    ),
                  )),
              SizedBox(
                width: 12.0,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  data,
                  style: TextStyle(
                      color: Color(primary_text),
                      fontSize: small_text,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
