import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tialink/core/utils.dart';
import 'package:tialink/features/main/data/model/main_models.dart';
import 'package:tialink/features/main/domain/usecases/main_usecase.dart';

import '../../domain/entities/main_entities.dart';

class HomeEditPage extends StatefulWidget {
  const HomeEditPage({Key? key}) : super(key: key);

  @override
  State<HomeEditPage> createState() => _HomeEditPageState();
}

class _HomeEditPageState extends State<HomeEditPage> {
  int? doorExpandedIndex;
  Home? home;

  @override
  Widget build(BuildContext context) {
    home ??= ModalRoute.of(context)?.settings.arguments! as Home;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit"),
          actions: [
            home != ModalRoute.of(context)?.settings.arguments! as Home
                ? IconButton(
                    onPressed: () {
                      _save().then((_) {
                        Navigator.pop(context, true);
                      });
                    },
                    icon: const Icon(Icons.done),
                    tooltip: "Save",
                  )
                : const SizedBox()
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                _detailsCard(title: "Home", rows: [
                  _detailsRow(title: "ID", content: home!.uuid),
                  _detailsRow(
                      key: "label",
                      title: "Label",
                      content: home!.label,
                      isEditable: true)
                ]),
                const SizedBox(
                  height: 10,
                ),
                _detailsCard(title: "Device", rows: [
                  _detailsRow(title: "ID", content: home!.device.uuid),
                  _detailsRow(title: "MAC Address", content: home!.device.macAddress)
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
                          children: Iterable.generate(home!.doors.length, (index) {
                            return ExpansionPanel(
                                canTapOnHeader: true,
                                isExpanded: doorExpandedIndex == index,
                                headerBuilder: (context, isExpanded) => Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Door ${index + 1}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16),
                                    )),
                                body: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      _detailsRow(
                                          title: "ID",
                                          content: home!.doors[index].uuid),
                                      _detailsRow(
                                          title: "Button mode",
                                          content: home!.doors[index].buttonMode
                                              .toString()),
                                      _detailsRow(
                                          key: "doors.$index.label",
                                          title: "Label",
                                          content: home!.doors[index].label,
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
      ),
      onWillPop: _onBackPressed,
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
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
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
                              var json = (home as HomeModel).toJson();

                              if (key!.contains('.')) {
                                var keys = key.split('.');
                                json[keys[0]][keys[1].toInt()][keys[2]] = s;
                              } else {
                                json[key] = s;
                              }

                              //TODO: Improve edit feature

                              setState(() {
                                log(home.toString());
                                home = HomeModel.fromJson(json);
                              });
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
              border: const OutlineInputBorder(),
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
              if (formKey.currentState!.validate()) {
                onSave(controller.text);
                Navigator.pop(context, true);
              }
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

  Future<bool> _onBackPressed() async {
    if (home != ModalRoute.of(context)?.settings.arguments! as Home) {
      showDialog(
          context: context,
          builder: (dialog) => AlertDialog(
                title: const Text("Unsaved changes"),
                content: const Text(
                    "You have made changes.\nDo you want to save or discard theme?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(dialog, false);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(dialog, true);
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        "Discard",
                        style: TextStyle(color: Colors.red),
                      )),
                  TextButton(
                      onPressed: () async {
                        await _save();
                        Navigator.pop(dialog, true);
                        Navigator.pop(context, true);
                      },
                      child: const Text("Save")),
                ],
              ));

      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<void> _save() async {
    await GetIt.I<UpdateHome>()(UpdateHomeParam(home!));
  }
}
