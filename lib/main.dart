import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tialink/pages/login_page.dart';
import 'package:tialink/pages/ota_page.dart';
import 'package:tialink/pages/welcome_page.dart';

void main() async {
  await Hive.initFlutter();
  runApp(TiaLink());
}

class TiaLink extends StatefulWidget {
  const TiaLink({Key? key}) : super(key: key);

  @override
  _TiaLinkState createState() => _TiaLinkState();
}

class _TiaLinkState extends State<TiaLink> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TiaLink",
      home: FutureBuilder(
        future: Hive.openBox("app"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Scaffold(
                backgroundColor: Colors.red,
                body: Center(
                  child: Container(
                    padding: EdgeInsets.all(35),
                    child: Text(snapshot.error.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),),
                  ),
                ),
              );
            } else {
              if (Hive.box("app").get("isFirstLaunch", defaultValue: true)) {
                return WelcomePage((){
                  setState(() {});
                });
              } else {
                return LoginPage();
              }
            }
          } else {
            return Scaffold();
          }
        },
      ),
      routes: {
        "/ota": (context) => OtaVerification()
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

