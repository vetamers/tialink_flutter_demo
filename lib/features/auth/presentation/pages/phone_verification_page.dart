import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:lottie/lottie.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/domain/entities/auth_phones_entities.dart';
import 'package:tialink/features/auth/domain/usecases/auth_phone_usecase.dart';
import 'package:tialink/features/auth/presentation/bloc/phone_auth_bloc.dart';
import 'package:tialink/features/auth/presentation/widgets/pinput_template.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  CountdownTimerController? _countdownController;
  PhoneAuthRequest? request;

  @override
  Widget build(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);

    var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    assert(args.containsKey("phone") && args["phone"] is String && args["phone"].length == 10);

    if (context.read<PhoneAuthBloc>().state.value == PhoneAuthStatus.initial) {
      context.read<PhoneAuthBloc>().add(PhoneAuthRequestEvent(RequestPhoneAuthParams(args["phone"])));
    }

    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Verification",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
          buildWhen: (_, current) => current.value != PhoneAuthStatus.credentialAccept,
          listener: (context, state) {
            switch (state.value) {
              case PhoneAuthStatus.invalidCredential:
                messenger.showSnackBar(errorSnackbar("Invalid Code"));
                _controller.clear();
                break;
              case PhoneAuthStatus.credentialAccept:
                messenger.clearSnackBars();
                messenger.showSnackBar(const SnackBar(
                  content: Text("You login successfully"),
                  backgroundColor: Colors.green,
                ));

                // Navigate to auth page with true result
                Navigator.pop(context, true);
                break;
              default:
            }
          },
          builder: (context, state) {
            switch (state.value) {
              case PhoneAuthStatus.initial:
                return _progressBar();
              case PhoneAuthStatus.loading:
                return _progressBar();
              case PhoneAuthStatus.requested:
                request = state.metadata["request"];
                _countdownController =
                    CountdownTimerController(endTime: _expireTimeToTimestamp(request!.expireIn));
                return _main(request!);
              case PhoneAuthStatus.requestFailed:
                return _requestFailed(state.metadata["exception"]);
              case PhoneAuthStatus.tooManyFailedAttempt:
                return _toManyFailedAttempts();
              case PhoneAuthStatus.invalidCredential:
                return _main(request!);
              default:
                return Text("Not implemented: ${state.value}");
            }
          },
        ),
      ),
    );
  }

  Widget _main(PhoneAuthRequest authRequest) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Lottie.asset("assets/animations/mobile_otp.json", reverse: true, height: 300)),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Column(
              children: const [
                Text(
                  "Verification Code",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "We have sent the verification code to your phone number",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Expanded(
              flex: 0,
              child: CountdownTimer(
                controller: _countdownController,
                widgetBuilder: (_, time) {
                  if (time == null) {
                    return TextButton(
                        onPressed: () {
                          //TODO: Implement resend
                        },
                        child: const Text("Resend"));
                  } else {
                    return Text(
                      timeToString(time),
                      style: const TextStyle(fontSize: 18),
                    );
                  }
                },
              )),
          Expanded(
              child: TiaLinkPinPut(
                  onSubmit: (code) {
                    context.read<PhoneAuthBloc>().add(PhoneAuthTryCredential(authRequest, code));
                  },
                  controller: _controller,
                  focusNode: _focusNode))
        ],
      ),
    );
  }

  Widget _progressBar() {
    return const Center(child: CircularProgressIndicator());
  }

  int _expireTimeToTimestamp(int expireInSecond) {
    return DateTime.now().millisecondsSinceEpoch + (expireInSecond * 1000);
  }

  String timeToString(CurrentRemainingTime time) {
    if (time.min != null) {
      return "${time.min.toString().padLeft(2, '0')}:${time.sec.toString().padLeft(2, '0')}";
    } else {
      return time.sec.toString().padLeft(2, '0');
    }
  }

  SnackBar errorSnackbar(String errorMessage, [SnackBarAction? action]) {
    return SnackBar(
      content: Text(errorMessage),
      action: action,
      backgroundColor: Theme.of(context).errorColor,
      duration: const Duration(seconds: 8),
    );
  }

  Widget _requestFailed(APIException exception) {
    return AlertDialog(
      title: const Text("Verification request failed"),
      content: Text("We can't accept your request for verification dua to:\n $exception"),
    );
  }

  Widget _toManyFailedAttempts() {
    return const AlertDialog(
      title: Text("Verification failed"),
      content: Text("Too many failed attempts"),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Cancel pending verification"),
              content: const Text(
                  "Do you want to cancel this verification if your cancel it you can't verify your phone for 2min"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text("No")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("OK"))
              ],
            )).asStream().cast<bool>().first;
  }
}
