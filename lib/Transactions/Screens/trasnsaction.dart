// import 'package:mobi_pay/config.dart';
// import 'package:flutter/material.dart';
// import 'package:heroicons/heroicons.dart';
//
// class Transactions extends StatefulWidget {
//   const Transactions({Key? key}) : super(key: key);
//
//   @override
//   State<Transactions> createState() => _TransactionsState();
// }
//
// class _TransactionsState extends State<Transactions> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(page_color),
//       // extendBodyBehindAppBar: true,
//       resizeToAvoidBottomInset: false,
//       extendBody: true,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70.0),
//         child: Padding(
//           padding: const EdgeInsets.only(top: 20),
//           child: AppBar(
//             backgroundColor: const Color(page_color),
//             elevation: 0,
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 20, top: 10),
//                 child: GestureDetector(
//                   onTap: () {},
//                   child: const Text(
//                     'History',
//                     style: TextStyle(
//                         fontSize: sub_title,
//                         color: Color(primary_color),
//                         fontWeight: FontWeight.w700),
//                   ),
//                 ),
//               ),
//             ],
//             title: const Text(
//               'Today’s Transactions',
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
//             Divider(color: const Color(label_grey)),
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 5, right: 20, left: 20, bottom: 10),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Color(grey_bg_deep),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color.fromARGB(255, 221, 221, 221),
//                             blurRadius: 4.0,
//                           ),
//                         ]),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: const [
//                                 Text(
//                                   'AD2039484',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(primary_text),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 Text(
//                                   '5:23 PM',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(primary_text),
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Row(
//                                   children: const [
//                                     Text(
//                                       'RM 210.00',
//                                       style: TextStyle(
//                                           fontSize: sub_title,
//                                           color: Color(primary_color),
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                     HeroIcon(
//                                       HeroIcons.chevronRight,
//                                       solid: true,
//                                       size: 18,
//                                       color: Color(primary_color),
//                                     )
//                                   ],
//                                 ),
//                                 const Text(
//                                   'Pending (9m:23s)',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(primary_color),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: spacing_small,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SizedBox(
//                               height: button_height,
//                               width: MediaQuery.of(context).size.width * 0.45,
//                               child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     // ignore: prefer_const_constructors
//                                     primary: Color.fromARGB(255, 249, 226, 255),
//                                     side: const BorderSide(
//                                       width: 2.0,
//                                       color: Color(primary_color),
//                                     ),
//                                     elevation: 2,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(35),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // Navigator.push(context,
//                                     //     MaterialPageRoute(builder: (context) => Password()));
//                                   },
//                                   child: const Text(
//                                     "Cancel Order",
//                                     style: TextStyle(
//                                         fontSize: button_text,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(primary_color)),
//                                   )),
//                             ),
//                             SizedBox(
//                               height: button_height,
//                               width: MediaQuery.of(context).size.width * 0.28,
//                               child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.white,
//                                       elevation: 2,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(35),
//                                       )),
//                                   onPressed: () {},
//                                   child: Image.asset('images/qr-code.png',
//                                       fit: BoxFit.cover)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: spacing_extra_small,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: const Color(grey_bg_deep),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color.fromARGB(255, 221, 221, 221),
//                             blurRadius: 4.0,
//                           ),
//                         ]),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: const [
//                                 Text(
//                                   'AD2039484',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(primary_text),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 Text(
//                                   '5:23 PM',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(primary_text),
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 Row(
//                                   children: const [
//                                     Text(
//                                       'RM 210.00',
//                                       style: TextStyle(
//                                           fontSize: sub_title,
//                                           color: Color(primary_color),
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                     HeroIcon(
//                                       HeroIcons.chevronRight,
//                                       solid: true,
//                                       size: 18,
//                                       color: Color(primary_color),
//                                     )
//                                   ],
//                                 ),
//                                 const Text(
//                                   'Pending (9m:23s)',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(primary_color),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         const SizedBox(
//                           height: spacing_small,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SizedBox(
//                               height: button_height,
//                               width: MediaQuery.of(context).size.width * 0.45,
//                               child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     // ignore: prefer_const_constructors
//                                     primary: Color.fromARGB(255, 249, 226, 255),
//                                     side: const BorderSide(
//                                       width: 2.0,
//                                       color: Color(primary_color),
//                                     ),
//                                     elevation: 2,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(35),
//                                     ),
//                                   ),
//                                   onPressed: () {
//                                     // Navigator.push(context,
//                                     //     MaterialPageRoute(builder: (context) => Password()));
//                                   },
//                                   child: const Text(
//                                     "Cancel Order",
//                                     style: TextStyle(
//                                         fontSize: button_text,
//                                         fontWeight: FontWeight.w700,
//                                         color: Color(primary_color)),
//                                   )),
//                             ),
//                             SizedBox(
//                               height: button_height,
//                               width: MediaQuery.of(context).size.width * 0.28,
//                               child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.white,
//                                       elevation: 2,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(35),
//                                       )),
//                                   onPressed: () {},
//                                   child: Image.asset('images/qr-code.png',
//                                       fit: BoxFit.cover)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: spacing_extra_small,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.white,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: const [
//                             Text(
//                               'AD2039484',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               '5:23 PM',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: const [
//                                 Text(
//                                   'RM 210.00',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(regular_text),
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                                 HeroIcon(
//                                   HeroIcons.chevronRight,
//                                   solid: true,
//                                   size: 18,
//                                   color: Color(icon_gery),
//                                 )
//                               ],
//                             ),
//                             Row(
//                               children: const [
//                                 HeroIcon(
//                                   HeroIcons.badgeCheck,
//                                   solid: true,
//                                   size: 18,
//                                   color: Color(success_text),
//                                 ),
//                                 Text(
//                                   'Successful',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(success_text),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: spacing_extra_small,
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.white,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'AD2039484',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               '5:23 PM',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   'RM 210.00',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(regular_text),
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                                 HeroIcon(
//                                   HeroIcons.chevronRight,
//                                   solid: true,
//                                   size: 18,
//                                   color: Color(icon_gery),
//                                 )
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 HeroIcon(
//                                   HeroIcons.ban,
//                                   solid: true,
//                                   size: 18,
//                                   color: Color(week),
//                                 ),
//                                 Text(
//                                   'Unsuccessful',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(week),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: spacing_extra_small,
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.white,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'AD2039484',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               '5:23 PM',
//                               style: TextStyle(
//                                   fontSize: sub_title,
//                                   color: Color(primary_text),
//                                   fontWeight: FontWeight.w500),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   'RM 210.00',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(regular_text),
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                                 HeroIcon(
//                                   HeroIcons.chevronRight,
//                                   solid: true,
//                                   size: 18,
//                                   color: Color(icon_gery),
//                                 )
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 HeroIcon(
//                                   HeroIcons.xCircle,
//                                   solid: true,
//                                   size: 18,
//                                   color: Color(icon_gery),
//                                 ),
//                                 Text(
//                                   'Cancelled',
//                                   style: TextStyle(
//                                       fontSize: sub_title,
//                                       color: Color(text_grey),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
