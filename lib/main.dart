import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tialink/core/bloc_observer.dart';
import 'package:tialink/features/auth/presentation/bloc/phone_auth_bloc.dart';
import 'package:tialink/features/auth/presentation/pages/auth_page.dart';
import 'package:tialink/features/auth/presentation/pages/phone_verification_page.dart';
import 'package:tialink/features/bluetooth/presentation/pages/bluetooth_device_setup_page.dart';
import 'package:tialink/features/welcome/presentation/page/welcome_page.dart';
import 'package:tialink/injection_container.dart';

import 'features/bluetooth/presentation/bloc/bluetooth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjector();

  BlocOverrides.runZoned(() => runApp(const TiaLinkApp()), blocObserver: Observer());
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

    return BlocProvider(
      create: (context) => GetIt.I<BluetoothBloc>(),
      child: MaterialApp(
        title: "Tialink",
        color: Colors.blue,
        debugShowCheckedModeBanner: false,
        initialRoute: _getInitialRoute(box),
        routes: {
          "/": (context) => Text("main"),
          "welcome": (_) => Provider(
                create: (_) => box,
                child: WelcomePage(),
              ),
          "auth": (_) => Provider(
                create: (_) => box,
                child: const AuthPage(),
              ),
          "auth/phoneVerification": (_) => BlocProvider(
                create: (_) => GetIt.I<PhoneAuthBloc>(),
                child: const PhoneVerificationPage(),
              ),
          "setup": (context) => const DeviceSetupPage()
        },
      ),
    );
  }

  String _getInitialRoute(Box box) {
    if (box.get("isFirstLaunch", defaultValue: true)) {
      return "welcome";
    } else if (!box.get("isUserLogin", defaultValue: false)) {
      return "auth";
    } else if (!box.get("isSetupPage", defaultValue: false)) {
      return "setup";
    } else {
      return "/";
    }
  }
}
