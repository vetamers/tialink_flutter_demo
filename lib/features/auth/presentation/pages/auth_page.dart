import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, Widget> segmentValue = {
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
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  bool get isPhoneMethod => currentSegment == "phone";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 40),
                child: Center(
                  child: CupertinoSlidingSegmentedControl(
                    children: segmentValue,
                    groupValue: currentSegment,
                    padding: const EdgeInsets.all(5),
                    onValueChanged: onSegmentChange,
                  ),
                ),
              ),
              _form(),
              SizedBox(
                height: isPhoneMethod ? 5 : 15,
              ),
              SizedBox(
                width: double.maxFinite,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    focusNode.unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (isPhoneMethod) {
                        Navigator.pushNamed(context, "auth/phoneVerification",
                            arguments: {"phone": _firstController.text}).then((value) {
                          if (value == true) {
                            //TODO: Move to setup page
                            log("Logged in");
                          }
                        });
                      }
                    }
                  },
                  child: Text(
                    isPhoneMethod ? "Send Code" : "Login",
                    style: const TextStyle(fontSize: 17),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onSegmentChange(String? value) {
    setState(() {
      focusNode.unfocus();
      currentSegment = value.toString();
      _formKey.currentState?.reset();
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(focusNode);
        });
      }
    });
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: focusNode,
            controller: _firstController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(isPhoneMethod ? "Phone number" : "Email Address"),
              prefix: currentSegment == "phone" ? const Text("+98") : null,
              prefixIcon: Icon(isPhoneMethod ? Icons.phone : Icons.email),
            ),
            maxLength: currentSegment == "phone" ? 10 : null,
            maxLines: 1,
            keyboardType: isPhoneMethod ? TextInputType.number : TextInputType.emailAddress,
            textInputAction: !isPhoneMethod ? TextInputAction.next : TextInputAction.done,
            inputFormatters: [
              isPhoneMethod
                  ? FilteringTextInputFormatter.digitsOnly
                  : FilteringTextInputFormatter.singleLineFormatter
            ],
            validator: (value) {
              if (value?.isEmpty == true) {
                return 'Please fill this field';
              } else if (isPhoneMethod) {
                RegExp regexp = RegExp(r'^{?(0?9[0-9]{9,9}}?)$', multiLine: false);

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
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          !isPhoneMethod
              ? TextFormField(
                  controller: _secondController,
                  maxLines: 1,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), label: Text("Password"), prefixIcon: Icon(Icons.lock)),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
