import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tialink/core/utils.dart';
import 'package:tialink/features/bluetooth/domain/repositories/bluetooth_repository.dart';
import 'package:tialink/features/main/domain/usecases/main_usecase.dart';

import '../../domain/entities/bluetooth_entities.dart';
import '../bloc/bluetooth_bloc.dart';

class RemoteConfigView extends StatefulWidget {
  final bool isDoorOnly;
  final int remoteNumber;
  final void Function(dynamic param) onDone;
  const RemoteConfigView(
      {Key? key,
      this.isDoorOnly = false,
      this.remoteNumber = 1,
      required this.onDone})
      : super(key: key);

  @override
  _RemoteConfigViewState createState() => _RemoteConfigViewState();
}

class _RemoteConfigViewState extends State<RemoteConfigView> {
  WidgetsBinding? _binding;
  int? buttonMode;
  int? currentStep;
  String? secret;
  bool configDone = false;

  @override
  void initState() {
    _binding = WidgetsBinding.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (buttonMode == null) {
      return _selectConfig();
    } else if (!configDone) {
      return StreamBuilder(
        stream: GetIt.I<BluetoothRepository>()
            .setupNewRemote(buttonMode!, widget.remoteNumber),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              throw NullThrownError();
            case ConnectionState.waiting:
              return _progressBar();
            case ConnectionState.active:
              var data = snapshot.data as RemoteSetupState;
              secret = data.secret;
              log(data.toString());
              switch (data.status) {
                case RemoteSetupStatus.waitingForAction:
                  return _waitingForButton(data.totalStep, data.step);
                case RemoteSetupStatus.signalReceived:
                  _binding?.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("OK, Device receive remote signal and save it."),
                      backgroundColor: Colors.green,
                    ));
                  });
                  return _waitingForButton(data.totalStep, data.step);
                case RemoteSetupStatus.operationDone:
                  return _progressBar();
              }
            case ConnectionState.done:
              return _setName();
          }
        },
      );
    } else {
      return _setName();
    }
  }

  Widget _progressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _setName() {
    var _form = GlobalKey<FormState>();
    var _labelField = GlobalKey<FormFieldState>();

    return Container(
      height: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
      child: Column(
        children: [
          const Text(
            "Setup is almost complete.",
            style: TextStyle(fontSize: 20),
          ),
          Text(!widget.isDoorOnly
              ? "The last step you should set label for your home"
              : "The last step you should set label for your door"),
          const SizedBox(
            height: 15,
          ),
          Form(
            key: _form,
            child: TextFormField(
                key: _labelField,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    label: Text(!widget.isDoorOnly ? "Home label" : "Door label"),
                    prefixIcon: Icon(
                        !widget.isDoorOnly ? Icons.home : Icons.door_front_door)),
                maxLength: 32,
                maxLines: 1,
                validator: (s) {
                  if (s!.length < 3) {
                    return "Label must at least 3 characters";
                  } else {
                    return null;
                  }
                }),
          ),
          const Expanded(child: SizedBox()),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {
                if (_form.currentState!.validate()) {
                  if (widget.isDoorOnly) {
                    widget.onDone({
                      "mode": buttonMode!,
                      "label": _labelField.currentState!.value
                    });
                  } else {
                    var deviceMac = context.read<BluetoothBloc>().device!.address;
                    var param = AddHomeParam.full(_labelField.currentState!.value,
                        deviceMac, secret!, "Main", buttonMode!);
                    widget.onDone(param);
                  }
                }
              },
              label: const Text("Done"),
              icon: const Icon(Icons.done),
            ),
          )
        ],
      ),
    );
  }

  Widget _getRemoteImage(int number) {
    return GestureDetector(
      onTap: () {
        setState(() {
          buttonMode = number;
        });
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

  Widget _waitingForButton(int totalSteps, int step) {
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
          Column(
            children: [
              Image.asset(
                "assets/images/remote_${button.name}.png",
                width: 250,
                height: 250,
              ),
              Text(
                "Push button ${button.name.toUpperCase()} in your remote",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              const SpinKitWave(
                color: Colors.blue,
              )
            ],
          )
        ],
      ),
    );
  }
}
