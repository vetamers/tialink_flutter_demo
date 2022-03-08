import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bluetooth;
import 'package:tialink/core/bluetooth/bluetooth.dart';
import 'package:tialink/core/permission/permission.dart';
import 'package:tialink/ui/widgets.dart';

class SearchingDeviceView extends StatefulWidget {
  final VoidCallback? Function() onDone;
  const SearchingDeviceView({Key? key, required this.onDone}) : super(key: key);

  @override
  _SearchingDeviceViewState createState() => _SearchingDeviceViewState();
}

class _SearchingDeviceViewState extends State<SearchingDeviceView> {
  @override
  void initState() {
    if (context.read<BluetoothBloc>().state.value != BluetoothStatus.connected) {
      context.read<BluetoothBloc>().add(BluetoothDiscoveryEvent());
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Permission.location.isGranted,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if ((snapshot.data) as bool) {
            return BlocConsumer<BluetoothBloc, BluetoothState>(
              listener: (context, state) {
                switch (state.value) {
                  case BluetoothStatus.deviceNotFound:
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Device not found.Make sure device is on  and in range then try again"),
                      backgroundColor: Theme.of(context).errorColor,
                      duration: Duration(seconds: 6),
                      action: SnackBarAction(
                        label: "Retry",
                        onPressed: () {
                          context.read<BluetoothBloc>().add(BluetoothDiscoveryEvent());
                        },
                        textColor: Colors.white,
                      ),
                    ));
                    break;
                  case BluetoothStatus.connected:
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("We found your device."),
                      backgroundColor: Colors.green,
                    ));

                    Future.delayed(Duration(seconds: 1)).then((value) => widget.onDone());
                    break;
                    default: 
                }
              },
              builder: (context, state) {
                switch (state.value) {
                  case BluetoothStatus.discovering:
                    return _discovering();
                  case BluetoothStatus.deviceNotFound:
                    return _deviceNotFound();
                  case BluetoothStatus.deviceFound:
                    return _deviceFound((state as BluetoothStateDeviceFound).result);
                  case BluetoothStatus.connected:
                    return _deviceConnected();
                  default:
                    return Text("${state.value}");
                }
              },
            );
          } else {
            return BlocProvider<PermissionBloc>(
              create: (context) => PermissionBloc(),
              child: PermissionView(
                permissionCode: Permission.location.value,
                onPermissionGranted: () {
                  setState(() {});
                },
              ),
            );
          }
        } else {
          return _progressBar();
        }
      },
    );
  }

  Widget _progressBar() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _discovering() {
    return Center(
      child: BluetoothSearchingLoading(),
    );
  }

  Widget _deviceFound(bluetooth.BluetoothDiscoveryResult result) {
    context.read<BluetoothBloc>().add(BluetoothConnectEvent(result.device));
    log(result.rssi.toString());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDualRing(color: Colors.blue, size: 50),
          SizedBox(
            height: 25,
          ),
          Text(
            "Connecting...",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Signal:"),
              SizedBox(
                width: 10,
              ),
              SignalStrengthIndicator.bars(
                value: result.rssi,
                barCount: 4,
                levels: const {
                  -50: Colors.green,
                  -60: Colors.lightGreen,
                  -70: Colors.orange,
                  -80: Colors.red
                },
                minValue: -127,
                maxValue: -50,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _deviceNotFound() {
    return Center(
      child: BluetoothSearchingLoading(
        showAnimation: false,
        onClick: () {
          context.read<BluetoothBloc>().add(BluetoothDiscoveryEvent());
        },
        iconData: Icons.refresh_rounded,
      ),
    );
  }

  Widget _deviceConnected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          FloatingActionButton.large(
            onPressed: null,
            child: Icon(Icons.check_circle_rounded),
            backgroundColor: Colors.green,
          ),
          SizedBox(
            height: 25,
          ),
          Text("We connected to device,now you can go to next step")
        ],
      ),
    );
  }
}
