import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';

class WelcomePage extends StatelessWidget {
  VoidCallback onDone;

  WelcomePage(this.onDone, {Key? key}) : super(key: key);

  final List<PageViewModel> _listPageViewModel = [
    PageViewModel(
        title: "Smart key for your home",
        body:
            "With Home, you can set aside your keychain and remote and transfer everything to your smartphone",
        image: FlutterLogo(
          size: 200,
        )),
    PageViewModel(
        title: "For all building members",
        body:
            "Every user with access can open and close the door with tialink application on smartphones",
        image: FlutterLogo(
          size: 200,
        )),
    PageViewModel(
        title: "Always in your pocket",
        body:
            "The master can give others temporary or permanent access, anywhere, any time.",
        image: FlutterLogo(
          size: 200,
        )),
    PageViewModel(
        title: "The smart door needs Tialink device",
        body:
            "For using tialink, one of our devices should be installed on doors to make it smart.",
        image: FlutterLogo(
          size: 200,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _listPageViewModel,
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () {
        Hive.box("app").put("isFirstLaunch", false);
        onDone.call();
      },
      next: Text("Next"),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }
}
