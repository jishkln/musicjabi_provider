import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicrythum/controller/provider_db/favorite_db.dart';
import 'package:musicrythum/controller/provider_db/play_list_db.dart';
import 'package:musicrythum/controller/widgets/widget_apps.dart';
import 'package:musicrythum/model/musicplayer_model.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';
import 'package:musicrythum/view/screens/nowplay/play_screen.dart';
import 'package:musicrythum/view/screens/playlist/add_songs_playlist.dart';
 import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayListScreen extends StatelessWidget {
  PlayListScreen({Key? key, required this.playList, required this.folderIndex})
      : super(key: key);
  final MusicPlayeerModel playList;
  final int folderIndex;

  late List<SongModel> playListSongs;
  final audioPlayer = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListDB>(builder: (context, value, child) {
      return Scaffold(
        backgroundColor: WidgetApps.bckgrndColor,
        // backgroundColor: Colors.amber,
        body: SafeArea(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 0, 255, 34),
                      Color.fromARGB(255, 188, 174, 174),
                      // Color.fromARGB(193, 183, 72, 12),
                    ],
                  ),
                  image: DecorationImage(
                      image: AssetImage(WidgetApps().imgHomeGrid[1]),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(150),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllSongPlayList(playList: playList),
                              ),
                            );
                            // FavoriteDB.favorite.notifyListeners();
                            Provider.of<FavoriteDB>(context, listen: false);
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6.7,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(
                            right: 180,
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AllSongPlayList(playList: playList),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.add_circle_rounded,
                              size: 80,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable:
                    Hive.box<MusicPlayeerModel>('playListDB').listenable(),
                builder: (BuildContext context, Box<MusicPlayeerModel> value,
                    Widget? child) {
                  playListSongs =
                      listPlaylist(value.values.toList()[folderIndex].songsId);

                  return ListView.builder(
                    itemExtent: 90,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: playListSongs.length,
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        child: ListTile(
                          leading: QueryArtworkWidget(
                            id: playListSongs[index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                'asset/images/Defaultimg.png',
                              ),
                            ),
                            errorBuilder: (context, excepion, gdb) {
                              context.read();
                              return Image.asset('');
                            },
                          ),
                          title: Text(
                            playListSongs[index].title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          subtitle: Text(
                            playListSongs[index].artist!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              playList.deleteData(playListSongs[index].id);
                              const snackbar = SnackBar(
                                backgroundColor:
                                    Color.fromARGB(255, 247, 210, 2),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(8),
                                content: Text(
                                  'Song Removed From Playlist',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                            },
                            icon: const Icon(Icons.close),
                          ),
                          onTap: () {
                            List<SongModel> newlist = [...playListSongs];

                            Songstorage.player.stop();
                            Songstorage.player.setAudioSource(
                                Songstorage.createSongList(newlist),
                                initialIndex: index);
                            Songstorage.player.play();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => PlayScreen(
                                      palySong: playListSongs,
                                    )));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plysongs = [];
    for (int i = 0; i < Songstorage.songCopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (Songstorage.songCopy[i].id == data[j]) {
          plysongs.add(Songstorage.songCopy[i]);
        }
      }
    }
    return plysongs;
  }
}
