import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bluetooth;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tialink/core/bluetooth/bluetooth.dart';

import 'config_remote_view.dart';
import 'search_device_view.dart';
import 'select_role_view.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({Key? key}) : super(key: key);

  static const routeName = "wizard";

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  Box? _box;
  final stepsName = ["Select Role", "Connecting to device", "Setup remotes"];
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BluetoothBloc(bluetooth.FlutterBluetoothSerial.instance),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Setup"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              IconStepper(
                  activeStep: currentStep,
                  icons: const [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.bluetooth,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                    ),
                  ],
                  enableNextPreviousButtons: false,
                  enableStepTapping: false,
                  activeStepColor: Colors.blue),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text("Step ${currentStep + 1}"),
                  Text(
                    stepsName[currentStep],
                    style: Theme.of(context).textTheme.headline6,
                  )
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: _box == null ? _initStorage() : Future.value(),
                  builder: (context, snapshot) {
                    return snapshot.connectionState == ConnectionState.done
                        ? _getStep()
                        : SizedBox();
                  },
                ),
              )
            ],
          ),
          floatingActionButton: Container(
            padding: EdgeInsets.only(left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                currentStep != 0
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          setState(() {
                            currentStep--;
                          });
                        },
                        label: Text("Previous"),
                        icon: Icon(Icons.navigate_before_rounded),
                      )
                    : SizedBox(),
                currentStep == 0
                    ? FloatingActionButton.extended(
                        onPressed: () {
                          switch (currentStep) {
                            case 0:
                              setState(() {
                                currentStep++;
                              });
                          }
                        },
                        icon: Icon(Icons.navigate_next_rounded),
                        label: Text("Next"))
                    : SizedBox(),
              ],
            ),
          ),
        ));
  }

  _getStep() {
    switch (currentStep) {
      case 0:
        return SelectRoleView(
          onValueChange: (value) {
            _saveStepState("role", value);
          },
          initValue: _box!.get("role"),
        );
      case 1:
        return SearchingDeviceView(
          onDone: () {
            setState(() {
              currentStep++;
            });
          },
        );
      case 2:
        return RemoteConfigView();
    }
  }

  Future<void> _initStorage() async {
    log("init storage");
    _box = await Hive.openBox("setup");
    return Future.value();

    // currentStep = _box!.length;
    // setState(() {});
  }

  _saveStepState(String key, dynamic state) async {
    log("$key - $state");
    _box!.put(key, state.toString());
  }
}
