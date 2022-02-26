import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectRoleView extends StatefulWidget {
  final VoidCallback? Function(String value) onValueChange;
  final String? initValue;
  const SelectRoleView({Key? key,required this.onValueChange,this.initValue}) : super(key: key);

  @override
  _SelectRoleViewState createState() => _SelectRoleViewState();
}

class _SelectRoleViewState extends State<SelectRoleView> {
  final _segmentWidgets = {
    "master": Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home),
          Text("Master")
        ],
      ),
      padding: const EdgeInsets.all(15),
    ),
    "slave": Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.person),
          Text("Slave")
        ],
      ),
      padding: const EdgeInsets.all(15),
    )
  };
  String currentSegment = "master";

  @override
  void initState() {
    // TODO: implement initState
    currentSegment = widget.initValue ?? currentSegment;
    log("${widget.initValue}");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
              child: Text(
            _roleDescriptionText(currentSegment),
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 10,),
          CupertinoSlidingSegmentedControl(
            groupValue: currentSegment,
            onValueChanged: (value) {
              widget.onValueChange(value.toString());
              setState(() {
                currentSegment = value.toString();
              });
            },
            padding: const EdgeInsets.all(5),
            children: _segmentWidgets,
          ),
        ],
      ),
    );
  }

  String _roleDescriptionText(String role){
    switch(role){
      case "master":
        return "I'm master of home and i want to config device for my home";
      case "slave":
        return "I'm slave and i want to use tialink to control door";
      default: return "Not implemented";
    }
  }
}
