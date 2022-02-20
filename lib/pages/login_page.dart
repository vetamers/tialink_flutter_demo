import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tialink/widgets/google_sign_in_button.dart';
import 'package:tialink/widgets/yahoo_sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<String, Widget> segmentValue = {
    "phone": const Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      child: Text("Phone"),
    ),
    "email": const Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      child: Text("Email"),
    ),
  };
  String currentSegment = "phone";
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _googleButtonKey = GlobalKey<GoogleSignInButtonState>();
  bool _isInProgress = false;
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  void onSegmentChange(String? value) {
    setState(() {
      focusNode.unfocus();
      currentSegment = value.toString();
      _formKey.currentState?.reset();
      if (focusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(focusNode);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPhoneMethod = currentSegment == "phone";

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  "Login account",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: const Text(
                "Welcome Back",
                style: TextStyle(color: Colors.grey, fontSize: 17),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 25, 0, 40),
              child: Center(
                child: CupertinoSlidingSegmentedControl(
                  children: segmentValue,
                  groupValue: currentSegment,
                  padding: const EdgeInsets.all(5),
                  onValueChanged: onSegmentChange,
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    focusNode: focusNode,
                    controller: _firstController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(
                          isPhoneMethod ? "Phone number" : "Email Address"),
                      prefix:
                          currentSegment == "phone" ? const Text("+98") : null,
                      prefixIcon:
                          Icon(isPhoneMethod ? Icons.phone : Icons.email),
                    ),
                    maxLength: currentSegment == "phone" ? 10 : null,
                    maxLines: 1,
                    keyboardType: isPhoneMethod
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return 'Please fill this field';
                      } else if (isPhoneMethod) {
                        RegExp regexp =
                            RegExp(r'^{?(0?9[0-9]{9,9}}?)$', multiLine: false);

                        if (!regexp.hasMatch(_firstController.text)) {
                          return 'Enter valid phone number';
                        }
                      } else {
                        String p =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(p, multiLine: false);

                        if (!regex.hasMatch(_firstController.text)) {
                          return 'Enter valid email address';
                        }
                      }
                    },
                  ),
                  passwordTextForm(),
                  Container(
                    width: double.maxFinite,
                    height: 100,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ))),
                        onPressed: !_isInProgress ? () {
                          if (_formKey.currentState?.validate() == true){
                            if (isPhoneMethod){
                              var dialog = AlertDialog(
                                title: Text("Confirmation"),
                                content: Text("Are you sure you want to continue with +98" + _firstController.text + " number ?"),
                                actions: [
                                  TextButton(onPressed: () { Navigator.pop(context); }, child: Text("No")),
                                  TextButton(onPressed: () {
                                    //TODO: Request code to server
                                    Navigator.pop(context);
                                    Navigator.pushNamed(context, "/ota",arguments: {"phone":_firstController.text});
                                  }, child: const Text("Yes")),

                                ],
                              );

                              showDialog(context: context, builder: (context) => dialog,);
                            }
                          }
                        } : null,
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ]),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.maxFinite,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    child: Divider(thickness: 2),
                    width: 100,
                  ),
                  Container(
                    child: Text("Or signin with "),
                    padding: EdgeInsets.all(10),
                  ),
                  SizedBox(
                    child: Divider(thickness: 2),
                    width: 100,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 15),
              child: GoogleSignInButton(
                key: _googleButtonKey,
                onPress: () {
                  _googleButtonKey.currentState?.toggleProgress();
                },
              ),
            ),
            Container(
              child: YahooSignInButton(
                onPress: () {},
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget passwordTextForm() {
    if (currentSegment == "email") {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          maxLines: 1,
          controller: _secondController,
          autocorrect: false,
          enableSuggestions: false,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text("Password"),
              prefixIcon: Icon(Icons.lock)),
        ),
      );
    } else {
      return Container();
    }
  }
}
