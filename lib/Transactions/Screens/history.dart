import 'package:flutter_countdown_timer/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_pay/Transactions/Providers/transaction_provider.dart';
import 'package:mobi_pay/Transactions/Screens/search.dart';
import 'package:mobi_pay/Transactions/Screens/trasnsaction_details.dart';
import 'package:mobi_pay/Transactions/models/transaction_model.dart';
import 'package:mobi_pay/config.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/config/glodal_methods.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import '../../Auth/Screens/sign_in.dart';
import '../Providers/user_profile_provider.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistorysState();
}

late CountdownTimerController controller;

class _HistorysState extends State<History> {
  String _userId = '0';
  String _token = "";
  // bool _isAsc = true;
  String _startDate = "";
  String _endDate = "";
  // String _startDateTemp = "Start Date";
  // String _endDateTemp = "End Date";
  final GlobalMethods _globalMethods = GlobalMethods();

  void onEnd() {}
  _fetchData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _userId = sharedPreferences.getInt("user_id").toString();
    // var status = sharedPreferences.getString("status");
    _token = sharedPreferences.getString("token").toString();
    final userProvider =
    Provider.of<UserProfileProvider>(context, listen: false);
    userProvider.fetchData(_token, _userId);
    await userProvider.fetchData(_token, _userId);
    if (userProvider.loginStatus == 'suspended') {
    } else if (userProvider.loginStatus != 'success') {
      await _logout();
      return;
    }
    await Provider.of<TransactionProvider>(context, listen: false).fetchData(
        _userId,
        _token,
        Provider.of<UserProfileProvider>(context, listen: false).code);
  }

  _logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignIn()));
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: const Color(0xFFF8FAFC),
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Searchhistory(),
                        ));
                  },
                  icon: HeroIcon(
                    HeroIcons.search,
                    color: Color(primary_color),
                  ),
                ),
              ),
            ],
            title: Text(
              'History',
              style: TextStyle(
                  color: Color(primary_text),
                  fontSize: app_tittle,
                  fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ),

      body: Column(children: [
        const Divider(color: Color(label_grey)),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: FlatButton(
                    onPressed: () {
                      _openFilterModal();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<TransactionProvider>(
                            builder: (context, transactionProvider, child) {
                              String labelText = "";
                              if (transactionProvider.sortByPeriodic != '') {
                                switch (transactionProvider.sortByPeriodic) {
                                  case 'today':
                                    labelText = "Today";
                                    break;
                                  case 'yesterday':
                                    labelText = "Yesterday";
                                    break;
                                  case 'thisweek':
                                    labelText = "This Week";
                                    break;
                                  case 'last7days':
                                    labelText = "Last 7 Days";
                                    break;
                                  case 'last30days':
                                    labelText = "Last 30 Days";
                                    break;
                                  case 'last90days':
                                    labelText = "Last 90 Days";
                                    break;
                                  default:
                                    labelText = "Filter";
                                }
                              } else {
                                labelText = transactionProvider.startDateTemp +
                                    ' - ' +
                                    transactionProvider.endDateTemp;
                              }
                              return Text(
                                labelText,
                                style: const TextStyle(
                                    color: Color(primary_text),
                                    fontSize: sub_title,
                                    fontWeight: FontWeight.w700),
                              );
                            }),
                        const HeroIcon(
                          HeroIcons.chevronDown,
                          size: 18,
                          solid: true,
                          color: Colors.black,
                        )
                      ],
                    )),
              ),
              // const Padding(
              //   padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
              //   child: VerticalDivider(
              //     color: Color(week),
              //     thickness: 1.2,
              //   ),
              // ),
              Container(
                child: FlatButton(
                    onPressed: () {
                      _openSortingModal();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Sort By',
                          style: TextStyle(
                              color: Color(primary_text),
                              fontSize: sub_title,
                              fontWeight: FontWeight.w700),
                        ),
                        HeroIcon(
                          HeroIcons.chevronDown,
                          size: 18,
                          solid: true,
                          color: Colors.black,
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
        const Divider(color: Color(label_grey)),
        // SingleChildScrollView(
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
                              transactionProvider.transactions;
                          if (transactionProvider.historyApiStatus == 'fetching') {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return transactions.isEmpty
                              ? Container(
                            child: const Text("Record not found."),
                          )
                              : Column(
                            children:
                            List.generate(transactions.length, (index) {
                              String timerText = '';
                              if (transactions[index].status_id == '1') {
                                timerText = _globalMethods.timerForTxnExpire(
                                    transactions[index], _cancelTxn);
                              }
                              return Column(children: [
                                index > 0 &&
                                    transactions[index].date ==
                                        transactions[index - 1].date
                                    ? Container()
                                    : Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, left: 3, bottom: 8),
                                    child: Text(
                                      transactions[index].date,
                                      style: const TextStyle(
                                          color: Color(subtitle_grey),
                                          fontSize: small_text,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                transactions[index].status_id == '1'
                                    ? GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TransactionDetails(
                                                  transactions[index],
                                                  false,
                                                  transactions[index]
                                                      .pending_timer),
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        color: Color(grey_bg_deep),
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
                                                      'RM ' +
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
                                                Text(
                                                  '(' + timerText + ')',
                                                  style: const TextStyle(
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
                                                    primary: const Color(0xFFEFF6FF),
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
                                                                await _cancelTxn(
                                                                    transactions[
                                                                    index]
                                                                        .billcode);

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
                                )
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
                                      bottom: 6,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
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
                                                  color: Color(
                                                      primary_text),
                                                  fontWeight:
                                                  FontWeight.w600),
                                            ),
                                            Text(
                                              transactions[index].time,
                                              style: const TextStyle(
                                                  fontSize: sub_title,
                                                  color: Color(
                                                      primary_text),
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
                                                      transactions[
                                                      index]
                                                          .amount,
                                                  style: const TextStyle(
                                                      fontSize:
                                                      sub_title,
                                                      color: Color(
                                                          regular_text),
                                                      fontWeight:
                                                      FontWeight
                                                          .w700),
                                                ),
                                                const HeroIcon(
                                                  HeroIcons
                                                      .chevronRight,
                                                  solid: true,
                                                  size: 18,
                                                  color:
                                                  Color(icon_gery),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                HeroIcon(
                                                  transactions[index]
                                                      .status_code ==
                                                      'Unsuccessful' ||
                                                      transactions[
                                                      index]
                                                          .status_code ==
                                                          'Cancelled'
                                                      ? HeroIcons.ban
                                                      : HeroIcons
                                                      .badgeCheck,
                                                  solid: true,
                                                  size: 18,
                                                  color: transactions[index]
                                                      .status_code ==
                                                      'Unsuccessful' ||
                                                      transactions[
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
                                                      fontSize:
                                                      sub_title,
                                                      color: transactions[index]
                                                          .status_code ==
                                                          'Unsuccessful' ||
                                                          transactions[index]
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
                              ]);
                            }).toList(),
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ),
      ]),
    );
  }

  _QRCodePopup(TransactionModel txn) {
    showDialog(
      barrierColor: Color.fromARGB(239, 0, 0, 0),
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
                      padding: EdgeInsets.all(20),
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
                          SizedBox(
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
                    // Container(
                    //   padding: EdgeInsets.only(left: 20, right: 20),
                    //   child: SizedBox(
                    //     height: button_height,
                    //     width: 280,
                    //     child: ElevatedButton(
                    //         style: ElevatedButton.styleFrom(
                    //           primary: Color.fromARGB(0, 0, 0, 0),
                    //           side: BorderSide(
                    //             width: 2.0,
                    //             color: Colors.white,
                    //           ),
                    //           elevation: 2,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(35),
                    //           ),
                    //         ),
                    //         onPressed: () {
                    //           // Navigator.push(context,
                    //           //     MaterialPageRoute(builder: (context) => Password()));
                    //         },
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Image.asset('assets/images/scan.png',
                    //                 fit: BoxFit.cover),
                    //             SizedBox(
                    //               width: spacing_extra_small,
                    //             ),
                    //             Text(
                    //               "Scan Customer's QR Code",
                    //               style: TextStyle(
                    //                   fontSize: button_text,
                    //                   fontWeight: FontWeight.w700,
                    //                   color: Colors.white),
                    //             ),
                    //           ],
                    //         )),
                    //   ),
                    // ),
                    SizedBox(
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

  _sortByFunc(String order) async {
    Provider.of<TransactionProvider>(context, listen: false).sortBy = order;

    String mId = Provider.of<UserProfileProvider>(context, listen: false)
        .code
        .toString();
    await Provider.of<TransactionProvider>(context, listen: false)
        .fetchData(_userId, _token, mId);
  }

  _openSortingModal() {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sort By',
                      style: TextStyle(
                          fontSize: small_title,
                          color: Color(primary_text),
                          fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const HeroIcon(
                        HeroIcons.x,
                        size: 20,
                        solid: true,
                        color: Color(primary_color),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: spacing_small,
                ),
                Consumer<TransactionProvider>(
                    builder: (context, transactionProvider, child) {
                      return Wrap(children: [
                        GestureDetector(
                          onTap: () {
                            _sortByFunc('asc');
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: transactionProvider.sortBy == "asc"
                                    ? Color(grey_bg_deep)
                                    : Color(page_color),
                                // border: Border.all(
                                //     color: Color(border),
                                //     width: 0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 12),
                                child: Text(
                                  'Oldest to Latest',
                                  style: TextStyle(
                                      fontSize: button_text,
                                      color: transactionProvider.sortBy == "asc"
                                          ? Color(primary_color)
                                          : Color(subtitle_grey),
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            _sortByFunc('desc');
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: transactionProvider.sortBy == "desc"
                                    ? Color(grey_bg_deep)
                                    : Color(page_color),
                                // border: Border.all(
                                //     color: Color(border),
                                //     width: 0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 12),
                                child: Text(
                                  'Latest to Oldest',
                                  style: TextStyle(
                                      fontSize: button_text,
                                      color:
                                      transactionProvider.sortBy == "desc"
                                          ? Color(primary_color)
                                          : Color(subtitle_grey),
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                      ]);
                    }),
              ],
            ),
          ),
        ));
  }

  _sortByPeriodicFunc(String period) async {
    Provider.of<TransactionProvider>(context, listen: false).sortByPeriodic =
        period;
    Provider.of<TransactionProvider>(context, listen: false).setDates("", "");
    String mId = Provider.of<UserProfileProvider>(context, listen: false)
        .code
        .toString();
    await Provider.of<TransactionProvider>(context, listen: false)
        .fetchData(_userId, _token, mId);
  }

  void _onDateSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    _startDate = DateFormat('yyyy-MM-dd').format(args.value.startDate);
    _endDate = DateFormat('yyyy-MM-dd')
        .format(args.value.endDate ?? args.value.startDate);
    Provider.of<TransactionProvider>(context, listen: false).setTempDates(
        DateFormat('dd MMM yyyy').format(args.value.startDate),
        DateFormat('dd MMM yyyy')
            .format(args.value.endDate ?? args.value.startDate));
  }

  _openFilterModal() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaction Period',
                    style: TextStyle(
                        fontSize: small_title,
                        color: Color(primary_text),
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const HeroIcon(
                      HeroIcons.x,
                      size: 20,
                      solid: true,
                      color: Color(primary_color),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: spacing_medium,
              ),
              Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
                    return Wrap(children: [
                      GestureDetector(
                        onTap: () {
                          _sortByPeriodicFunc('today');
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: transactionProvider.sortByPeriodic == "today"
                                  ? Color(grey_bg_deep)
                                  : const Color(page_color),
                              // border: Border.all(
                              //     color: Color(border),
                              //     width: 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 12),
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    fontSize: button_text,
                                    color: transactionProvider.sortByPeriodic ==
                                        "today"
                                        ? const Color(primary_color)
                                        : const Color(subtitle_grey),
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _sortByPeriodicFunc('yesterday');
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color:
                              transactionProvider.sortByPeriodic == "yesterday"
                                  ? const Color(grey_bg_deep)
                                  : const Color(page_color),
                              // border: Border.all(
                              //     color: Color(border),
                              //     width: 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 12),
                              child: Text(
                                'Yesterday',
                                style: TextStyle(
                                    fontSize: button_text,
                                    color: transactionProvider.sortByPeriodic ==
                                        "yesterday"
                                        ? Color(primary_color)
                                        : Color(subtitle_grey),
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _sortByPeriodicFunc('thisweek');
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color:
                              transactionProvider.sortByPeriodic == "thisweek"
                                  ? Color(grey_bg_deep)
                                  : Color(page_color),
                              // border: Border.all(
                              //     color: Color(border),
                              //     width: 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 12),
                              child: Text(
                                'This Week',
                                style: TextStyle(
                                    fontSize: button_text,
                                    color: transactionProvider.sortByPeriodic ==
                                        "thisweek"
                                        ? Color(primary_color)
                                        : Color(subtitle_grey),
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _sortByPeriodicFunc('last7days');
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color:
                              transactionProvider.sortByPeriodic == "last7days"
                                  ? Color(grey_bg_deep)
                                  : Color(page_color),
                              // border: Border.all(
                              //     color: Color(border),
                              //     width: 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 12),
                              child: Text(
                                'Last 7 days',
                                style: TextStyle(
                                    fontSize: button_text,
                                    color: transactionProvider.sortByPeriodic ==
                                        "last7days"
                                        ? Color(primary_color)
                                        : Color(subtitle_grey),
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _sortByPeriodicFunc('last30days');
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color:
                              transactionProvider.sortByPeriodic == "last30days"
                                  ? Color(grey_bg_deep)
                                  : Color(page_color),
                              // border: Border.all(
                              //     color: Color(border),
                              //     width: 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 12),
                              child: Text(
                                'Last 30 days',
                                style: TextStyle(
                                    fontSize: button_text,
                                    color: transactionProvider.sortByPeriodic ==
                                        "last30days"
                                        ? Color(primary_color)
                                        : Color(subtitle_grey),
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          _sortByPeriodicFunc('last90days');
                        },
                        child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color:
                              transactionProvider.sortByPeriodic == "last90days"
                                  ? Color(grey_bg_deep)
                                  : Color(page_color),
                              // border: Border.all(
                              //     color: Color(border),
                              //     width: 0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 12),
                              child: Text(
                                'Last 90 days',
                                style: TextStyle(
                                    fontSize: button_text,
                                    color: transactionProvider.sortByPeriodic ==
                                        "last90days"
                                        ? Color(primary_color)
                                        : Color(subtitle_grey),
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                    ]);
                  }),
              const SizedBox(
                height: spacing_small,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Custom Date Range',
                  style: TextStyle(
                      fontSize: small_title,
                      color: Color(primary_text),
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: spacing_extra_small,
              ),
              Consumer<TransactionProvider>(
                  builder: (context, transactionProvider, child) {
                    bool temp = false;
                    if (transactionProvider.sortByPeriodic == '') {
                      temp = true;
                    }
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _dateButtonWidget(transactionProvider.startDateTemp, temp,
                                  () {
                                _openCalendarModal();
                              }),
                          const Text('-'),
                          _dateButtonWidget(transactionProvider.endDateTemp, temp,
                                  () {
                                _openCalendarModal();
                              }),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _openCalendarModal() {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.70,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: const [
                        HeroIcon(
                          HeroIcons.chevronLeft,
                          size: 18,
                          color: Color(primary_color),
                          solid: true,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: button_text,
                              color: Color(primary_color)),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const HeroIcon(
                      HeroIcons.x,
                      size: 20,
                      solid: true,
                      color: Color(primary_color),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: spacing_small,
              ),
              Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Custom Date Range',
                      style: TextStyle(
                          fontSize: small_title,
                          color: Color(primary_text),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: spacing_extra_small,
                  ),
                  Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, child) {
                        return Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _dateButtonWidget(
                                  transactionProvider.startDateTemp,
                                  true,
                                      () {}),
                              const Text('-'),
                              _dateButtonWidget(
                                  transactionProvider.endDateTemp, true, () {}),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(
                    height: spacing_small,
                  )
                ],
              ),
              SfDateRangePicker(
                onSelectionChanged: _onDateSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: button_height,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Color(fusica_text).withOpacity(0.2),
                          primary: Colors.white,
                          side: const BorderSide(
                            width: 2.0,
                            color: Color(border_color_black),
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                        onPressed: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (context) => Password()));
                        },
                        child: const Text(
                          "Reset",
                          style: TextStyle(
                              fontSize: button_text,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: button_height,
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Color(fusica_text).withOpacity(0.2),
                          primary: const Color(primary_color),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35),
                          )),
                      onPressed: () async {
                        Provider.of<TransactionProvider>(context,
                            listen: false)
                            .sortByPeriodic = '';
                        Provider.of<TransactionProvider>(context,
                            listen: false)
                            .setDates(_startDate, _endDate);
                        await Provider.of<TransactionProvider>(context,
                            listen: false)
                            .fetchData(
                            _userId,
                            _token,
                            Provider.of<UserProfileProvider>(context,
                                listen: false)
                                .code);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _dateButtonWidget(String date, bool isDisable, Function func) {
    return SizedBox(
      height: 38,
      width: MediaQuery.of(context).size.width * 0.40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shadowColor: Color(fusica_text).withOpacity(0.2),
            primary:
            isDisable ? const Color(grey_bg_deep) : const Color(page_color),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            )),
        onPressed: () {
          func();
        },
        child: Text(
          date,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDisable
                  ? const Color(primary_color)
                  : const Color(subtitle_grey),
              fontSize: sub_title),
        ),
      ),
    );
  }

  _cancelTxn(String billCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String _token = sharedPreferences.getString("token").toString();
    var _userid = sharedPreferences.getInt("user_id");
    await Provider.of<TransactionProvider>(context, listen: false)
        .cancelTransaction(
        billCode,
        _token,
        _userid.toString(),
        Provider.of<UserProfileProvider>(context, listen: false)
            .mId
            .toString(),
        'history');
  }
}
