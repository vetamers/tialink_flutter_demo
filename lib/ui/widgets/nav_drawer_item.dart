import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final IconData icon;
  final bool isActive;

  DrawerItem(
      {Key? key,
      this.onTap,
      required this.title,
      required this.icon,
      this.isActive = false}) : assert(title.isNotEmpty) , super(key: key);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      title: Text(title),
      iconColor: isActive ? primaryColor : Colors.black,
      textColor: isActive ? primaryColor : Colors.black,
      leading: Icon(icon),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      tileColor: isActive ? primaryColor.withOpacity(.22) : null,
      onTap: !isActive ? onTap : null,
    );
  }
}
