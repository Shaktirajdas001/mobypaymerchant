import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi_pay/config.dart';
import 'package:mobi_pay/Auth/Screens/sign_in.dart';
import 'package:mobi_pay/Transactions/Screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Transactions/Providers/user_profile_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

late String finalStatus = "null";

class _SplashScreenState extends State<SplashScreen> {
  fetchIsLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _userId = sharedPreferences.getInt("user_id").toString();
    var _token = sharedPreferences.getString("token").toString();
    await Provider.of<UserProfileProvider>(context, listen: false)
        .fetchData(_token, _userId);
    if (Provider.of<UserProfileProvider>(context, listen: false).loginStatus !=
        "success") {
      // _logout();
    }
    if (sharedPreferences.containsKey('status') &&
        sharedPreferences.getString("status") == "success") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  }

  @override
  void initState() {
    super.initState();

    getValidationData().whenComplete(() async => Timer(
      Duration(seconds: 1),
          () => fetchIsLogin(),
    ));
  }

  Future getValidationData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color(primary_color),
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SvgPicture.asset('assets/images/logo.svg',
                        semanticsLabel: 'Airapay Logo'),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'for Business',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: app_tittle),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Shop Confidently, Pay it Later",
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignIn()));
  }
}
