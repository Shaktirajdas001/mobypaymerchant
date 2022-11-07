import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/config.dart';
import 'package:mobi_pay/viewModel/PasswordVM.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  var mobilenumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMobileNumber();
  }

  _getMobileNumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var number = sharedPreferences.getString(
      "mobilenumber",
    );
    setState(() {
      mobilenumber = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(page_color),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Form(
            key: formGlobalKey,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: const HeroIcon(
                        HeroIcons.arrowNarrowLeft,
                        color: Color(primary_color),
                      )),
                ),
                const SizedBox(
                  height: 70,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Mobile Number",
                    style: TextStyle(
                        color: Color(text_grey), fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '+60${mobilenumber}',
                      style: const TextStyle(
                          color: Color(black_text),
                          fontWeight: FontWeight.w700,
                          fontSize: heading_title),
                    )),
                const SizedBox(
                  height: spacing_extra_small,
                ),
                Consumer<ResetPasswordVM>(builder: (context, password, child) {
                  return TextFormField(
                    onChanged: (value) {
                      password.onType(value);
                    },
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'plese enter Password';
                      } else if (value.isNotEmpty) {
                        bool mobileValid = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                            .hasMatch(value);

                        return mobileValid ? null : "Invalid password";
                      }
                      return null;
                    },
                    obscureText: true,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                    decoration: const InputDecoration(
                      labelText: "Enter Password",
                      hintText: "Enter Password",
                      floatingLabelStyle: TextStyle(
                          color: Color(black_text),
                          fontWeight: FontWeight.w600),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(border), width: 1.2),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(primary_color), width: 1.2),
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
                     
                    },
                    child: const Text(
                      "Forgot your password",
                      style: TextStyle(
                          color: Color(primary_color),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: spacing_large,
                ),
                Consumer<ResetPasswordVM>(builder: (context, password, child) {
                  String passwordvalue = password.password;
                  return SizedBox(
                    height: button_height,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // ignore: prefer_const_constructors
                          primary: Color(primary_color),

                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        onPressed: passwordvalue.length > 0
                            ? () {
                               
                              }
                            : null,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              fontSize: button_text,
                              fontWeight: FontWeight.w600),
                        )),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
