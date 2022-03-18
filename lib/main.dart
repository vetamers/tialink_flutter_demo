import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tialink/features/welcome/presentation/page/welcome_page.dart';
import 'package:tialink/injection_container.dart';

void main() async {
  await initInjector();

  runApp(const TiaLinkApp());
}

class TiaLinkApp extends StatefulWidget {
  const TiaLinkApp({Key? key}) : super(key: key);

  @override
  State<TiaLinkApp> createState() => _TiaLinkAppState();
}

class _TiaLinkAppState extends State<TiaLinkApp> {

  @override
  Widget build(BuildContext context) {
    var box = GetIt.I<Box>(instanceName: "app_box");

    return MaterialApp(
      title: "Tialink",
      color: Colors.blue,
      debugShowCheckedModeBanner: false,
      initialRoute: _getInitialRoute(box),
      routes: {
        "/": (context) => Text("main"),
        "welcome": (_) =>
            Provider(
              create: (_) => box,
              child: WelcomePage(),
            ),
        "auth": (_) => Text("auth")
      },

    );
  }
  
  String _getInitialRoute(Box box){
    if (box.get("isFirstLaunch",defaultValue: true)){
      return "welcome";
    }else if (!box.get("isUserLogin",defaultValue: false)){
      return "auth";
    }else if (!box.get("isSetupPage",defaultValue: false)){
      return "setup";
    }else{
      return "/";
    }
  }
}
