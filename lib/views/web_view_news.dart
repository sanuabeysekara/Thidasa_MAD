import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news/controllers/news_controller.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewNews extends ConsumerStatefulWidget {
  final String newsUrl;
  WebViewNews({Key? key, required this.newsUrl}) : super(key: key);


  @override
  _WebViewNewsState createState() => _WebViewNewsState();


}

class _WebViewNewsState extends ConsumerState<WebViewNews> {
  //NewsController newsController = NewsController();

  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      initialUrl: widget.newsUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        setState(() {
          controller.complete(webViewController);
        });
      },
    ));
  }
}
