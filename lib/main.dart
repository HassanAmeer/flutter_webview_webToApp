import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DUYOU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      initialRoute: 'FPage',
      routes: {'FPage': (context) => FPage()},
      home: HomePage(),
    );
  }
}

/////////
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool ref = false;

  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://duyou.co/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DUYOU'),
      ),
      floatingActionButton: FloatingActionButton(
          child: ref
              ? CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : Icon(Icons.refresh_outlined),
          onPressed: () async {
            setState(() {
              ref = !ref;
            });

            await Future.delayed(Duration(seconds: 2));

            setState(() {
              ref = !ref;
            });
          }),
      body: ref
          ? Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4 / 1,
                  child: Image.asset('assets/logo.png')),
            )
          : WebViewWidget(controller: controller),
    );
  }
}

class FPage extends StatefulWidget {
  FPage({super.key});

  @override
  State<FPage> createState() => _FPageState();
}

class _FPageState extends State<FPage> {
  @override
  void initState() {
    super.initState();
    onlineSpan();
  }

  onlineSpan() async {
    Timer(Duration(seconds: 3), () async {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2),
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8 / 1,
                  child: Image.asset('assets/logo.png')),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.25 / 1),
            CircularProgressIndicator(
              strokeWidth: 2,
            )
          ]),
    );
  }
}
