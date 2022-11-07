import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pay/Auth/Screens/sign_in.dart';
import 'package:mobi_pay/Transactions/Providers/transaction_provider.dart';
import 'package:mobi_pay/Transactions/Providers/user_profile_provider.dart';
import 'package:mobi_pay/Transactions/Screens/history.dart';
import 'package:mobi_pay/Transactions/Screens/trasnsaction_details.dart';
import 'package:mobi_pay/Transactions/Widgets/tabs.dart';
import 'package:mobi_pay/Transactions/models/transaction_model.dart';
import 'package:mobi_pay/config.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/config/glodal_methods.dart';
import 'package:mobi_pay/config/project_config.dart';
import 'package:mobi_pay/utils/ui_utils/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobi_pay/Transactions/global.dart' as global;

import '../../config/sync_configue_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _token = "";
  String _userId = "";
  Timer? timer;
  final GlobalMethods _globalMethods = GlobalMethods();

  fetchIsLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('status') &&
        sharedPreferences.getString("status") == "success") {
      _userId = sharedPreferences.getInt("user_id").toString();
      _token = sharedPreferences.getString("token").toString();
      final userProvider =
      Provider.of<UserProfileProvider>(context, listen: false);
      await userProvider.fetchData(_token, _userId);
      if (userProvider.loginStatus == 'suspended') {
        showSnackBar(
          context,
          Text(
            'Warning! ${userProvider.errror ?? "Your account has been suspended"}',
          ),
        );
      } else if (userProvider.loginStatus != 'success') {
        // await showDialog(
        //     context: context,
        //     builder: (_) => _buildPopupDialog(
        //         context,
        //         'Oops!',
        //         'Invalid session detected. You will now be signed out. Please sign in again to proceed.',
        //         'Okay',
        //         ));
        // if(userProvider.loginStatus=='suspended'){
        //   await showDialog(context: context, builder: (_)=>_buildPopupDialog(context, 'Oops!', userProvider.errror??"Your account has been suspended.", 'Logout', (){}));
        // }else

        if (userProvider.loginStatus == 'deactivated') {
          await showDialog(
              context: context,
              builder: (_) => _buildPopupDialog(
                  context,
                  'Oops!',
                  userProvider.errror ?? "Your account has been deactivated.",
                  'Logout',
                      () {},showDismiss: false));
        }
        await _logout();
        return;
      }
      _fetchAllBills();
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        int time = t.tick;
        if (time % 5 == 0) {
          _fetchAllBills();
        } else {
          _refreshScreen();
        }
      });

      // await Provider.of<TransactionProvider>(context, listen: false)
      //     .fetchTodayData(_userId, _token,
      //         Provider.of<UserProfileProvider>(context, listen: false).mId);
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => SignIn()));
    }
    await Provider.of<SysConfigProvider>(context, listen: false).fetchData();
    SysConfigVariables().billExpireTimeInSec = int.parse(
        Provider.of<SysConfigProvider>(context, listen: false)
            .getValue('platform.transaction.expired_duration'));
  }

  _refreshScreen() async {
    await Provider.of<TransactionProvider>(context, listen: false)
        .refreshScreen();
  }

  _fetchAllBills() async {
    await Provider.of<TransactionProvider>(context, listen: false)
        .fetchTodayData(_userId, _token,
        Provider.of<UserProfileProvider>(context, listen: false).mId);
    // setState(() {});
  }

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
    global.btmNavIndx = 0;
    _checkInternetConnection();
    fetchIsLogin();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Tabs(0),
      backgroundColor: const Color(page_color),
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color(tag_grey_bg),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 20, bottom: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 55,
                        height: 55,
                        // ignore: prefer_const_constructors
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Provider.of<UserProfileProvider>(context,
                                listen: true)
                                .photoUrl
                                .isNotEmpty
                                ? CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(
                                Provider.of<UserProfileProvider>(context,
                                    listen: true)
                                    .photoUrl,
                              ),
                              backgroundColor: Colors.white,
                            )
                                : const CircleAvatar(
                              radius: 30.0,
                              backgroundImage: AssetImage(
                                "assets/images/user_avatar.png",
                              ),
                              backgroundColor: Colors.white,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                Provider.of<UserProfileProvider>(context,
                                    listen: true)
                                    .merchantName,
                                style: const TextStyle(
                                    color: Color(primary_text),
                                    fontSize: small_title,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            // Container(
                            //     child: const Text(
                            //   'user name',
                            //   style: TextStyle(
                            //       fontSize: sub_title,
                            //       fontWeight: FontWeight.bold,
                            //       color: Color(subtitle_grey)),
                            // )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: spacing_extra_small,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Today’s Sales',
                            style: TextStyle(
                                fontSize: small_text,
                                color: Color(subtitle_grey)),
                          ),
                          Consumer<TransactionProvider>(
                              builder: (context, transactionProvider, child) {
                                return Text(
                                  'RM ' +
                                      transactionProvider.totalTodaySales
                                          .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: heading_title,
                                      color: Color(primary_text),
                                      fontWeight: FontWeight.w700),
                                );
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'No. of Transactions',
                            style: TextStyle(
                                fontSize: small_text,
                                color: Color(subtitle_grey)),
                          ),
                          Consumer<TransactionProvider>(
                              builder: (context, transactionProvider, child) {
                                return Text(
                                  transactionProvider.todayTransactions.length
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: heading_title,
                                      color: Color(primary_text),
                                      fontWeight: FontWeight.w700),
                                );
                              }),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(110.0)),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(34),
            color: const Color(container_bg),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 221, 221, 221),
                blurRadius: 4.0,
              ),
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today’s Transactions',
                    style: TextStyle(
                        fontSize: button_text,
                        color: Color(primary_text),
                        fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const History(),
                          ));
                    },
                    child: Row(
                      children: const [
                        Text(
                          'History',
                          style: TextStyle(
                              fontSize: sub_title,
                              color: Color(primary_color),
                              fontWeight: FontWeight.w700),
                        ),
                        HeroIcon(
                          HeroIcons.chevronRight,
                          solid: true,
                          size: 18,
                          color: Color(primary_color),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: spacing_small,
            ),
            Consumer<TransactionProvider>(
                builder: (context, transactionProvider, child) {
                  List<TransactionModel> transactions =
                      transactionProvider.todayTransactions;
                  return Expanded(
                    child: ListView(
                      children: List.generate(transactions.length, (index) {
                        String timerText = '';
                        if (transactions[index].status_id == '1') {
                          timerText = _globalMethods.timerForTxnExpire(
                              transactions[index], _cancelTxn);
                        }
                        return transactions[index].status_id == '1'
                            ? GestureDetector(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TransactionDetails(
                                        transactions[index],
                                        false,
                                        transactions[index].pending_timer)));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(
                                bottom: 6, left: 15, right: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(grey_bg_deep),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 221, 221, 221),
                                    blurRadius: 4.0,
                                  ),
                                ]),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transactions[index].billcode,
                                          style: const TextStyle(
                                              fontSize: sub_title,
                                              color: Color(primary_text),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          transactions[index].time,
                                          style: const TextStyle(
                                              fontSize: sub_title,
                                              color: Color(primary_text),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'RM ' +
                                                  transactions[index].amount,
                                              style: const TextStyle(
                                                  fontSize: sub_title,
                                                  color: Color(primary_color),
                                                  fontWeight:
                                                  FontWeight.w700),
                                            ),
                                            const HeroIcon(
                                              HeroIcons.chevronRight,
                                              solid: true,
                                              size: 18,
                                              color: Color(primary_color),
                                            )
                                          ],
                                        ),
                                        Text(
                                          transactions[index].status_code,
                                          style: const TextStyle(
                                              fontSize: sub_title,
                                              color: Color(primary_color),
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          timerText,
                                          style: const TextStyle(
                                              fontSize: sub_title,
                                              color: Color(primary_color),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: spacing_small,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: button_height,
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.45,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shadowColor:
                                            const Color(fusica_text)
                                                .withOpacity(0.2),
                                            primary: const Color(0xFFEFF6FF),
                                            side: const BorderSide(
                                              width: 2.0,
                                              color: Color(primary_color),
                                            ),
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(35),
                                            ),
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext
                                              context) =>
                                                  _buildPopupDialog(
                                                      context,
                                                      'Oops!',
                                                      'The customer is in the midst of making a payment. Are you sure you want to cancel this order?',
                                                      'Cancel Order',
                                                          () async {
                                                        await _cancelTxn(
                                                            transactions[index]
                                                                .billcode);
                                                        Fluttertoast.showToast(
                                                            msg: 'Order cancelled.',
                                                            toastLength:
                                                            Toast.LENGTH_SHORT,
                                                            gravity:
                                                            ToastGravity.BOTTOM,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor:
                                                            Colors.black87,
                                                            textColor: Colors.white,
                                                            fontSize: sub_title);
                                                      }),
                                            );
                                          },
                                          child: const Text(
                                            "Cancel Order",
                                            style: TextStyle(
                                                fontSize: button_text,
                                                fontWeight: FontWeight.w700,
                                                color: Color(primary_color)),
                                          )),
                                    ),
                                    SizedBox(
                                      height: button_height,
                                      width:
                                      MediaQuery.of(context).size.width *
                                          0.28,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shadowColor: Color(fusica_text)
                                                  .withOpacity(0.2),
                                              primary: Colors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(35),
                                              )),
                                          onPressed: () {
                                            _QRCodePopup(transactions[index]);
                                          },
                                          child: Image.asset(
                                              'assets/images/qr-code.png',
                                              fit: BoxFit.cover)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                            : GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TransactionDetails(
                                        transactions[index],
                                        false,
                                        transactions[index].pending_timer)));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 6, left: 10, right: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      transactions[index].billcode,
                                      style: const TextStyle(
                                          fontSize: sub_title,
                                          color: Color(primary_text),
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      transactions[index].time,
                                      style: const TextStyle(
                                          fontSize: sub_title,
                                          color: Color(primary_text),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'RM ' + transactions[index].amount,
                                          style: const TextStyle(
                                              fontSize: sub_title,
                                              color: Color(regular_text),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const HeroIcon(
                                          HeroIcons.chevronRight,
                                          solid: true,
                                          size: 18,
                                          color: Color(icon_gery),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        HeroIcon(
                                          transactions[index].status_code ==
                                              'Unsuccessful' ||
                                              transactions[index]
                                                  .status_code ==
                                                  'Cancelled'
                                              ? HeroIcons.ban
                                              : HeroIcons.badgeCheck,
                                          solid: true,
                                          size: 18,
                                          color: transactions[index]
                                              .status_code ==
                                              'Successful'
                                              ? const Color(success_text)
                                              : const Color(error_text),
                                        ),
                                        Text(
                                          transactions[index].status_code,
                                          style: TextStyle(
                                              fontSize: sub_title,
                                              color: transactions[index]
                                                  .status_code ==
                                                  'Successful'
                                                  ? const Color(success_text)
                                                  : const Color(error_text),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
            const SizedBox(
              height: spacing_extra_small,
            ),
          ],
        ),
      ),
    );
  }

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

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignIn()));
  }

  _QRCodePopup(TransactionModel txn) {
    showDialog(
      barrierColor: const Color.fromARGB(239, 0, 0, 0),
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'RM ' + txn.amount,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      txn.billcode,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: spacing_small,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Show this QR Code to the customer for payment',
                            style: TextStyle(
                                fontSize: sub_title,
                                fontWeight: FontWeight.w600,
                                color: Color(regular_text)),
                          ),
                          const SizedBox(
                            height: spacing_small,
                          ),
                          QrImage(
                            data: txn.qrcode_string,
                            size: 300,
                            embeddedImage: const AssetImage('assets/images/mobypaylogo-circle.png'),
                            // embeddedImageStyle:
                            //     QrEmbeddedImageStyle(size: Size(80, 80)),
                          ),
                          // Image.network(txn.qr_url, fit: BoxFit.cover),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: spacing_small,
                    ),
                    const SizedBox(
                      height: spacing_large,
                    ),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                              width: 2,
                              color: Colors.white,
                              style: BorderStyle.solid)),
                      child: IconButton(
                        icon: const HeroIcon(
                          HeroIcons.x,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopupDialog(
      BuildContext context,
      String title,
      String msg,
      String bText,
      Function func,
      {bool showDismiss=true}
      ) {
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
        if(showDismiss==true)
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Dismiss'),
          ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            func();
          },
          textColor: const Color(error_text),
          child: Text(bText),
        ),
      ],
    );
  }

  _cancelTxn(String billCode) async {
    await Provider.of<TransactionProvider>(context, listen: false)
        .cancelTransaction(
        billCode,
        _token,
        _userId,
        Provider.of<UserProfileProvider>(context, listen: false)
            .mId
            .toString(),
        "home");
  }

// String _checkTxnExpiration(TransactionModel txn) {
//   int timeDiff =
//       DateTime.now().difference(DateTime.parse(txn.createdAt)).inSeconds;
//   int billExTime = SysConfigVariables().billExpireTimeInSec;
//   if (timeDiff > billExTime && txn.status_id == '1') {
//     _cancelTxn(txn.billcode);
//     return 'Expiring...';
//   } else {
//     Duration duration = Duration(seconds: (billExTime - timeDiff));
//     int mins = duration.inMinutes;
//     int secs = duration.inSeconds % 60;
//     return mins.toString() + 'm:' + secs.toString() + 's';
//   }
// }
}
