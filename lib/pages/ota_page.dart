import 'package:auth/auth.dart';
import 'package:auth/core/api_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:tialink/wizard/view/wizard_page.dart';

import '../auth/phone/phone_verification_bloc.dart';

class OtaVerification extends StatelessWidget {
  final VoidCallback onVerificationComplete;

  OtaVerification(this.onVerificationComplete, {Key? key}) : super(key: key);

  final BoxDecoration pinPutDecoration = const BoxDecoration(
      color: Color(0xFFF8F7FB),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
            color: Color(0xFFEBEAEC),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 3))
      ]);

  APIException? codeError;
  final _focusNode = FocusNode();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

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
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))),
      body: WillPopScope(
        child: BlocBuilder<PhoneVerificationBloc, PhoneVerificationState>(
          builder: (context, state) {
            codeError = null;

            if (state is PhoneVerificationInitial) {
              context
                  .read<PhoneVerificationBloc>()
                  .add(PhoneVerificationRequestEvent("0${args["phone"]}"));
              return progressbar();
            } else if (state is PhoneVerificationRequested) {
              args.addAll({"verificationId": state.verificationRequest.id});
              _startLisenteForCode();
              return mainScreen(context, args);
            } else if (state is PhoneVerificationInvalidCredential) {
              WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error.apiResultError!.message!)));
              });
              return mainScreen(context, args);
            } else if (state is PhoneVerificationDone) {
              Hive.box("app").put("isWizardComplete", false);
              WidgetsBinding.instance?.addPostFrameCallback(
                (timeStamp) {
                  Navigator.pushNamed(context, WizardPage.routeName);
                },
              );
              return progressbar();
            } else {
              return Text(state.toString());
            }
          },
        ),
        onWillPop: () => Future.value(false),
      ),
    );
  }

  Widget progressbar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget mainScreen(BuildContext context, Map<String, dynamic> args) {
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
              textStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              focusNode: _focusNode,
              followingFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              submittedFieldDecoration: pinPutDecoration,
              onSubmit: (s) {
                context.read<PhoneVerificationBloc>().add(
                    PhoneVerificationTryCodeEvent(args["verificationId"], s));
              },
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))))),
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
    OTPInteractor().startListenUserConsent().then((value) =>
        _controller.text = extractCodeFromString(value ?? '', 4) ?? '');
  }
}
