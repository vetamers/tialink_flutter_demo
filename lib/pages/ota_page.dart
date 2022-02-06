import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtaVerification extends StatefulWidget {
  const OtaVerification({Key? key}) : super(key: key);

  @override
  _OtaVerificationState createState() => _OtaVerificationState();
}

class _OtaVerificationState extends State<OtaVerification> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final BoxDecoration pinPutDecoration = BoxDecoration(
        color: Color(0xFFF8F7FB),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Color(0xFFEBEAEC),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3))
        ]);

    return Scaffold(
      appBar: AppBar(
          title: Text(
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
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ))),
      body: WillPopScope(
        child: Container(
          padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          child: Column(
            children: [
              Expanded(
                flex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FlutterLogo(
                      size: 125,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Verification Code",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                      "+989353838214",
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(onPressed: () => {}, icon: Icon(Icons.edit))
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: PinPut(
                  fieldsCount: 4,
                  initialValue: "1234",
                  mainAxisSize: MainAxisSize.min,
                  eachFieldMargin: EdgeInsets.all(10),
                  eachFieldWidth: 60,
                  eachFieldHeight: 60,
                  fieldsAlignment: MainAxisAlignment.spaceAround,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  focusNode: _focusNode,
                  followingFieldDecoration: pinPutDecoration,
                  selectedFieldDecoration: pinPutDecoration,
                  submittedFieldDecoration: pinPutDecoration,
                ),
              ),
              Container(
                width: double.maxFinite,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25))))),
                  onPressed: () {},
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              )
            ],
          ),
        ),
        onWillPop: () {
          return Future.value(false);
        },
      ),
    );
  }
}
