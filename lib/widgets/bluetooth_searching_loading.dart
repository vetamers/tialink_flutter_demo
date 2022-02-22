import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BluetoothSearchingLoading extends StatefulWidget {
  const BluetoothSearchingLoading({Key? key}) : super(key: key);

  @override
  _BluetoothSearchingLoadingState createState() =>
      _BluetoothSearchingLoadingState();
}

class _BluetoothSearchingLoadingState extends State<BluetoothSearchingLoading> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 300,
      child: Stack(
        children: const [
          SpinKitPulse(
            color: Colors.lightBlue,
            size: 300,
          ),
          Align(
              alignment: Alignment.center,
              child: FloatingActionButton.large(
                onPressed: null,
                child: Icon(Icons.bluetooth_rounded),
              ))
        ],
      ),
    );
  }
}
