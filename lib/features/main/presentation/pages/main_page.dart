import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tialink/core/utils.dart';
import 'package:tialink/features/bluetooth/domain/entities/bluetooth_entities.dart';
import 'package:tialink/features/bluetooth/domain/usecases/bluetooth_find_usecase.dart';
import 'package:tialink/features/bluetooth/presentation/bloc/bluetooth_bloc.dart';
import 'package:tialink/features/main/domain/usecases/main_usecase.dart';
import 'package:tialink/features/main/presentation/widgets/main_appbar.dart';

import '../../domain/entities/main_entities.dart';
import '../bloc/main_bloc.dart';

class MainPage extends StatefulWidget {
  static const String route = "/";

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<MainBloc>();

    if (bloc.state.value == MainStatus.initial) {
      bloc.add(GetHomesEvent(GetHomeParam()));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocConsumer<BluetoothBloc, BluetoothState>(
          listener: (context, state) {
            switch (state.value) {
              case BluetoothStatus.disable:
                ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                    content: const Text("Bluetooth is disable"),
                    leading: const Icon(Icons.bluetooth_disabled_rounded),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).clearMaterialBanners();
                            context
                                .read<BluetoothBloc>()
                                .add(BluetoothRequestEnableEvent());
                          },
                          child: const Text("Turn on"))
                    ]));
                break;
              case BluetoothStatus.enabled:
                context
                    .read<BluetoothBloc>()
                    .add(BluetoothFindDeviceEvent(FindDeviceParam.byName("meta")));
                break;
              case BluetoothStatus.deviceFound:
                context
                    .read<BluetoothBloc>()
                    .add(BluetoothConnectEvent(state.metadata["result"]));
                break;
              case BluetoothStatus.deviceNotFound:
                ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                    content: const Text("The device is not in range"),
                    leading: const Icon(Icons.error),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).clearMaterialBanners();
                            context.read<BluetoothBloc>().add(
                                BluetoothFindDeviceEvent(
                                    FindDeviceParam.byName("meta")));
                          },
                          child: const Text("Retry"))
                    ]));
                break;
              case BluetoothStatus.disconnected:
                ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                    content: const Text("Device was disconnected"),
                    leading: const Icon(Icons.warning),
                    actions: [
                      TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).clearMaterialBanners();
                            context.read<BluetoothBloc>().add(
                                BluetoothFindDeviceEvent(
                                    FindDeviceParam.byName("meta")));
                          },
                          child: const Text("Reconnect"))
                    ]));
                break;
            }
          },
          builder: (context, state) {
            switch (state.value) {
              case BluetoothStatus.connecting:
                return const TialinkAppBar(TialinkAppBarMode.connecting);
              case BluetoothStatus.discovering:
                return const TialinkAppBar(TialinkAppBarMode.connecting);
              default:
                return const TialinkAppBar(TialinkAppBarMode.normal);
            }
          },
        ),
      ),
      body: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.value) {
            case MainStatus.loading:
              return _progressBar();
            case MainStatus.initial:
              return _progressBar();
            case MainStatus.done:
              return _homeList(state.metadata["data"]);
            case MainStatus.error:
              return _error(state.metadata["error"]);
          }
        },
      ),
    );
  }

  Widget _homeList(List<Home> homes) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        context
            .read<MainBloc>()
            .add(GetHomesEvent(GetHomeParam(null, DataSource.remote)));
      },
      child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          homes[index].label,
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Wrap(children: [
                                      ListTile(
                                        leading: const Icon(Icons.add),
                                        title: const Text("Add Door"),
                                        onTap: () {
                                          Navigator.popAndPushNamed(context, "/add",
                                              arguments: BluetoothDeviceSetupArgs(
                                                  SetupMode.onlyDoor,
                                                  {"home": homes[index]}));
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text("Edit"),
                                        onTap: () {
                                          Navigator.popAndPushNamed(context, "/edit",
                                                  arguments: homes[index])
                                              .then((value) {
                                            if (value == true) {
                                              log("message");
                                              refreshIndicatorKey.currentState!
                                                  .show();
                                            }
                                          });
                                        },
                                      ),
                                      const ListTile(
                                        leading: Icon(Icons.security),
                                        title: Text("Permits"),
                                      ),
                                      const ListTile(
                                        leading: Icon(Icons.short_text_rounded),
                                        title: Text("Logs"),
                                      )
                                    ]);
                                  });
                            },
                            icon: const Icon(Icons.more_vert_rounded))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        height: 200,
                        child: _doorList(homes[index].doors.reversed.toList(), homes[index]))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: homes.length),
    );
  }

  Widget _doorList(List<Door> doors, Home home) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(doors[index].label),
                  SizedBox(
                      height: 150,
                      width: 150,
                      child:
                          _buttonsList(doors[index].buttonMode, home, doors[index]))
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: doors.length);
  }

  Widget _buttonsList(int mode, Home home, Door door) {
//    List<RemoteButton> _buttons = RemoteButton.values.sublist(0, mode - 1);
    return BlocBuilder<BluetoothBloc, BluetoothState>(
      builder: (context, state) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: Iterable.generate(mode, (index) {
            return IconButton(
              onPressed: state.value == BluetoothStatus.connected
                  ? () {
                      context.read<BluetoothBloc>().add(BluetoothExecuteRemoteEvent(
                          home, door, RemoteButton.values[index]));
                    }
                  : null,
              icon: Icon(indexToAlphabetIcon(index)),
              iconSize: 40,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _error(dynamic e) {
    return Text("Error: $e");
  }

  Widget _progressBar() {
    return const Center(child: CircularProgressIndicator());
  }
}
