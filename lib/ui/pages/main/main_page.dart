import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tialink/data/repository/home_repository.dart';
import 'package:tialink/ui/pages/main/homes_list_view.dart';
import 'package:tialink/ui/pages/main/nav_drawer.dart';
import 'package:tialink/ui/widgets/nav_drawer_item.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TiaLink"),
        ),
        drawer: NavDrawer(),
        body: RepositoryProvider(
          create: (context) => HomeRepository(),
          child: HomesListView(),
        ));
  }
}
