import 'dart:developer';

import 'package:auth/core/network.dart';
import 'package:cool_stepper/cool_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tialink/wizard/bloc/search/search_device_bloc.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({Key? key}) : super(key: key);

  static const routeName = "wizard";

  @override
  _WizardPageState createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  String roleValue = "slave";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wizard"),
        centerTitle: true,
      ),
      body: Container(
        child: CoolStepper(onCompleted: () {}, steps: [searchingDevice()],contentPadding: EdgeInsets.all(10)),
      ),
    );
  }

  CoolStep selectRule() {
    final segmentWidgets = {
      "master": Container(
        child: Text("Master"),
        padding: EdgeInsets.all(20),
      ),
      "slave": Text("Slave")
    };

    return CoolStep(
        title: "Role",
        subtitle: "Select your role",
        content: Container(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(roleValue == "slave"
                  ? "I slave and i want to get access from master"
                  : "I master and device owner"),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.maxFinite,
                child: CupertinoSegmentedControl(
                  groupValue: roleValue,
                  children: segmentWidgets,
                  onValueChanged: (v) {
                    setState(() {
                      roleValue = v.toString();
                    });
                  },
                ),
              )
            ],
          ),
        ),
        validation: () {
          return null;
        });
  }

  CoolStep searchingDevice() {
    return CoolStep(
        title: "Finding device",
        subtitle: "Searching for device for first setup",
        content: BlocProvider(
          create: (context) => SearchDeviceBloc(),
          child: Container(child: const SearchingDeviceView(),height: MediaQuery.of(context).size.height / 2,),
        ),
        validation: null);
  }
}

class SearchingDeviceView extends StatefulWidget {
  const SearchingDeviceView({ Key? key }) : super(key: key);

  @override
  _SearchingDeviceViewState createState() => _SearchingDeviceViewState();
}

class _SearchingDeviceViewState extends State<SearchingDeviceView> with WidgetsBindingObserver {
  late var lifeCycleLastState;

  @override
  void initState() {
    context.read<SearchDeviceBloc>().add(SearchDeviceEvent(SearchDeviceEvents.checkPermission));
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchDeviceBloc, SearchDeviceState>(
      builder: (context, state) {
        switch (state.status){
          case SearchDeviceStatus.initial:
            return _progressBar();
          case SearchDeviceStatus.permissionNeeded:
            return _requestPermissionDialog();
          case SearchDeviceStatus.permissionShowRequestRationale:
            return _requestPermissionDialog();
          case SearchDeviceStatus.permissionDenied:
            return _permissionDenied();
          case SearchDeviceStatus.permissionAccept:
            return _progressBar();
          case SearchDeviceStatus.permissionPermanentlyDenied:
            return _permissionDenied(true);
        }
      },
    );
  }

  Widget _requestPermissionDialog() {
    return AlertDialog(
      title: Text("Permission Needed"),
      content: Text("We need location permission for searching your nearby bluetooth devices"),
      actions: [
        TextButton(onPressed: () {
          context.read<SearchDeviceBloc>().add(const SearchDeviceEvent(SearchDeviceEvents.showPermissionDialog));
        }, child: Text("OK"))
      ]
    );
  }

  Widget _permissionDenied([bool isPermanentlyDenied = false]) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isPermanentlyDenied
            ? "Permission denied permanently"
            : "Permission Denied"),
        backgroundColor: Theme.of(context).errorColor,
      ));
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isPermanentlyDenied ? "We need location permission to continue.\nOpen setting and give access with button blow" : "We need location permission to continue.\nGive us access with button blow",textAlign: TextAlign.center),
          const SizedBox(height: 15,),
          ElevatedButton.icon(onPressed: () => {
            isPermanentlyDenied ? openAppSettings() : context.read<SearchDeviceBloc>().add(SearchDeviceEvent(SearchDeviceEvents.showPermissionDialog))
          }, icon: Icon(isPermanentlyDenied ? Icons.settings : Icons.security), label: Text(isPermanentlyDenied ? "Open Setting" : "Give Permission"))
        ],
      ),
    );
  }

  Widget _progressBar(){
    return Center(child: CircularProgressIndicator());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var bloc = context.read<SearchDeviceBloc>();
    if (state == AppLifecycleState.resumed && bloc.state.status == SearchDeviceStatus.permissionPermanentlyDenied){
      bloc.add(SearchDeviceEvent(SearchDeviceEvents.showPermissionDialog));
    }
  }
}