import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config.dart';
import '../../config/project_config.dart';

class InAppBrowserScreen extends StatefulWidget {
  var onlineUrl;
  String pageName;
  InAppBrowserScreen(this.onlineUrl, this.pageName, {Key? key})
      : super(key: key);

  @override
  State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
  late InAppWebViewController _webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  String url = "";
  double progress = 0;
  String _title = "Loading..";
  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                await _webViewController.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
        },
        onHideContextMenu: () {
          
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
         
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController.reload();
        } else if (Platform.isIOS) {
          _webViewController.loadUrl(
              urlRequest: URLRequest(url: await _webViewController.getUrl()));
        }
      },
    );
  }

  final GlobalKey webViewKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: AppBar(
                backgroundColor: Color(page_color),
                elevation: 0,
                leading:
                    widget.pageName == 'payment' || widget.pageName == 'addCard'
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const HeroIcon(
                              HeroIcons.arrowNarrowLeft,
                              color: Color(primary_color),
                            ),
                          ),
                title: Text(
                  _title,
                  style: const TextStyle(
                      color: Color(primary_text),
                      fontSize: app_tittle,
                      fontWeight: FontWeight.w800),
                ),
                actions: [
                  widget.pageName == 'payment' || widget.pageName == 'addCard'
                      ? Container()
                      : IconButton(
                          onPressed: () {
                            _webViewController.reload();
                          },
                          icon: const HeroIcon(
                            HeroIcons.refresh,
                            color: Color(primary_color),
                          ),
                        )
                ]),
          ),
        ),
        // drawer: myDrawer(context: context),
        body: SafeArea(
            child: Column(children: <Widget>[
          Container(
              // padding: EdgeInsets.all(10.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(
                      value: progress, color: Color(primary_color))
                  : Container()),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  // contextMenu: contextMenu,
                  initialUrlRequest:
                      URLRequest(url: Uri.parse(widget.onlineUrl)),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialOptions: options,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    _webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      // urlController.text = this.url;
                    });
                  },
                  androidOnPermissionRequest:
                      (controller, origin, resources) async {
                    return PermissionRequestResponse(
                        resources: resources,
                        action: PermissionRequestResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(Uri.parse(url))) {
                        // Launch the App
                        await launchUrl(
                          Uri.parse(url),
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController.endRefreshing();
                    
                    setState(() {
                      this.url = url.toString();
                      _title = "MobyPay – Buy Now Pay Later";
                    });
                  },
                  onLoadError: (controller, url, code, message) {
                    pullToRefreshController.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      // urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                     
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                   
                  },
                ),
                
              ],
            ),
          ),
         
        ])));
  }
}
