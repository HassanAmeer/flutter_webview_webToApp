import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THTCars',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true),
      initialRoute: 'FPage',
      routes: {'FPage': (context) => const FPage()},
      home: const HomePage(),
    );
  }
}

/////////
class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {
            const Center(child: CircularProgressIndicator());
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.navigate;
            } else if (request.url.startsWith('whatsapp://')) {
              launchUrl(Uri.parse(
                  'https://api.whatsapp.com/send?phone=18322807286&text=FromApp'));
              return NavigationDecision.prevent;
            } else if (request.url.startsWith('tel:')) {
              launchUrl(Uri.parse('tel:+1 (832) 280-7286'));
              return NavigationDecision.prevent;
            } else if (request.url.startsWith('mailto:')) {
              launchUrl(Uri.parse('mailto:support@THTCars.com'));
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          }))
      ..enableZoom(true)
      ..loadRequest(Uri.parse('https://thtcars.com'));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // if (didPop) {
        // controller.canGoBack();
        debugPrint("👉goback");
        controller.goBack();
        // return;
        // }
      },
      child: Scaffold(
        // appBar: AppBar(title: Text('THTcars')),
        // extendBody: true,
        // extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton.small(
            child: ref
                ? Transform.scale(
                    scale: 0.5,
                    child: const CircularProgressIndicator(strokeWidth: 4))
                : const Icon(Icons.refresh_outlined),
            onPressed: () async {
              setState(() {
                ref = !ref;
              });
              controller.reload();
              await Future.delayed(const Duration(seconds: 2));

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
            : Transform.scale(
                scale: 1, child: WebViewWidget(controller: controller)),
      ),
    );
  }
}

class FPage extends StatefulWidget {
  const FPage({super.key});

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
    Timer(const Duration(seconds: 3), () async {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(seconds: 2),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
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
      extendBody: true,
      extendBodyBehindAppBar: true,
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
            const CircularProgressIndicator(
              strokeWidth: 2,
            )
          ]),
    );
  }
}
