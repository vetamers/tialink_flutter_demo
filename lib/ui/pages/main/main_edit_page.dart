import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tialink/data/models.dart';

import '../../../data/repository/home_repository.dart';

class HomeEditPage extends StatefulWidget {
  const HomeEditPage({Key? key}) : super(key: key);

  @override
  State<HomeEditPage> createState() => _HomeEditPageState();
}

class _HomeEditPageState extends State<HomeEditPage> {
  int? doorExpandedIndex;

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments! as Home;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              _detailsCard(title: "Home", rows: [
                _detailsRow(title: "ID", content: args.id),
                _detailsRow(
                    key: "home.label",
                    title: "Label",
                    content: args.label,
                    isEditable: true)
              ]),
              const SizedBox(
                height: 10,
              ),
              _detailsCard(title: "Device", rows: [
                _detailsRow(title: "ID", content: args.device.id),
                _detailsRow(
                    title: "MAC Address", content: args.device.macAddress)
              ]),
              const SizedBox(
                height: 10,
              ),
              _detailsCard(
                  title: "Doors",
                  padding: const EdgeInsets.only(top: 10),
                  rows: [
                    ExpansionPanelList(
                        elevation: 0,
                        expansionCallback: (panelIndex, isExpanded) {
                          setState(() {
                            doorExpandedIndex = !isExpanded ? panelIndex : null;
                          });
                        },
                        children:
                            Iterable.generate(args.doorList.length, (index) {
                          return ExpansionPanel(
                              canTapOnHeader: true,
                              isExpanded: doorExpandedIndex == index,
                              headerBuilder: (context, isExpanded) => Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Door ${index + 1}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                              body: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    _detailsRow(
                                        title: "ID",
                                        content: args.doorList[index].id),
                                    _detailsRow(
                                        title: "Button mode",
                                        content: args.doorList[index].buttonMode
                                            .toString()),
                                    _detailsRow(
                                        key: "door.label",
                                        title: "Label",
                                        content: args.doorList[index].label,
                                        isEditable: true)
                                  ],
                                ),
                              ));
                        }).toList())
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsCard(
      {required String title,
      EdgeInsetsGeometry padding = const EdgeInsets.all(10),
      required List<Widget> rows}) {
    return Card(
        child: Container(
      padding: padding,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          ...rows
        ],
      ),
    ));
  }

  Widget _detailsRow(
      {String? key,
      required String title,
      required String content,
      bool isEditable = false}) {
    assert(isEditable ? key != null : true);
    return Padding(
      padding: EdgeInsets.only(top: !isEditable ? 15 : 0),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: title + ": ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: content)
                ]),
          ),
          isEditable
              ? IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => _editAlertDialog(
                            context: context,
                            onSave: (s) {
                              // Save value in server and update UI
                            },
                            value: content,
                            title: title));
                  },
                  icon: const Icon(Icons.edit_rounded))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _editAlertDialog(
      {required BuildContext context,
      required Function(String newValue) onSave,
      required String value,
      required String title}) {
    var formKey = GlobalKey<FormState>();
    TextEditingController controller =
        TextEditingController.fromValue(TextEditingValue(text: value));
    return AlertDialog(
      title: Text(title),
      content: Wrap(children: [
        Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text(title),
            ),
            maxLines: 1,
            maxLength: 32,
            validator: (s) {
              return s?.isEmpty == true
                  ? "Please filled valid ${title.toLowerCase()}"
                  : null;
            },
          ),
        )
      ]),
      actions: [
        TextButton(
            onPressed: () {
              formKey.currentState!.validate();
            },
            child: const Text("Save")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"))
      ],
    );
  }
}
