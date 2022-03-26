import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as plugin;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tialink/features/bluetooth/domain/usecases/bluetooth_find_usecase.dart';
import 'package:tialink/features/bluetooth/presentation/widgets/permission_view.dart';
import 'package:tialink/features/permission/presentation/bloc/permission_bloc.dart';

import '../bloc/bluetooth_bloc.dart';

class FindDeviceSetup extends StatefulWidget {
  final VoidCallback onDone;
  const FindDeviceSetup({Key? key, required this.onDone}) : super(key: key);

  @override
  State<FindDeviceSetup> createState() => _FindDeviceSetupState();
}

class _FindDeviceSetupState extends State<FindDeviceSetup> {
  @override
  Widget build(BuildContext context) {
    var permissionBloc = context.read<PermissionBloc>();

    if (permissionBloc.state == PermissionState.granted(Permission.location)) {
      return _main();
    } else {
      return BlocProvider(
        create: (context) => permissionBloc,
        child: PermissionView(
          permissionCode: Permission.location.value,
          onPermissionGranted: () {
            setState(() {});
          },
        ),
      );
    }
  }

  Widget _main() {
    return BlocConsumer<BluetoothBloc, BluetoothState>(
      listener: (context, state) {
        var bloc = context.read<BluetoothBloc>();

        switch (state.value) {
          case BluetoothStatus.enabled:
            bloc.add(BluetoothFindDeviceEvent(FindDeviceParam.byName("meta")));
            break;
          case BluetoothStatus.deviceFound:
            bloc.add(BluetoothConnectEvent(state.metadata["result"]));
            break;
          case BluetoothStatus.connected:
            widget.onDone();
            break;
          default:
        }
      },
      builder: (context, state) {
        switch (state.value) {
          case BluetoothStatus.discovering:
            return _discovering();
          case BluetoothStatus.deviceNotFound:
            return _notFound();
          case BluetoothStatus.disable:
            return _disable();
          case BluetoothStatus.connecting:
            return _connecting(state.metadata["result"]);
          default:
            return Text("Not implemented: ${state.value}");
        }
      },
    );
  }

  Widget _discovering() {
    return Center(child: Lottie.asset("assets/animations/bluetooth_scan.json", height: 200, width: 200));
  }

  Widget _notFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/not_found.json", width: 200, height: 200),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "We couldn't found your device",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text("make sure device is in power and in range"),
          TextButton.icon(
              onPressed: () {
                context.read<BluetoothBloc>().add(BluetoothFindDeviceEvent(FindDeviceParam.byName("meta")));
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Try again"))
        ],
      ),
    );
  }

  Widget _disable() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          "assets/animations/failure_error.json",
          repeat: false,
          width: 200,
          height: 200,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Bluetooth is off\nPlease enable the bluetooth first",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        TextButton(
            onPressed: () {
              context.read<BluetoothBloc>().add(BluetoothRequestEnableEvent());
            },
            child: const Text("Enable bluetooth"))
      ],
    ));
  }

  Widget _connecting(plugin.BluetoothDiscoveryResult result) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SpinKitDualRing(color: Colors.blue),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
