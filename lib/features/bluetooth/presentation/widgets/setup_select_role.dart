import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SelectRoleStep extends StatefulWidget {
  final void Function(int selectedRoleIndex) onRoleChange;
  final VoidCallback onDone;
  final List<Tuple2<String, String>> roles;
  const SelectRoleStep({Key? key, required this.onRoleChange, required this.onDone, required this.roles})
      : super(key: key);

  @override
  State<SelectRoleStep> createState() => _SelectRoleStepState();
}

class _SelectRoleStepState extends State<SelectRoleStep> {
  int groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          ...Iterable.generate(
            widget.roles.length,
            (index) => ListTile(
              title: Text(widget.roles[index].item1),
              subtitle: Text(widget.roles[index].item2),
              leading: Radio(
                value: index,
                groupValue: groupValue,
                onChanged: (value) {
                  setState(() {
                    groupValue = value as int;
                  });
                  widget.onRoleChange(value as int);
                },
              ),
              onTap: () {
                setState(() {
                  groupValue = index;
                });
                widget.onRoleChange(index);
              },
            ),
          ).toList(),
          const Expanded(child: SizedBox()),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
                child: FloatingActionButton.extended(
                  onPressed: widget.onDone,
                  label: const Text("Next"),
                  icon: const Icon(
                    Icons.chevron_right,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
