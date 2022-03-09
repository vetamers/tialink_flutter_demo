import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:im_stepper/stepper.dart';

import 'package:tialink/core/bluetooth/bluetooth.dart';
import 'package:tialink/core/utils.dart';
import 'package:tialink/data/repository/home_repository.dart';

class RemoteConfigView extends StatefulWidget {
  final VoidCallback onDone;
  const RemoteConfigView({Key? key, required this.onDone}) : super(key: key);

  @override
  _RemoteConfigViewState createState() => _RemoteConfigViewState();
}

class _RemoteConfigViewState extends State<RemoteConfigView> {
  @override
  Widget build(BuildContext context) {
    HomeRepository _homeRepository =
        RepositoryProvider.of<HomeRepository>(context);

    return BlocConsumer<BluetoothBloc, BluetoothState>(
      buildWhen: (previous, current) =>
          current.value != BluetoothStatus.dataReceived,
      builder: (context, state) {
        switch (state.value) {
          case BluetoothStatus.connected:
            return _selectConfig();
          case BluetoothStatus.waitingForData:
            return _waitingForButton(state.metadata);
          case BluetoothStatus.operationDone:
            return const Center(child: CircularProgressIndicator());
          default:
            return Text(state.value.toString());
        }
      },
      listener: (context, state) {
        switch (state.value) {
          case BluetoothStatus.dataReceived:
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("OK, Device receive remote signal and save it."),
              backgroundColor: Colors.green,
            ));
            break;
          case BluetoothStatus.operationDone:
            _homeRepository
                .quickAdd(
                    homeLabel: "Default",
                    doorLabel: "Default",
                    deviceMacAddress: state.metadata["address"],
                    deviceSecret: state.metadata["secret"],
                    buttonMode: state.metadata["button_mode"])
                .then((value) {
              if (value.isSuccessful) {
                widget.onDone();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(value.message!),
                  duration: Duration(minutes: 5),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              }
            }).onError((error, stackTrace) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(error.toString()),
                duration: Duration(minutes: 5),
                backgroundColor: Theme.of(context).errorColor,
              ));
            });
            break;
          default:
        }
      },
    );
  }

  Widget _getRemoteImage(int number) {
    return GestureDetector(
      onTap: () {
        context.read<BluetoothBloc>().add(BluetoothNewRemoteEvent(number, 1));
      },
      child: SvgPicture.asset(
        "assets/svg/remote_$number.svg",
        width: 150,
        allowDrawingOutsideViewBox: true,
      ),
    );
  }

  Widget _selectConfig() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      child: Column(
        children: [
          Text(
            "Select the type of your remote controller:",
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getRemoteImage(1),
                const SizedBox(
                  width: 10,
                ),
                _getRemoteImage(2)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "1 buttons",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "2 buttons",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getRemoteImage(3),
                const SizedBox(
                  width: 10,
                ),
                _getRemoteImage(4)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "3 buttons",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "4 buttons",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            )
          ])
        ],
      ),
    );
  }

  Widget _waitingForButton(Map<String, dynamic> metadata) {
    int totalSteps = metadata["total_step"];
    int step = metadata["step"];
    RemoteButton button = RemoteButton.values[step - 1];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
      child: Row(
        children: [
          IconStepper(
            icons: Iterable.generate(
                totalSteps,
                (i) => Icon(
                      indexToAlphabetIcon(i),
                      color: Colors.white,
                    )).toList(),
            direction: Axis.vertical,
            alignment: Alignment.topCenter,
            activeStepColor: Colors.teal,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            activeStep: step - 1,
          ),
          Container(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/remote_${button.name}.png",
                  width: 250,
                  height: 250,
                ),
                Text(
                  "Push button ${button.name.toUpperCase()} in your remote",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 25,
                ),
                const SpinKitWave(
                  color: Colors.blue,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
