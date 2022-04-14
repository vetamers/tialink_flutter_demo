import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tialink/features/bluetooth/domain/entities/bluetooth_entities.dart';
import 'package:tialink/features/bluetooth/presentation/widgets/setup_find_device.dart';
import 'package:tialink/features/bluetooth/presentation/widgets/setup_select_role.dart';
import 'package:tialink/features/main/domain/entities/main_entities.dart';
import 'package:tialink/features/main/domain/usecases/main_usecase.dart';
import 'package:tialink/features/permission/presentation/bloc/permission_bloc.dart';
import 'package:tuple/tuple.dart';

import '../widgets/config_device_view.dart';

class DeviceSetupPage extends StatefulWidget {
  final BluetoothDeviceSetupArgs? args;
  const DeviceSetupPage({Key? key, this.args}) : super(key: key);

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final rolesList = const [
    Tuple2("Master", "I'm master of home and i want to config device for my home"),
    Tuple2("Slave", "I'm slave and i want to use tialink device")
  ];

  int currentRole = 0;
  final List<Tuple3<String, Icon, String>> masterSteps = const [
    Tuple3(
        "select_role",
        Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        "Select Role"),
    Tuple3(
        "connect_device",
        Icon(
          Icons.bluetooth,
          color: Colors.white,
        ),
        "Connecting to device"),
    Tuple3(
        "remotes",
        Icon(
          Icons.settings_rounded,
          color: Colors.white,
        ),
        "Setup remotes"),
  ];

  List<Tuple3<String, Icon, String>> get slaveSteps => [
        masterSteps[0],
        const Tuple3(
            "done",
            Icon(
              Icons.done,
              color: Colors.white,
            ),
            "Done")
      ];

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    var args = widget.args ??
        ModalRoute.of(context)!.settings.arguments as BluetoothDeviceSetupArgs;
    log(args.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Setup",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        children: [
          IconStepper(
              activeStep: currentStep,
              icons: _getStepsList(args.mode).map((e) => e.item2).toList(),
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              activeStepColor: Colors.blue),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Text("Step ${currentStep + 1}"),
              Text(
                _getStepsList(args.mode)[currentStep].item3,
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: _getStep(_getStepsList(args.mode)[currentStep], args))
        ],
      ),
    );
  }

  Widget _getStep(Tuple3<String, Icon, String> step, BluetoothDeviceSetupArgs args) {
    switch (step.item1) {
      case "select_role":
        return SelectRoleStep(
          roles: rolesList,
          onRoleChange: (value) {
            setState(() {
              currentRole = value;
            });
          },
          onDone: () {
            setState(() {
              currentStep++;
            });
          },
        );
      case "done":
        return _slaveDone();
      case "connect_device":
        return BlocProvider(
          create: (context) => PermissionBloc(),
          child: FindDeviceSetup(
            onDone: () {
              setState(() {
                currentStep++;
              });
            },
          ),
        );
      case "remotes":
        return RemoteConfigView(
          isDoorOnly: args.mode == SetupMode.onlyDoor,
          remoteNumber: args.metadata.containsKey("home")
              ? (args.metadata["home"] as Home).doors.length + 1
              : 1,
          onDone: (param) {
            if (args.mode == SetupMode.onlyDoor) {
              GetIt.I<AddDoor>()(AddDoorParam(
                      args.metadata["home"].uuid, param["label"], param["mode"]))
                  .then((value) {
                Navigator.pop(context, true);
              });
            } else {
              GetIt.I<AddHome>()(param as AddHomeParam).then((value) {
                context.read<Box>().put("isSetupPageSkipped", true).then((_) {
                  Navigator.pushReplacementNamed(context, '/');
                });
              });
            }
          },
        );
      default:
        throw ErrorDescription("Illegal step");
    }
  }

  List<Tuple3<String, Icon, String>> _getStepsList(SetupMode mode) {
    if (mode == SetupMode.onlyDoor) {
      return [masterSteps[1], masterSteps[2]];
    } else {
      return currentRole == 0 ? masterSteps : slaveSteps;
    }
  }

  Widget _slaveDone() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Your done.",
            style: TextStyle(fontSize: 19),
          ),
          const Expanded(child: SizedBox()),
          Align(
            alignment: Alignment.center,
            child: FloatingActionButton.extended(
              onPressed: () {
                context.read<Box>().put("isSetupPageSkipped", true).then((_) {
                  Navigator.pushReplacementNamed(context, '/');
                });
              },
              label: const Text("Finish"),
              icon: const Icon(Icons.done),
            ),
          )
        ],
      ),
    );
  }
}
