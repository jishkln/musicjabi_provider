import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicrythum/controller/provider_db/favorite_db.dart';
import 'package:musicrythum/controller/provider_db/play_list_db.dart';
import 'package:musicrythum/controller/widgets/text_widget.dart';
import 'package:musicrythum/controller/widgets/widget_apps.dart';
import 'package:musicrythum/model/musicplayer_model.dart';
import 'package:musicrythum/view/screens/playlist/playlist_screen.dart'; 
import 'package:provider/provider.dart';

class PlayListFolder extends StatelessWidget {
  PlayListFolder({Key? key}) : super(key: key);

  final TextEditingController _playListNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<PlayListDB>(context, listen: false).getAllPlayList();
      },
    );

    return Consumer<PlayListDB>(
      // valueListenable: Hive.box<MusicPlayeerModel>('playListDB').listenable(),
      builder: (BuildContext context, value, child) {
        return Scaffold(
          backgroundColor: WidgetApps.bckgrndColor,
          appBar: AppBar(
            backgroundColor: WidgetApps.appBarColor,
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'PlayList',
                style: TextStyles().titleStyle(
                  sizeFont: 65,
                  textGradiantColor1: const Color.fromARGB(255, 223, 202, 202),
                  textGradiantColor2: const Color.fromARGB(169, 1, 31, 201),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18, top: 55),
              child: Hive.box<MusicPlayeerModel>('playlistDB').isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.hourglass_empty_sharp,
                            size: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Add your Playlist      ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 35,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 3),
                      ),
                      itemCount: value.playListNotif.length,
                      itemBuilder: (context, index) {
                        final data = value.playListNotif.toList()[index];

                        // return ValueListenableBuilder(
                        //     valueListenable:
                        //         Hive.box<MusicPlayeerModel>('playListDB')
                        //             .listenable(),
                        //     builder: (BuildContext context,
                        //         Box<MusicPlayeerModel> folderList,
                        //         Widget? child) {
                        return GridTile(
                          header: Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey,
                                          title: Text(
                                            'Delete ${data.name}?',
                                            style: TextStyles().dilogTextStyle(
                                                size: 20,
                                                textColor: Colors.black87),
                                          ),
                                          content: Text(
                                            'This canot be undone',
                                            style: TextStyles().dilogTextStyle(
                                                fontWeight: FontWeight.normal,
                                                textColor: Colors.black87),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'No',
                                                style: TextStyles()
                                                    .dilogTextStyle(
                                                        textColor: Colors
                                                            .yellow.shade200,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'Yes',
                                                style: TextStyles()
                                                    .dilogTextStyle(
                                                        textColor: Colors
                                                            .yellow.shade200,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              onPressed: () {
                                                value.playListDelete(index);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(
                                  Icons.disabled_by_default_rounded,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          footer: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data.name,
                              style: TextStyles().dilogTextStyle(
                                  size: 14, textColor: Colors.white70),
                            ),
                          ),
                          child: Card(
                            color: WidgetApps.bckgrndColor,
                            elevation: 4,
                            shadowColor:
                                const Color.fromARGB(255, 255, 190, 190),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => PlayListScreen(
                                            folderIndex: index,
                                            playList: data,
                                          )

                                      // WidgetApps().rootPlayList[index],
                                      ),
                                );
                                Provider.of<FavoriteDB>(context, listen: false)
                                    .notifi();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  image: DecorationImage(
                                      image: AssetImage(
                                        'asset/images/cycle.jpg',
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        );
                        //  });
                      },
                    ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            splashColor: Colors.red[900],
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: SizedBox(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Create Your Playlist',
                                style: TextStyles().dilogTextStyle(
                                    size: 20, textColor: Colors.black54),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Form(
                              key: _formKey,
                              child: TextFormField(
                                  controller: _playListNameController,
                                  decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: ' Playlist Name'),
                                  validator: (value) {
                                    // final playlistNames = PlayListDB()
                                    //     .playListNotifier
                                    //     .value
                                    //     .any((element) =>
                                    //         element.name ==
                                    //         _playListNameController.text);
                                    // print(PlayListDB().playListNotifier.value.toList());
                                    if (value == null || value.isEmpty) {
                                      return "Please enter playlist name";
                                    }
                                    // else if (playlistNames) {
                                    //   return "Please enter playlist name";
                                    // }
                                    else {
                                      return null;
                                    }
                                  }),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: const Color.fromARGB(
                                                255, 139, 0, 81)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Cancel',
                                        ))),
                                SizedBox(
                                    width: 100.0,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary: const Color.fromARGB(
                                                255, 139, 0, 81)),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            buttonClicked(context);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            backgroundColor: Colors.grey,
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.amber,
            ),
          ),
        );
      },
    );
  }

  Future<void> buttonClicked(context) async {
    final name = _playListNameController.text..trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MusicPlayeerModel(
        songsId: [],
        name: name,
      );
      Provider.of<PlayListDB>(context, listen: false).playListAdd(music);

      _playListNameController.clear();
    }
  }
}
