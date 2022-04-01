import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

enum TialinkAppBarMode {
  connecting,
  notConnected,
  connected,
  normal
}

class TialinkAppBar extends StatefulWidget {
  final TialinkAppBarMode mode;
  const TialinkAppBar(this.mode, {Key? key}) : super(key: key);

  @override
  State<TialinkAppBar> createState() => _TialinkAppBarState();
}

class _TialinkAppBarState extends State<TialinkAppBar> {
  @override
  Widget build(BuildContext context) {
    switch (widget.mode) {
      case TialinkAppBarMode.connecting:
        return AppBar(
          title: Row(
            children: [
              const Text("Connecting "),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  WavyAnimatedText("...",
                      textStyle:
                          const TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
        );
      case TialinkAppBarMode.normal:
        return AppBar(
          title: const Text("TiaLink"),
        );
      default:
        return Text("not implemented ${widget.mode}");
    }
  }
}
