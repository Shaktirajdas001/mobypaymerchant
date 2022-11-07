import 'package:flutter/material.dart';
import 'package:mobi_pay/Transactions/Providers/transaction_provider.dart';
import 'package:mobi_pay/Transactions/Providers/user_profile_provider.dart';
import 'package:mobi_pay/splash_screen.dart';
import 'package:mobi_pay/viewModel/PasswordVM.dart';
import 'package:mobi_pay/viewModel/SignInVm.dart';
import 'package:provider/provider.dart';

import 'config/sync_configue_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsernameVM()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => LoginPasswordVM()),
        ChangeNotifierProvider(create: (_) => ResetPasswordVM()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => SysConfigProvider()),
      ],
      child: MaterialApp(
        title: 'AiraPay Merchant',
        theme: ThemeData(
          fontFamily: "Baloo2",

          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
