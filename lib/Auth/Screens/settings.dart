import 'package:mobi_pay/Auth/Screens/change_password.dart';
import 'package:mobi_pay/Auth/Screens/sign_in.dart';
import 'package:mobi_pay/Transactions/Providers/user_profile_provider.dart';
import 'package:mobi_pay/config.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobi_pay/Transactions/Widgets/tabs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../Transactions/Screens/InAppBrowserScreen.dart';
import '../../config/sync_configue_provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  fetchIsLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('status') &&
        sharedPreferences.getString("status") == "success") {
      // var id = sharedPreferences.getString("merchant_id");
      // var status = sharedPreferences.getString("status");
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  }

  var _packageInfo;
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info.version;
    });
  }

  @override
  void initState() {
    _initPackageInfo();
    fetchIsLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Tabs(0),
      backgroundColor: Color(0xFFF8FAFc),
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: AppBar(
            backgroundColor: Color(0xFFF8FAFc),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: const Text(
              'Settings',
              style: TextStyle(
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
            const Divider(color: Color(label_grey)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 55,
                            height: 55,
                            child:  Align(
                                alignment: Alignment.topRight,
                                child:Provider.of<UserProfileProvider>(context,
                                    listen: true)
                                    .photoUrl.isNotEmpty ? CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(
                                    Provider.of<UserProfileProvider>(context,
                                        listen: true)
                                        .photoUrl,
                                  ),
                                  backgroundColor: Colors.white,
                                ):CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: AssetImage(
                                    "assets/images/user_avatar.png",
                                  ),
                                  backgroundColor: Colors.white,
                                )
                            ),
                          ),
                          const SizedBox(
                            width: spacing_extra_small,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<UserProfileProvider>(context,
                                    listen: true)
                                    .merchantName,
                                style: const TextStyle(
                                    height: 1.2,
                                    fontSize: small_title,
                                    color: Color(primary_text),
                                    fontWeight: FontWeight.w700),
                              ),
                              // Text(
                              //   Provider.of<UserProfileProvider>(context,
                              //           listen: true)
                              //       .userName,
                              //   style: const TextStyle(
                              //       fontSize: sub_title,
                              //       color: Color(subtitle_grey),
                              //       fontWeight: FontWeight.w500),
                              // )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: spacing_medium,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 236, 236, 236),
                            blurRadius: 4.0,
                          ),
                        ]),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        const ChangePassword()));
                              },
                              child: const ListTile(
                                dense: true,
                                minLeadingWidth: 5,
                                leading: HeroIcon(
                                  HeroIcons.lockClosed,
                                  solid: true,
                                  color: Color(primary_text),
                                ),
                                title: Text(
                                  'Change Password',
                                  style: TextStyle(
                                      color: Color(primary_text),
                                      fontSize: sub_title,
                                      fontWeight: FontWeight.w700),
                                ),
                                trailing: HeroIcon(HeroIcons.chevronRight,
                                    size: 18, color: Color(icon_gery)),
                              )),
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: spacing_small,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 236, 236, 236),
                            blurRadius: 4.0,
                          ),
                        ]),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: FlatButton(
                              onPressed: () {
                                _launchFaqLink();
                              },
                              child: const ListTile(
                                dense: true,
                                minLeadingWidth: 5,
                                leading: HeroIcon(
                                  HeroIcons.questionMarkCircle,
                                  solid: true,
                                  color: Color(primary_text),
                                ),
                                title: Text(
                                  'FAQ',
                                  style: TextStyle(
                                    fontSize: sub_title,
                                    fontWeight: FontWeight.w700,
                                    color: Color(primary_text),
                                  ),
                                ),
                                trailing: HeroIcon(HeroIcons.chevronRight,
                                    size: 18, color: Color(icon_gery)),
                              )),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: FlatButton(
                              onPressed: () {
                                _launchWhatsApp();
                              },
                              child: const ListTile(
                                dense: true,
                                minLeadingWidth: 5,
                                leading: HeroIcon(
                                  HeroIcons.chatAlt2,
                                  solid: true,
                                  color: Color(primary_text),
                                ),
                                title: Text(
                                  'Contact Us',
                                  style: TextStyle(
                                    fontSize: sub_title,
                                    fontWeight: FontWeight.w700,
                                    color: Color(primary_text),
                                  ),
                                ),
                                trailing: HeroIcon(HeroIcons.chevronRight,
                                    size: 18, color: Color(icon_gery)),
                              )),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: FlatButton(
                              onPressed: () {
                                _logout();
                              },
                              child: const ListTile(
                                dense: true,
                                minLeadingWidth: 5,
                                leading: HeroIcon(
                                  HeroIcons.logout,
                                  solid: true,
                                  color: Color(week),
                                ),
                                title: Text(
                                  'Sign Out',
                                  style: TextStyle(
                                      color: Color(week),
                                      fontSize: sub_title,
                                      fontWeight: FontWeight.w700),
                                ),
                                trailing: HeroIcon(HeroIcons.chevronRight,
                                    size: 18, color: Color(icon_gery)),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Text(_packageInfo),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    // Navigator.of(context).removeRoute();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => const SignIn()));
  }

  _launchWhatsApp() async {
    var url = Provider.of<SysConfigProvider>(context, listen: false)
        .contact_url
        .toString();

    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // } else {
    //   throw 'Could not launch $url';
    // }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InAppBrowserScreen(url, 'merchant')),
    );
  }

  _launchFaqLink() async {
    var url = Provider.of<SysConfigProvider>(context, listen: false)
        .faq_url
        .toString();
    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
    // } else {
    //   throw 'Could not launch $url';
    // }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InAppBrowserScreen(url, 'merchant')),
    );
  }
}
