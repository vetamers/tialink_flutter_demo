import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tialink/features/bluetooth/presentation/widgets/setup_find_device.dart';
import 'package:tialink/features/bluetooth/presentation/widgets/setup_select_role.dart';
import 'package:tialink/features/main/domain/usecases/main_usecase.dart';
import 'package:tialink/features/permission/presentation/bloc/permission_bloc.dart';
import 'package:tuple/tuple.dart';

import '../widgets/config_device_view.dart';

class DeviceSetupPage extends StatefulWidget {
  const DeviceSetupPage({Key? key}) : super(key: key);

  @override
  State<DeviceSetupPage> createState() => _DeviceSetupPageState();
}

class _DeviceSetupPageState extends State<DeviceSetupPage> {
  final rolesList = const [
    Tuple2("Master", "I'm master of home and i want to config device for my home"),
    Tuple2("Slave", "I'm slave and i want to use tialink device")
  ];
  int currentRole = 0;
  final List<Tuple2<Icon, String>> masterSteps = const [
    Tuple2(
        Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        "Select Role"),
    Tuple2(
        Icon(
          Icons.bluetooth,
          color: Colors.white,
        ),
        "Connecting to device"),
    Tuple2(
        Icon(
          Icons.settings_rounded,
          color: Colors.white,
        ),
        "Setup remotes"),
  ];
  final List<Tuple2<Icon, String>> slaveSteps = const [
    Tuple2(
        Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        "Select role"),
    Tuple2(
        Icon(
          Icons.done,
          color: Colors.white,
        ),
        "Done")
  ];
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
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
              icons: _getStepsList().map((e) => e.item1).toList(),
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
                _getStepsList()[currentStep].item2,
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: _getStep(currentStep))
        ],
      ),
    );
  }

  Widget _getStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return SelectRoleStep(
          roles: rolesList,
          onRoleChange: (value) {
            setState(() {
              currentRole = value;
            });
          },
          onDone: () {
            setState(() {
              this.currentStep++;
            });
          },
        );
      case 1:
        if (currentRole == 0) {
          return BlocProvider(
            create: (context) => PermissionBloc(),
            child: FindDeviceSetup(
              onDone: () {
                setState(() {
                  this.currentStep++;
                });
              },
            ),
          );
        } else {
          return _slaveDone();
        }
      case 2:
        if (currentRole == 0) {
          return RemoteConfigView(
            onDone: (param) {
              GetIt.I<AddHome>()(param).then((value) {
                context.read<Box>().put("isSetupPageSkipped", true).then((_) {
                  Navigator.pushReplacementNamed(context, '/');
                });
              });
            },
          );
        } else {
          throw ErrorDescription("Illegal state");
        }
      default:
        throw ErrorDescription("Illegal step");
    }
  }

  List<Tuple2<Icon, String>> _getStepsList() => currentRole == 0 ? masterSteps : slaveSteps;

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
