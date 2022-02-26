
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signal_strength_indicator/signal_strength_indicator.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bluetooth;

import '../../bluetooth/bluetooth_bloc.dart';
import '../../widgets/bluetooth_searching_loading.dart';
import '../bloc/search/search_device_bloc.dart';

class SearchingDeviceView extends StatefulWidget {
  final VoidCallback? Function() onDone;
  const SearchingDeviceView({ Key? key, required this.onDone }) : super(key: key);

  @override
  _SearchingDeviceViewState createState() => _SearchingDeviceViewState();
}

class _SearchingDeviceViewState extends State<SearchingDeviceView> with WidgetsBindingObserver {
  late WidgetsBinding? _widgetsBinding;

  @override
  void initState() {
    if (context.read<BluetoothBloc>().state.value != BluetoothStatus.connected){
      context.read<SearchDeviceBloc>().add(const SearchDeviceEvent(SearchDeviceEvents.checkPermission));
    }

    _widgetsBinding = WidgetsBinding.instance;

    _widgetsBinding?.addObserver(this);

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
            case SearchDeviceStatus.permissionNeeded:
              return _requestPermissionDialog();
            case SearchDeviceStatus.permissionShowRequestRationale:
              return _requestPermissionDialog();
            case SearchDeviceStatus.permissionDenied:
              return _permissionDenied();
            case SearchDeviceStatus.permissionAccept:
              return BlocBuilder<BluetoothBloc, BluetoothState>(
                builder: (context, state) {
                  switch (state.value){
                    case BluetoothStatus.initial:
                      return _progressBar();
                    case BluetoothStatus.discovering:
                      return _discovering();
                    case BluetoothStatus.deviceFound:
                      return _deviceFound((state as BluetoothStateDeviceFound).result);
                    case BluetoothStatus.deviceNotFound:
                      _widgetsBinding?.addPostFrameCallback((timeStamp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Device is not found please ensure device is in power and in range then try again."),
                              action: SnackBarAction(label: "Retry",onPressed: (){ context.read<BluetoothBloc>().add(BluetoothDiscoveryEvent()); },textColor: Colors.white,),
                              backgroundColor: Theme.of(context).errorColor,
                              dismissDirection: DismissDirection.none,
                              duration: Duration(seconds: 6),
                            )
                        );
                      });
                      return _deviceNotFound();
                    case BluetoothStatus.connected:
                      return _deviceConnected();
                    default: return Text("Not implemented: $state");
                  }
                },
              );
            case SearchDeviceStatus.permissionPermanentlyDenied:
              return _permissionDenied(true);
            default: return Text("Not implemented");
          }
        }
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

  Widget _discovering(){
    return Center(
      child: BluetoothSearchingLoading(),
    );
  }

  Widget _deviceFound(bluetooth.BluetoothDiscoveryResult result){
    context.read<BluetoothBloc>().add(BluetoothConnectEvent(result.device));
    log(result.rssi.toString());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitDualRing(color: Colors.blue,size: 50),
          SizedBox(height: 25,),
          Text("Connecting...",style: Theme.of(context).textTheme.headlineSmall,),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Signal:"),
              SizedBox(width: 10,),
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

  Widget _deviceNotFound(){
    return Center(
      child: BluetoothSearchingLoading(
        showAnimation: false,
        onClick: (){
          context.read<BluetoothBloc>().add(BluetoothDiscoveryEvent());
        },
        iconData: Icons.refresh_rounded,
      ),
    );
  }

  Widget _deviceConnected(){
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1)),
      builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          _widgetsBinding!.addPostFrameCallback((timeStamp) {
            widget.onDone();
          });
          return _progressBar();
        }else{
          return Center(
            child: Column(
              children: const [
                FloatingActionButton.large(onPressed: null,child: Icon(Icons.check_circle_rounded),backgroundColor: Colors.green,),
                SizedBox(height: 25,),
                Text("We connected to device,now you can go to next step")
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var bloc = context.read<SearchDeviceBloc>();
    if (state == AppLifecycleState.resumed && bloc.state.status == SearchDeviceStatus.permissionPermanentlyDenied){
      bloc.add(SearchDeviceEvent(SearchDeviceEvents.showPermissionDialog));
    }
  }
}