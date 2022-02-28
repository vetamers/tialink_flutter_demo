import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YahooSignInButton extends StatefulWidget {
  VoidCallback onPress;

  YahooSignInButton({Key? key, required this.onPress}) : super(key: key);

  @override
  YahooSignInButtonState createState() => YahooSignInButtonState();
}

class YahooSignInButtonState extends State<YahooSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF5F00D3)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25)))),
          ),
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
          "assets/images/yahoo_logo.png",
          width: 25,
          height: 25,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          "Yahoo",
          style: TextStyle(color: Colors.white),
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
