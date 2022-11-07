import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pay/Transactions/Providers/transaction_provider.dart';
import 'package:mobi_pay/Transactions/Providers/user_profile_provider.dart';
import 'package:mobi_pay/Transactions/Screens/trasnsaction_details.dart';
import 'package:mobi_pay/Transactions/models/transaction_model.dart';
import 'package:mobi_pay/config.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Auth/Screens/sign_in.dart';

class Searchhistory extends StatefulWidget {
  const Searchhistory({Key? key}) : super(key: key);

  @override
  State<Searchhistory> createState() => _SearchhistorysState();
}

class _SearchhistorysState extends State<Searchhistory> {
  String _userId = '0';
  String _token = "";

  _fetchData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _userId = sharedPreferences.getInt("user_id").toString();
    _token = sharedPreferences.getString("token").toString();
    await Provider.of<TransactionProvider>(context, listen: false)
        .searchTransactionFunc(_userId, _token,
        Provider.of<UserProfileProvider>(context, listen: false).code);

    await Provider.of<UserProfileProvider>(context, listen: false)
        .fetchData(_token, _userId);
    if (Provider.of<UserProfileProvider>(context, listen: false).loginStatus !=
        "success") {
      _logout();
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
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(page_color),
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: const Color(page_color),
            elevation: 0,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                    padding: EdgeInsets.only(right: 20, top: 18),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: button_text,
                          color: Color(text_grey),
                          fontWeight: FontWeight.w600),
                    )),
              ),
            ],
            automaticallyImplyLeading: false,
            title: Container(
              height: button_height,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Stack(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            GestureDetector(
                              onTap: () => {},
                              // ignore: prefer_const_constructors
                              child: Icon(
                                Icons.search_outlined,
                                color: const Color(label_grey),
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            onChanged: (String value) async {
                              Provider.of<TransactionProvider>(context,
                                  listen: false)
                                  .searchKey = value;
                              await Provider.of<TransactionProvider>(context,
                                  listen: false)
                                  .searchTransactionFunc(
                                  _userId,
                                  _token,
                                  Provider.of<UserProfileProvider>(context,
                                      listen: false)
                                      .mId);
                            },
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintStyle: TextStyle(color: Color(label_grey)),
                                hintText: "Bill Code or Merchant Reference"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(children: [
        const Divider(color: Color(label_grey)),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 20),
                    child: Consumer<TransactionProvider>(
                        builder: (context, transactionProvider, child) {
                          List<TransactionModel> transactions =
                              transactionProvider.searchTransactions;
                          if (transactionProvider.searching) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (transactionProvider.searchKey == '') {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, right: 20, left: 20, bottom: 10),
                              child: Column(
                                children: const [
                                  Align(
                                    child: Text(
                                      'Enter Transaction ID or Merchant Reference to search.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: button_text,
                                          color: Color(regular_text),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return transactions.isEmpty
                              ? Padding(
                            padding: const EdgeInsets.only(
                                top: 30, right: 20, left: 20, bottom: 10),
                            child: Column(
                              children: const [
                                Align(
                                  child: Text(
                                    "Oops! We couldn't find any matches for your search. Double check your entry for typos and try again.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: button_text,
                                        color: Color(regular_text),
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          )
                              : Column(
                            children: List.generate(
                              transactions.length,
                                  (index) => transactions[index].status_id == '1'
                                  ? Column(children: [
                                index > 0 &&
                                    transactions[index].date ==
                                        transactions[index - 1].date
                                    ? Container()
                                    : Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    transactions[index].date,
                                    style: const TextStyle(
                                        color:
                                        Color(subtitle_grey),
                                        fontSize: small_text,
                                        fontWeight:
                                        FontWeight.w600),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransactionDetails(
                                                    transactions[index],
                                                    false,
                                                    transactions[index]
                                                        .pending_timer)));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(
                                        bottom: 15),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        color:
                                        const Color(grey_bg_deep),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 221, 221, 221),
                                            blurRadius: 4.0,
                                          ),
                                        ]),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  transactions[index]
                                                      .billcode,
                                                  style: const TextStyle(
                                                      fontSize:
                                                      sub_title,
                                                      color: Color(
                                                          primary_text),
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
                                                ),
                                                Text(
                                                  transactions[index]
                                                      .time,
                                                  style: const TextStyle(
                                                      fontSize:
                                                      sub_title,
                                                      color: Color(
                                                          primary_text),
                                                      fontWeight:
                                                      FontWeight
                                                          .w500),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      transactions[
                                                      index]
                                                          .amount,
                                                      style: const TextStyle(
                                                          fontSize:
                                                          sub_title,
                                                          color: Color(
                                                              primary_color),
                                                          fontWeight:
                                                          FontWeight
                                                              .w700),
                                                    ),
                                                    const HeroIcon(
                                                      HeroIcons
                                                          .chevronRight,
                                                      solid: true,
                                                      size: 18,
                                                      color: Color(
                                                          primary_color),
                                                    )
                                                  ],
                                                ),
                                                const Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                      fontSize:
                                                      sub_title,
                                                      color: Color(
                                                          primary_color),
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
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
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: button_height,
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.45,
                                              child: ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    // ignore: prefer_const_constructors
                                                    primary: const Color
                                                        .fromARGB(
                                                        255,
                                                        249,
                                                        226,
                                                        255),
                                                    side:
                                                    const BorderSide(
                                                      width: 2.0,
                                                      color: Color(
                                                          primary_color),
                                                    ),
                                                    elevation: 2,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          35),
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
                                                                SharedPreferences
                                                                sharedPreferences =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                                String _token =
                                                                sharedPreferences
                                                                    .getString(
                                                                    "token")
                                                                    .toString();
                                                                var _userid =
                                                                sharedPreferences
                                                                    .getInt(
                                                                    "user_id");
                                                                await Provider.of<
                                                                    TransactionProvider>(
                                                                    context,
                                                                    listen:
                                                                    false)
                                                                    .cancelTransaction(
                                                                    transactions[index]
                                                                        .billcode,
                                                                    _token,
                                                                    _userid
                                                                        .toString(),
                                                                    Provider.of<UserProfileProvider>(context,
                                                                        listen: false)
                                                                        .mId
                                                                        .toString(),
                                                                    'search');
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                    'Order cancelled.',
                                                                    toastLength:
                                                                    Toast
                                                                        .LENGTH_SHORT,
                                                                    gravity: ToastGravity
                                                                        .BOTTOM,
                                                                    timeInSecForIosWeb:
                                                                    1,
                                                                    backgroundColor:
                                                                    Colors
                                                                        .black87,
                                                                    textColor:
                                                                    Colors
                                                                        .white,
                                                                    fontSize:
                                                                    sub_title);
                                                              }),
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Cancel Order",
                                                    style: TextStyle(
                                                        fontSize:
                                                        button_text,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700,
                                                        color: Color(
                                                            primary_color)),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: button_height,
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.28,
                                              child: ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                      primary: Colors
                                                          .white,
                                                      elevation: 2,
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            35),
                                                      )),
                                                  onPressed: () {
                                                    _QRCodePopup(
                                                        transactions[
                                                        index]);
                                                  },
                                                  child: Image.asset(
                                                      'assets/images/qr-code.png',
                                                      fit: BoxFit
                                                          .cover)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ])
                                  : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionDetails(
                                                  transactions[index],
                                                  false,
                                                  transactions[index]
                                                      .pending_timer)));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 15,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(15),
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
                                            transactions[index]
                                                .billcode,
                                            style: const TextStyle(
                                                fontSize: sub_title,
                                                color:
                                                Color(primary_text),
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          Text(
                                            transactions[index].time,
                                            style: const TextStyle(
                                                fontSize: sub_title,
                                                color:
                                                Color(primary_text),
                                                fontWeight:
                                                FontWeight.w500),
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
                                                    transactions[index]
                                                        .amount,
                                                style: const TextStyle(
                                                    fontSize: sub_title,
                                                    color: Color(
                                                        regular_text),
                                                    fontWeight:
                                                    FontWeight
                                                        .w700),
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
                                                HeroIcons.badgeCheck,
                                                solid: true,
                                                size: 18,
                                                color: transactions[
                                                index]
                                                    .status_code ==
                                                    'Cancelled'
                                                    ? const Color(
                                                    error_text)
                                                    : const Color(
                                                    success_text),
                                              ),
                                              Text(
                                                transactions[index]
                                                    .status_code,
                                                style: TextStyle(
                                                    fontSize: sub_title,
                                                    color: transactions[
                                                    index]
                                                        .status_code ==
                                                        'Cancelled'
                                                        ? const Color(
                                                        error_text)
                                                        : const Color(
                                                        success_text),
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ).toList(),
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _buildPopupDialog(
      BuildContext context,
      String title,
      String msg,
      String bText,
      Function func,
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
}
