import 'package:mobi_pay/Auth/Screens/settings.dart';
import 'package:mobi_pay/Bills/Screens/generate_bill.dart';
import 'package:mobi_pay/Transactions/Screens/home.dart';
import 'package:flutter/material.dart';
import 'Enums.dart';

// void showHideSearchBar() {
//   global.searchBar ? global.searchBar = false : global.searchBar = true;
// }

void moveToPage(NavigateToPage page, pageContext) {
  switch (page) {
    case NavigateToPage.home:
      Navigator.of(pageContext).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const Home(),
        ),
        (Route<dynamic> route) => false,
      );
      break;
    case NavigateToPage.category:
      Navigator.of(pageContext).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const GenerateBill(),
        ),
        (Route<dynamic> route) => false,
      );
      break;
    case NavigateToPage.me:
      Navigator.of(pageContext).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const Settings(),
        ),
        (Route<dynamic> route) => false,
      );
      break;

    default:
  }
}
