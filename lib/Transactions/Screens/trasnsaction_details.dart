import 'dart:async';

import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pay/Transactions/Providers/transaction_provider.dart';
import 'package:mobi_pay/Transactions/Providers/user_profile_provider.dart';
import 'package:mobi_pay/Transactions/models/transaction_model.dart';
import 'package:mobi_pay/config.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/config/glodal_methods.dart';
import 'package:mobi_pay/config/project_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:qr_flutter/qr_flutter.dart';
import '../../Auth/Screens/sign_in.dart';

class TransactionDetails extends StatefulWidget {
  TransactionModel transactionModel;
  bool isLive;
  int pending_time;
  TransactionDetails(this.transactionModel, this.isLive, this.pending_time,
      {Key? key})
      : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  final _mRefController = TextEditingController();
  // late CountdownTimerController controller;
  final GlobalMethods _globalMethods = GlobalMethods();
  Timer? _timer;

  _fetchLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _userId = sharedPreferences.getInt("user_id").toString();
    var _token = sharedPreferences.getString("token").toString();

    final userProvider =
    Provider.of<UserProfileProvider>(context, listen: false);
    userProvider.fetchData(_token, _userId);
    await userProvider.fetchData(_token, _userId);
    if (userProvider.loginStatus == 'suspended') {
    } else if (userProvider.loginStatus != 'success') {
      await _logout();
      return;
    }
    if (widget.transactionModel.status_id == '1') {
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
        setState(() {});
      });
    }
  }

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchLogin();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Colors.white,
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
            title: Text(
              widget.transactionModel.billcode,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color(primary_text),
                  fontSize: app_tittle,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 30, right: 20, left: 20, bottom: 10),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        fontSize: sub_title,
                                        color: Color(subtitle_grey),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Amount',
                                    style: TextStyle(
                                        fontSize: sub_title,
                                        color: Color(subtitle_grey),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Transaction ID',
                                    style: TextStyle(
                                        fontSize: sub_title,
                                        color: Color(subtitle_grey),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Timestamp',
                                    style: TextStyle(
                                        fontSize: sub_title,
                                        color: Color(subtitle_grey),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Merchant Reference',
                                    style: TextStyle(
                                        fontSize: sub_title,
                                        color: Color(subtitle_grey),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.48,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: _getStatusWidget()),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'RM ' +
                                          widget.transactionModel.amount
                                              .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: sub_title,
                                          color: Color(primary_text),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.transactionModel.billcode,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: sub_title,
                                          color: Color(primary_text),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.transactionModel.date +
                                          ', ' +
                                          widget.transactionModel.time,
                                      style: const TextStyle(
                                          fontSize: sub_title,
                                          color: Color(primary_text),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    widget.transactionModel.mReference == "null"
                                        ? GestureDetector(
                                      onTap: () {
                                        if (widget.transactionModel
                                            .mReference ==
                                            "null") {
                                          _mRefController.text = "";
                                        } else {
                                          _mRefController.text = widget
                                              .transactionModel
                                              .mReference;
                                        }

                                        _changeMRefDialog();
                                      },
                                      child: widget.transactionModel
                                          .mReference ==
                                          'null'
                                          ? Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: const [
                                          HeroIcon(
                                            HeroIcons.plusCircle,
                                            solid: false,
                                            size: 14,
                                            color: Color(
                                                primary_color),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Add',
                                            style: TextStyle(
                                                fontSize: sub_title,
                                                color: Color(
                                                    primary_color),
                                                fontWeight:
                                                FontWeight
                                                    .w700),
                                          ),
                                        ],
                                      )
                                          : Row(
                                        children: [
                                          const HeroIcon(
                                            HeroIcons.pencil,
                                            solid: true,
                                            size: 14,
                                            color: Color(
                                                primary_color),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.transactionModel
                                                .mReference,
                                            style: const TextStyle(
                                                fontSize: sub_title,
                                                color: Color(
                                                    primary_color),
                                                fontWeight:
                                                FontWeight
                                                    .w700),
                                          ),
                                        ],
                                      ),
                                    )
                                        : Text(
                                      widget.transactionModel.mReference,
                                      style: const TextStyle(
                                          fontSize: sub_title,
                                          color: Color(primary_color),
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: spacing_large,
                  ),
                  widget.isLive
                      ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(grey_bg_deep),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        HeroIcon(
                          HeroIcons.informationCircle,
                          solid: true,
                          color: Color(grey_bg_deep_text),
                        ),
                        SizedBox(width: spacing_extra_small),
                        Expanded(
                          child: Text(
                            "This page will be automatically refreshed once the payment is received.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color(grey_bg_deep_text),
                                fontSize: small_text),
                          ),
                        )
                      ],
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          height: 166,
          child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: widget.transactionModel.status_id == '1'
                  ? Column(
                children: [
                  SizedBox(
                    height: button_height,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: const BorderSide(
                            width: 2.0,
                            color: Color(primary_color),
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        onPressed: () async {
                          SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                          var userid =
                          sharedPreferences.getInt("user_id");
                          String token = sharedPreferences
                              .getString("token")
                              .toString();
                          setState(() {
                            widget.transactionModel.status_code =
                            'Cancelled';
                          });
                          Fluttertoast.showToast(
                              msg: 'Order cancelled.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              fontSize: sub_title);
                          await _cancelTxn(
                              widget.transactionModel.billcode);
                          // Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel Order",
                          style: TextStyle(
                              fontSize: button_text,
                              fontWeight: FontWeight.w700,
                              color: Color(primary_color)),
                        )),
                  ),
                  const SizedBox(
                    height: spacing_small,
                  ),
                  SizedBox(
                    height: button_height,
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            )),
                        onPressed: () {
                          _QRCodePopup(widget.transactionModel);
                        },
                        child: Image.asset('assets/images/qr-code.png',
                            fit: BoxFit.cover)),
                  ),
                ],
              )
                  : Container())),
    );
  }

  _QRCodePopup(TransactionModel txn) {
    final qrString = "${QrString.prefix}${txn.billcode}";

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
                            'Show this QR Code to the customer for payment ',
                            style: TextStyle(
                                fontSize: sub_title,
                                fontWeight: FontWeight.w600,
                                color: Color(regular_text)),
                          ),
                          const SizedBox(
                            height: spacing_small,
                          ),
                          QrImage(
                            data: qrString,
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

  Widget _buildPopupDialog(BuildContext context, String title, String msg,
      String bText, Function func) {
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
            func();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(bText),
        ),
      ],
    );
  }

  Color _getStatusBgColor(String status) {
    return const Color(success_text);
  }

  Color _getStatusTextColor(String status) {
    return const Color(primary_color);
  }

  _changeMRefDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text(
              'Edit Merchant Reference',
              style: TextStyle(
                  fontSize: small_title,
                  color: Color(primary_text),
                  fontWeight: FontWeight.w600),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _mRefController,
                      maxLength: 50,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        labelText: 'Merchant Reference',
                        labelStyle: TextStyle(color: Color(regular_text)),
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
                  ],
                ),
              ),
            ),
            actions: [
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Color(error_text)),
                  )),
              SizedBox(
                width: spacing_extra_small,
              ),
              RaisedButton(
                  child: Text(
                    "Update",
                    style: TextStyle(
                      color: Color(regular_text),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () async {
                    await _updateMRefFunc();
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  _updateMRefFunc() async {
    if (_mRefController.text != '') {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      var userId = sharedPreferences.getInt("user_id");
      String token = sharedPreferences.getString("token").toString();
      final response = await http.post(
        Uri.parse(
            'https://ext.dev.alpha.airapay.my/mobile/api/v1/update_reference'),
        headers: {
          "Content-Type": "application/json",
          // "ApiKey": AppConfig().apiKey,
        },
        body: JSON.jsonEncode({
          "token": token,
          "bill_id": widget.transactionModel.id,
          "user_id": userId,
          "reference": _mRefController.text
        }),
      );
      switch (response.statusCode) {
        case 200:
          var results = JSON.jsonDecode(response.body);
          if (results['status'] == "success") {
            setState(() {
              widget.transactionModel.mReference = _mRefController.text;
            });

            Fluttertoast.showToast(
                msg: 'Reference number updated successfully.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: sub_title);
          } else {
            Fluttertoast.showToast(
                msg: 'Error: ' + results['message'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
                fontSize: sub_title);
          }
          break;

        default:
          Fluttertoast.showToast(
              msg: 'Something went wrong. Please try again.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black87,
              textColor: Colors.white,
              fontSize: sub_title);
          break;
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Reference field must not be empty.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: sub_title);
    }
  }

  _getStatusWidget() {
    if (widget.transactionModel.status_code == 'Pending') {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color(0xFFEFF6FF),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Row(
              children: [
                // const HeroIcon(
                //   HeroIcons.badgeCheck,
                //   solid: true,
                //   size: 18,
                //   color: Color(success_text),
                // ),
                Text(
                  widget.transactionModel.status_code +
                      ' (' +
                      _globalMethods.timerForTxnExpire(
                          widget.transactionModel, _cancelTxn) +
                      ')',
                  style: TextStyle(
                      fontSize: sub_title,
                      color: _getStatusTextColor(
                          widget.transactionModel.status_code),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ));
    } else if (widget.transactionModel.status_code == 'Cancelled' ||
        widget.transactionModel.status_code == 'Rejected' ||
        widget.transactionModel.status_code == 'Failed') {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color(rose_bg),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Row(
              children: [
                const HeroIcon(
                  HeroIcons.ban,
                  solid: true,
                  size: 16,
                  color: Color(week),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  widget.transactionModel.status_code,
                  style: const TextStyle(
                      fontSize: sub_title,
                      color: Color(week),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ));
    } else if (widget.transactionModel.status_code == 'Successful' ||
        widget.transactionModel.status_code == 'Completed' ||
        widget.transactionModel.status_code == 'Success 1st Payment' ||
        widget.transactionModel.status_code == 'Paid') {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color(grey_bg_deep),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Row(
              children: [
                const HeroIcon(
                  HeroIcons.badgeCheck,
                  color: Color(primary_color),
                  size: 16,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  widget.transactionModel.status_code,
                  style: const TextStyle(
                      fontSize: sub_title,
                      color: Color(primary_color),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ));
    }
  }

  _getBatchColorCode(String value) {
    if (value == 'Pending' || value == '7') {
      return const Color(error_text);
    } else {
      return const Color(success_text);
    }
  }

  _cancelTxn(String billCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userid = sharedPreferences.getInt("user_id");
    String token = sharedPreferences.getString("token").toString();
    await Provider.of<TransactionProvider>(context, listen: false)
        .cancelTransaction(
        widget.transactionModel.billcode,
        token,
        userid.toString(),
        Provider.of<UserProfileProvider>(context, listen: false)
            .mId
            .toString(),
        '');
    Navigator.pop(context);
  }
}
