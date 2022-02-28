import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tialink/auth/phone/phone_verification_bloc.dart';
import 'package:tialink/bloc_observer.dart';
import 'package:tialink/pages/login_page.dart';
import 'package:tialink/pages/ota_page.dart';
import 'package:tialink/pages/welcome_page.dart';
import 'package:tialink/wizard/view/wizard_page.dart';

void main() async {
  await Hive.initFlutter();
  Authenticator.instance.initAuthenticationPackage();
  BlocOverrides.runZoned(() => runApp(TiaLink()),
      blocObserver: AppBlocObserver());
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
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              );
            } else {
              if (Hive.box("app").get("isFirstLaunch", defaultValue: true)) {
                return WelcomePage(() {
                  setState(() {});
                });
              } else {
                if (Hive.box("auth").containsKey("token")){
                  return WizardPage();
                }else{
                  return LoginPage();
                }
              }
            }
          } else {
            return Text("Not implemented: ${snapshot.connectionState}");
          }
        },
      ),
      routes: {
        "/ota": (context) => BlocProvider(
            create: (context) => PhoneVerificationBloc(),
            child: OtaVerification(() {
              setState(() {});
            },)),
        WizardPage.routeName: (context) => WizardPage()
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
