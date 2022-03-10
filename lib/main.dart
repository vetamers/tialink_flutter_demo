import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tialink/data/provider/device_provider.dart';
import 'package:tialink/data/provider/home_provider.dart';
import 'package:tialink/data/repository/device_repository.dart';
import 'package:tialink/data/repository/home_repository.dart';
import 'package:tialink/ui/pages/main/main_edit_page.dart';
import 'package:tialink/ui/pages/main/main_page.dart';

import 'bloc_observer.dart';
import 'core/bluetooth/bluetooth.dart';
import 'ui/pages.dart';
import 'core/auth/auth.dart';

void main() async {
  await Hive.initFlutter();
  await Authenticator.instance.initAuthenticationPackage();
  BlocOverrides.runZoned(() => runApp(TiaLink()), blocObserver: AppBlocObserver());
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
      home: BlocProvider(
        create: (context) => BluetoothBloc(FlutterBluetoothSerial.instance),
        child: FutureBuilder(
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
                  if (Hive.box("auth").containsKey("token")) {
                    if (Hive.box("app").get("isWizardCompleted", defaultValue: false)) {
                      return MainPage();
                    } else {
                      return RepositoryProvider(
                        create: (context) => HomeRepository(),
                        child: WizardPage(
                          onDone: () {
                            setState(() {});
                          },
                        ),
                      );
                    }
                  } else {
                    return LoginPage(
                      onDone: () {
                        setState(() {});
                      },
                    );
                  }
                }
              }
            } else {
              return Text("Not implemented: ${snapshot.connectionState}");
            }
          },
        ),
      ),
      routes: {
        "/ota": (context) =>
            BlocProvider(create: (context) => PhoneVerificationBloc(), child: PhoneVerificationPage()),
        "/edit":(context) => HomeEditPage()    
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
