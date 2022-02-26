import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BluetoothSearchingLoading extends StatelessWidget {
  final bool showAnimation;
  final IconData iconData;
  final VoidCallback? onClick;

  const BluetoothSearchingLoading(
      {Key? key,
      this.onClick,
      this.showAnimation = true,
      this.iconData = Icons.bluetooth_searching_rounded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 300,
      child: Stack(
        children: [
          showAnimation ? SpinKitPulse(color: Colors.lightBlue, size: 300,) : SizedBox(),
          Align(
              alignment: Alignment.center,
              child: FloatingActionButton.large(
                onPressed: !showAnimation ? onClick : null ,
                child: Icon(iconData),
              ))
        ],
      ),
    );

  }
}
