import 'dart:io';

import 'package:popover/popover.dart';
import 'package:flutter/material.dart';
import 'package:task_4/models/user_model.dart';
import 'package:task_4/services/get_users.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: readJson(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? MediaQuery.of(context).size.width <= 720
                      ? Column(
                          children: [
                            AppBar(
                              backgroundColor: Colors.grey[300],
                              title: const Text(
                                'Adaptive App',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              centerTitle: true,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                          context: this.context,
                                          builder: (BuildContext context) =>
                                              PopupItem(),
                                        );
                                      },
                                      child: Card(
                                        child: ListTile(
                                          title: Text(
                                              '${snapshot.data![index].firstName} ${snapshot.data![index].lastName}'),
                                          subtitle: Text(
                                              snapshot.data![index].email!),
                                          leading: CircleAvatar(
                                            child: Image.network(
                                                snapshot.data![index].image!),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Drawer(
                              backgroundColor: Colors.grey[300],
                              elevation: 0,
                              child: const DrawerHeader(
                                child: Text(
                                  'Adaptive App',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: GridView.builder(
                                itemCount: snapshot.data!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: PopoverItem(
                                      user: snapshot.data![index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                  : const CircularProgressIndicator();
            }));
  }
}

class PopoverItem extends StatelessWidget {
  final User user;
  const PopoverItem({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopover(
          context: context,
          transitionDuration: const Duration(milliseconds: 150),
          onPop: () => debugPrint('Popover ${user.id} was popped!'),
          direction: PopoverDirection.bottom,
          width: 300,
          height: 200,
          arrowHeight: 15,
          arrowWidth: 30,
          bodyBuilder: (context) => PopupItem(),
        );
      },
      child: Card(
        child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: Image.network(user.image!),
                ),
                Text(
                  '${user.firstName} ${user.lastName}',
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email!,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PopupItem extends StatelessWidget {
  PopupItem({super.key});

  final List<String> list = ['View Profile', 'Friends', 'Items'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: const Row(
                children: [
                  Icon(Icons.account_circle_rounded),
                  Text('View Profile')
                ],
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: const Row(
                children: [Icon(Icons.account_circle_rounded), Text('Friends')],
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () {},
              child: const Row(
                children: [Icon(Icons.account_circle_rounded), Text('Report')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
