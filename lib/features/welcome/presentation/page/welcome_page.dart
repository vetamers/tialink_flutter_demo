import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);

  final List<PageViewModel> _listPageViewModel = [
    PageViewModel(
        title: "Smart key for your home",
        body:
        "With Home, you can set aside your keychain and remote and transfer everything to your smartphone",
        image: Lottie.asset("assets/animations/blue_house.json",)),
    PageViewModel(
        title: "For all building members",
        body:
        "Every user with access can open and close the door with tialink application on smartphones",
        image: Lottie.asset("assets/animations/apartment.json")),
    PageViewModel(
        title: "Always in your pocket",
        body:
        "The master can give others temporary or permanent access, anywhere, any time.",
        image: Lottie.asset("assets/animations/profile_lock.json")),
    PageViewModel(
        title: "The smart door needs Tialink device",
        body:
        "For using tialink, one of our devices should be installed on doors to make it smart.",
        image: Lottie.asset("assets/animations/lock.json")),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent));

    return Scaffold(
      body: IntroductionScreen(
        pages: _listPageViewModel,
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        showSkipButton: true,
        skip: const Text("Skip"),
        onDone: () {
          context.read<Box>().put("isFirstLaunch", false)
              .then((_) => Navigator.pushReplacementNamed(context, "auth"));
        },
        next: const Text("Next"),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );  }
}
