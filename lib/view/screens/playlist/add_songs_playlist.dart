import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider_db/play_list_db.dart';
import 'package:musicrythum/model/musicplayer_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class AllSongPlayList extends StatelessWidget {
  static List<SongModel> playSongs = [];
  AllSongPlayList({Key? key, required this.playList}) : super(key: key);
  final MusicPlayeerModel playList;

  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListDB>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.red),
        ),
        body: SafeArea(
          child: FutureBuilder<List<SongModel>>(
            future: audioQuery.querySongs(
              sortType: null,
              orderType: OrderType.ASC_OR_SMALLER,
              uriType: UriType.EXTERNAL,
              ignoreCase: true,
            ),
            builder: (context, item) {
              if (item.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (item.data!.isEmpty) {
                return const Center(
                  child: Text("No songs Found"),
                );
              } else {
                return ListView.builder(
                  itemExtent: 90,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: item.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        leading: QueryArtworkWidget(
                          id: item.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage(
                              'asset/images/Defaultimg.png',
                            ),
                          ),
                        ),
                        title: Text(
                          item.data![index].displayNameWOExt,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          item.data![index].artist.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        trailing: Consumer<PlayListDB>(
                            builder: (context, value, child) {
                          return IconButton(
                            onPressed: () {
                              playlistCheck(context, item.data![index]);
                              Provider.of<PlayListDB>(context, listen: false)
                                  .notif();
                            },
                            icon: playList.isValueIn(item.data![index].id)
                                ? const Icon(
                                    Icons.close_rounded,
                                  )
                                : const Icon(Icons.add_circle_outline),
                            color: playList.isValueIn(item.data![index].id)
                                ? Colors.black
                                : Colors.red,
                          );
                        }),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    });
  }

  void playlistCheck(context, SongModel data) {
    if (!playList.isValueIn(data.id)) {
      playList.add(data.id);
      const snackbar = SnackBar(
        backgroundColor: Color.fromARGB(255, 247, 210, 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        content: Text(
          'Added to Playlist',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        duration: Duration(milliseconds: 500),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } else {
      playList.deleteData(data.id);
      const snackbar = SnackBar(
        backgroundColor: Color.fromARGB(255, 247, 210, 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(8),
        content: Text(
          'Song Removed From Playlist',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(milliseconds: 500),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
