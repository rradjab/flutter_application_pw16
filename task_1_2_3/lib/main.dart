import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_universal/webview_universal.dart';
import 'package:flutter_application_pw16/services/web_loader.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final linkController = TextEditingController();
  WebViewController webViewController = WebViewController();
  late TabController _tabController;
  String currentPlatform = '';
  bool b = true;

  Future<void> _task() async {
    await webViewController.init(
      context: context,
      setState: setState,
      uri: Uri.parse(linkController.text),
    );
    // Wait for the WebView to be fully loaded
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    currentPlatform = kIsWeb ? 'web' : Platform.operatingSystem;
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  scrollDirection: Axis.vertical,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      pinned: true,
                      bottom: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(child: Text('Html View')),
                          Tab(child: Text('Web View')),
                        ],
                      ),
                    ),
                  ],
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      FutureBuilder(
                          future: loadHTML(linkController.text),
                          builder: (context, snapshot) {
                            return snapshot.connectionState !=
                                    ConnectionState.done
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Column(
                                    children: [
                                      Text(
                                        snapshot.data!.htmlTitle,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25.0),
                                      ),
                                      Text(
                                        snapshot.data!.corsHeader,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.red),
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: SelectableText(
                                                  snapshot.data!.htmlBody))),
                                    ],
                                  );
                          }),
                      WebView(
                        controller: webViewController
                          ..goSync(uri: Uri.parse(linkController.text)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              height: 40,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: linkController,
                              decoration:
                                  const InputDecoration.collapsed(hintText: ''),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              //data = await loadHTML(linkController.text);

                              webViewController.go(
                                  uri: Uri.parse(linkController.text));
                              webViewController.goSync(
                                  uri: Uri.parse(linkController.text));
                              if (b) {
                                _task();
                                b = false;
                              } else if (webViewController.is_desktop) {
                                _task();
                              }
                              setState(() {});
                            },
                            child: const Text('GO'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Application running on: $currentPlatform',
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
