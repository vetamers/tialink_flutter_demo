import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart' as plugin;
import '../../../permission/presentation/bloc/permission_bloc.dart';

class PermissionView extends StatefulWidget {
  final int permissionCode;
  final VoidCallback? onPermissionGranted;

  const PermissionView({required this.permissionCode, this.onPermissionGranted, Key? key}) : super(key: key);

  @override
  _PermissionViewState createState() => _PermissionViewState();
}

class _PermissionViewState extends State<PermissionView> with WidgetsBindingObserver {
  WidgetsBinding? _widgetsBinding;

  @override
  void initState() {
    _widgetsBinding = WidgetsBinding.instance;
    _widgetsBinding!.addObserver(this);

    var bloc = context.read<PermissionBloc>();
    if (bloc.state.value == PermissionStatus.initial) {
      bloc.add(PermissionCheckEvent(plugin.Permission.byValue(widget.permissionCode)));
    }

    super.initState();
  }

  @override
  void dispose() {
    _widgetsBinding?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionBloc, PermissionState>(
      listener: (context, state) {
        switch (state.value) {
          case PermissionStatus.granted:
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Permission granted"),
              backgroundColor: Colors.green,
            ));
            widget.onPermissionGranted?.call();
            break;
          case PermissionStatus.denied:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Permission denied"),
              backgroundColor: Theme.of(context).errorColor,
            ));
            break;
          case PermissionStatus.permanentlyDenied:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Permission permanently denied"),
              backgroundColor: Theme.of(context).errorColor,
            ));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.value.toString())));
        }
      },
      builder: (context, state) {
        switch (state.value) {
          case PermissionStatus.initial:
            return _permissionRequestUI();
          case PermissionStatus.denied:
            return _permissionDenied(isPermanentlyDenied: false);
          case PermissionStatus.permanentlyDenied:
            return _permissionDenied(isPermanentlyDenied: true);
          case PermissionStatus.shouldShowRequestRationale:
            return _permissionRequestUI();
          default:
            return Text("not implemented: ${state.value}");
        }
      },
    );
  }

  Widget _permissionRequestUI() {
    return AlertDialog(
        title: const Text("Permission Needed"),
        content: const Text("We need location permission for searching your nearby bluetooth devices"),
        actions: [
          TextButton(
              onPressed: () {
                context
                    .read<PermissionBloc>()
                    .add(PermissionRequestEvent(plugin.Permission.byValue(widget.permissionCode)));
              },
              child: const Text("OK"))
        ]);
  }

  Widget _permissionDenied({bool isPermanentlyDenied = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              isPermanentlyDenied
                  ? "We need location permission to continue.\nOpen setting and give access with button blow"
                  : "We need location permission to continue.\nGive us access with button blow",
              textAlign: TextAlign.center),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton.icon(
              onPressed: () => {
                    isPermanentlyDenied
                        ? plugin.openAppSettings()
                        : context
                            .read<PermissionBloc>()
                            .add(PermissionRequestEvent(plugin.Permission.byValue(widget.permissionCode)))
                  },
              icon: Icon(isPermanentlyDenied ? Icons.settings : Icons.security),
              label: Text(isPermanentlyDenied ? "Open Setting" : "Give Permission"))
        ],
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var bloc = context.read<PermissionBloc>();
    if (state == AppLifecycleState.resumed && bloc.state.value == PermissionStatus.permanentlyDenied) {
      bloc.add(PermissionRequestEvent(plugin.Permission.byValue(widget.permissionCode)));
    }
  }
}
