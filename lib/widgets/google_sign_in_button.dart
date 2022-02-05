import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  VoidCallback onPress;

  GoogleSignInButton({Key? key, required this.onPress}) : super(key: key);

  @override
  GoogleSignInButtonState createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)))),
              overlayColor: MaterialStateProperty.all(Color(0xFFCCCCCC))),
          onPressed: widget.onPress,
          child: Center(
            child: _isSigningIn ? _progress() : _signIn(),
          )),
    );
  }

  Widget _signIn() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/google_logo.png",
          width: 25,
          height: 25,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          "Google",
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }

  Widget _progress() {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator();
  }

  void toggleProgress() => setState(() {
        _isSigningIn = !_isSigningIn;
      });
}
