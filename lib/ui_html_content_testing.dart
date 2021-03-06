//foundation & gestures are required by WebView's gestureRecognizers
//import 'package:flutter/foundation.dart';
//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:webview_flutter_plus/webview_flutter_plus.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class TestFlutterHTML extends StatelessWidget {
  String htmlContent = r"""
           <p>
           <img src="asset:assets/images/AppIcon.png">
           </p>
           <h1>Testing - a dictionary entry</h1><h1 class="window"><ref onclick='searchEntry("AMT", "Abomination")'>Abomination</ref></h1>
           <div class="topic">
           <p><b>Abomination</b> — </p><p><center>...</center></p>
           <p>A term applied in Scripture to objects of great detestation. Idols and their worship were so named, because they robbed God of his honor, while the rites themselves were impure and cruel, 
           <ref onclick="cr(50,7,25)">Deut 7:25-26</ref>, <ref onclick="cr(50,12,31)">12:31</ref>. 
           The term was used respecting the Hebrews in Egypt, <ref onclick="cr(10,43,32)">Gen 43:32</ref> 
           <ref onclick="cr(20,8,26)">Exod 8:26</ref>, either because they ate and sacrificed animals held sacred by the Egyptians, or because they did not observe those ceremonies in eating which made a part of the religion of Egypt; and in 
           <ref onclick="cr(10,46,34)">Gen 46:34</ref>, because they were "wandering shepherds," a race of whom had grievously oppressed Egypt.</p></div>
      """;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _getHTML(htmlContent, context),
    );
  }

  Widget _getHTML(String content, BuildContext context) {
    final List<List<String>> searchReplace = [
      ["</ref>", "</a>"],
      ["<ref ", "<a "],
      ["onclick=", "href="],
    ];
    for (List<String> i in searchReplace) {
      content = content.replaceAll(i.first, i.last);
    }

    return Html(
      data: content,
      //Optional parameters:
      //backgroundColor: Colors.white70,
      onLinkTap: (url) {
        print(url);
        // open url in a webview
      },
      style: {
        "html": Style(
          backgroundColor: Colors.black12,
//              color: Colors.white,
        ),
//            "h1": Style(
//              textAlign: TextAlign.center,
//            ),
        "table": Style(
          backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
        ),
        "tr": Style(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        "th": Style(
          padding: EdgeInsets.all(6),
          backgroundColor: Colors.grey,
        ),
        "td": Style(
          padding: EdgeInsets.all(6),
        ),
        "var": Style(fontFamily: 'serif'),
      },
      onImageTap: (src) {
        print(src);
        // Display the image in large form.
      },
      onImageError: (object, stackTrace) {
        print("errors loading image");
      },
    );
  }
}

/*
// Test result: does not work with html String
class TestWebView extends StatelessWidget {
  WebViewController _webViewController1;

  @override
  Widget build(BuildContext context) {
    return getWebView();
  }

  Widget getWebView() {
    return GestureDetector(
        onTap: () {
          print("tap");
        },
        child: WebView(
          initialUrl: 'https://marvel.bible/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController1 = webViewController;
          },
          gestureRecognizers: Set()
            ..addAll({
              Factory<VerticalDragGestureRecognizer>(
                      () => VerticalDragGestureRecognizer()
              ..onUpdate = (dragUpdateDetails) {
                     print(dragUpdateDetails.primaryDelta);
                     print(dragUpdateDetails.delta);
                     print(dragUpdateDetails.globalPosition);
                     print(dragUpdateDetails.localPosition);
              }
              ),
              Factory<TapGestureRecognizer>(() => TapGestureRecognizer()
              ..onTap = () {
                print("b");
              }),
              Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer()),
            }),
        ),
    );
  }
}*/

// Test result: assets css and gestureRecognizers doen't work with loadString
/*class TestWebViewPlus extends StatelessWidget {

  WebViewPlusController _webViewPlusController;

  String htmlString = r"""
           <html lang="en">
           <head>
           <link rel='stylesheet' type='text/css' href='assets/default.css'>
           <script src='default.js'></script>
           </head>
            <body><red>hello world</red>
            <p>hello world
            <red>hello world</red>
            <red>hello world</red>
            <red>hello world</red>
            <red>hello world</red>
            <red>hello world</red>
            <red>hello world</red>
            <red>hello world</red></p>
            </body>
           </html>
      """;

  @override
  Widget build(BuildContext context) {
    return WebViewPlus(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _webViewPlusController = controller;
        controller.loadUrl('assets/index.html');
      },
      onPageFinished: (url) {
        _webViewPlusController.loadString(htmlString);
      },
      gestureRecognizers: Set()
        ..addAll({
          Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()
                ..onUpdate = (dragUpdateDetails) {
                  print(dragUpdateDetails.primaryDelta);
                  print(dragUpdateDetails.delta);
                  print(dragUpdateDetails.globalPosition);
                  print(dragUpdateDetails.localPosition);
                }
          ),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()
            ..onTap = () {
              print("b");
            }),
          Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer()),
        }),
    );
  }

}*/

// doesn't work properly, gestureRecognizers doesn't work inside a page
/*class TestInAppWebView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return getInAppWebView();
  }

  Widget getInAppWebView() {
    return InAppWebView(
      initialUrl: 'https://marvel.bible',
      gestureRecognizers: Set()
        ..addAll({
          Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer()
                ..onUpdate = (dragUpdateDetails) {
                  print(dragUpdateDetails.primaryDelta);
                  print(dragUpdateDetails.delta);
                  print(dragUpdateDetails.globalPosition);
                  print(dragUpdateDetails.localPosition);
                }
          ),
          Factory<TapGestureRecognizer>(() => TapGestureRecognizer()
            ..onTap = () {
              print("b");
            }),
          Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer()),
        }),
    );
  }

}
*/