import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tialink/ui/widgets.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key? key}) : super(key: key);
  int currentIndex = 0;

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  List<Map<String, dynamic>> items = [
    {"title": "Dashboard", "icon": Icons.dashboard_rounded},
    {"title": "Stetting", "icon": Icons.settings}
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Amirsobhan Nafariyeh",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text(
                      "amirsobhan1553@gmail.com",
                    )
                  ],
                ),
              ),
            ),
          ),
          ListView.separated(
            itemCount: items.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return DrawerItem(
                title: items[index]["title"],
                icon: items[index]["icon"],
                isActive: index == widget.currentIndex,
                onTap: () {
                  setState(() {
                    widget.currentIndex = index;
                  });
                  //TODO: use pop and push name
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 8,
              );
            },
          )
        ],
      ),
    );
  }
}
