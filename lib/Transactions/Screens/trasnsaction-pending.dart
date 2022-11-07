// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//
// import 'package:mobi_pay/config.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:heroicons/heroicons.dart';
// import 'package:mobi_pay/Transactions/Widgets/tabs.dart';
//
// class Transactionpending extends StatefulWidget {
//   const Transactionpending({Key? key}) : super(key: key);
//
//   @override
//   State<Transactionpending> createState() => _TransactionpendingsState();
// }
//
// class _TransactionpendingsState extends State<Transactionpending> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       // extendBodyBehindAppBar: true,
//       resizeToAvoidBottomInset: false,
//       extendBody: true,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.0),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: HeroIcon(
//                 HeroIcons.arrowNarrowLeft,
//                 color: Color(primary_color),
//               ),
//             ),
//             title: Text(
//               'AD2039484',
//               style: TextStyle(
//                   color: Color(primary_text),
//                   fontSize: app_tittle,
//                   fontWeight: FontWeight.w800),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Divider(color: Color(label_grey)),
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 30, right: 20, left: 20, bottom: 10),
//               child: Column(
//                 children: [
//                   Container(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Status',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(subtitle_grey),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'Amount',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(subtitle_grey),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'Transaction ID',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(subtitle_grey),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'Timestamp',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(subtitle_grey),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'Merchant Reference',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(subtitle_grey),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(3),
//                                   child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(3),
//                                         color: Color(grey_bg_deep),
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 3),
//                                         child: Text(
//                                           'Pending (9m:23s)',
//                                           style: TextStyle(
//                                               fontSize: sub_title,
//                                               color: Color(primary_color),
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'RM 210.00',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               'AD100098',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               '7 Mar 2022, 5:12 PM',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               children: [
//                                 HeroIcon(
//                                   HeroIcons.plusCircle,
//                                   size: 14,
//                                   color: Color(primary_color),
//                                 ),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text(
//                                   'Add',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(primary_color),
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: spacing_large,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Color(grey_bg_deep),
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         HeroIcon(
//                           HeroIcons.informationCircle,
//                           solid: true,
//                           color: Color(grey_bg_deep_text),
//                         ),
//                         SizedBox(width: spacing_extra_small),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 "This page will be automatically refreshed once the payment is received.",
//                                 textAlign: TextAlign.left,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(grey_bg_deep_text),
//                                     fontSize: small_text),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 100,
//                   ),
//                   SizedBox(
//                     height: button_height,
//                     width: double.infinity,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           // ignore: prefer_const_constructors
//                           primary: Colors.white,
//                           side: BorderSide(
//                             width: 2.0,
//                             color: Color(primary_color),
//                           ),
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(35),
//                           ),
//                         ),
//                         onPressed: () {
//                           // Navigator.push(context,
//                           //     MaterialPageRoute(builder: (context) => Password()));
//                         },
//                         child: Text(
//                           "Cancel Order",
//                           style: TextStyle(
//                               fontSize: button_text,
//                               fontWeight: FontWeight.w700,
//                               color: Color(primary_color)),
//                         )),
//                   ),
//                   SizedBox(
//                     height: spacing_small,
//                   ),
//                   SizedBox(
//                     height: button_height,
//                     width: double.infinity,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.white,
//                             elevation: 2,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(35),
//                             )),
//                         onPressed: () {},
//                         child: Image.asset('assets/images/qr-code.png',
//                             fit: BoxFit.cover)),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
