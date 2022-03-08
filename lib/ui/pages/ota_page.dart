import 'dart:developer';

import 'package:auth/auth.dart';
import 'package:auth/core/api_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pinput/pin_put/pin_put.dart';

import 'package:tialink/ui/pages.dart';
import 'package:tialink/core/auth/auth.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final BoxDecoration pinPutDecoration = const BoxDecoration(
      color: Color(0xFFF8F7FB),
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: Color(0xFFEBEAEC), spreadRadius: 2, blurRadius: 3, offset: Offset(0, 3))]);

  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  late PhoneVerificationRequest request;

  @override
  void dispose() {
    OTPInteractor().stopListenForCode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    log(args.toString());

    if (context.read<PhoneVerificationBloc>().state.value == PhoneVerificationStatus.initial) {
      context.read<PhoneVerificationBloc>().add(PhoneVerificationRequestEvent("${args["phone"]}"));
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "OTA",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                _onBackPress().then((value) => value ? Navigator.pop(context) : null);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))),
      body: WillPopScope(
        child: BlocConsumer<PhoneVerificationBloc, PhoneVerificationState>(
          builder: (context, state) {
            switch (state.value) {
              case PhoneVerificationStatus.initial:
                return _progressBar();
              case PhoneVerificationStatus.requested:
                request = state.metadata["request"];
                return _mainScreen(context, args);
              case PhoneVerificationStatus.requestError:
                return _requestError(state.metadata["error"], state.metadata["event"]);
              case PhoneVerificationStatus.tryCredential:
                return _progressBar();
              case PhoneVerificationStatus.invalidCredential:
                return _mainScreen(context, args);
              case PhoneVerificationStatus.done:
                return _progressBar();
            }
          },
          listener: (context, state) {
            var messenger = ScaffoldMessenger.of(context);
            switch (state.value) {
              case PhoneVerificationStatus.invalidCredential:
                messenger.showSnackBar(SnackBar(
                  content: Text((state.metadata["error"] as APIException).apiResultError!.message!),
                  backgroundColor: Theme.of(context).errorColor,
                ));
                _controller.clear();
                break;
              case PhoneVerificationStatus.requested:
                _startLisenteForCode();
                break;
              case PhoneVerificationStatus.done:
                Navigator.pop(context, true);
                break;
              default:
            }
          },
        ),
        onWillPop: () => _onBackPress(),
      ),
    );
  }

  Widget _progressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _mainScreen(BuildContext context, Map<String, dynamic> args) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Column(
        children: [
          Expanded(
            flex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                FlutterLogo(
                  size: 125,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Verification Code",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We have sent the code verification to your phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+98${args["phone"]}",
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(onPressed: () => {}, icon: const Icon(Icons.edit))
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: PinPut(
              controller: _controller,
              fieldsCount: 4,
              initialValue: "1234",
              mainAxisSize: MainAxisSize.min,
              eachFieldMargin: const EdgeInsets.all(10),
              eachFieldWidth: 60,
              eachFieldHeight: 60,
              fieldsAlignment: MainAxisAlignment.spaceAround,
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              focusNode: _focusNode,
              followingFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              submittedFieldDecoration: pinPutDecoration,
              onSubmit: (s) {
                context.read<PhoneVerificationBloc>().add(PhoneVerificationTryCodeEvent(request.id, s));
              },
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))))),
              onPressed: () {},
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 17),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _startLisenteForCode() {
    OTPInteractor()
        .startListenUserConsent()
        .then((value) => _controller.text = extractCodeFromString(value ?? '', 4) ?? '');
  }

  Widget _requestError(APIException error, PhoneVerificationEvent event) {
    return AlertDialog(
      title: Text("Verification request faild"),
      content: Text(error.apiResultError!.message!),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("OK"))
      ],
    );
  }

  Future<bool> _onBackPress() async {
    var state = context.read<PhoneVerificationBloc>().state;

    if (state.value == PhoneVerificationStatus.requested) {
      return Future.value(await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (dialog) => AlertDialog(
                title: const Text("Cancel pending verification"),
                content: const Text(
                    "Do you want to cancel this verification if your cancel it you can't verify your phone for 2min"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(dialog, false);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("OK"))
                ],
              )));
    }

    return Future.value(true);
  }
}
