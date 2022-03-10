import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tialink/core/bluetooth/bluetooth.dart';
import 'package:tialink/core/utils.dart';
import 'package:tialink/data/models.dart';
import 'package:tialink/data/repository/home_repository.dart';

class HomesListView extends StatefulWidget {
  const HomesListView({Key? key}) : super(key: key);

  @override
  State<HomesListView> createState() => _HomesListViewState();
}

class _HomesListViewState extends State<HomesListView> {
  @override
  Widget build(BuildContext context) {
    var _homeRepository = RepositoryProvider.of<HomeRepository>(context);

    return FutureBuilder(
      future: _homeRepository.getHomes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData
              ? _homeList(snapshot.data! as List<Home>)
              : _error(snapshot.error);
        } else {
          return _progressBar();
        }
      },
    );
  }

  Widget _homeList(List<Home> homes) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          homes[index].label,
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return Wrap(children: [
                                      ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text("Edit"),
                                        onTap: () {
                                          Navigator.popAndPushNamed(
                                              context, "/edit",arguments: homes[index]);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.security),
                                        title: Text("Permits"),
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.short_text_rounded),
                                        title: Text("Logs"),
                                      )
                                    ]);
                                  });
                            },
                            icon: const Icon(Icons.more_vert_rounded))
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        height: 200, child: _doorList(homes[index].doorList))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: homes.length),
    );
  }

  Widget _doorList(List<Door> doors) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Card(
            elevation: 8,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(doors[index].label),
                  Container(
                      height: 150,
                      width: 150,
                      child: _buttonsList(doors[index].buttonMode))
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: doors.length);
  }

  Widget _buttonsList(int mode) {
    List<RemoteButton> _buttons = RemoteButton.values.sublist(0, mode - 1);
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: Iterable.generate(mode, (index) {
        return IconButton(
          onPressed: () {},
          icon: Icon(indexToAlphabetIcon(index)),
          iconSize: 40,
        );
      }).toList(),
    );
  }

  Widget _error(dynamic e) {
    return Text("Error: $e");
  }

  Widget _progressBar() {
    return const Center(child: CircularProgressIndicator());
  }
}
