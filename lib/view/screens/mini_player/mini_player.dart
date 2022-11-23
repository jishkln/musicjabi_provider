import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider/miniplayer_provider.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';
import 'package:musicrythum/view/screens/nowplay/play_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MiniPlayerProvider>(context).checkMiniPlayer();
    });
    Size deviceSize = MediaQuery.of(context).size;
    return Consumer(builder: (context, value, child) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: const Color.fromARGB(255, 56, 3, 97),
        width: deviceSize.width,
        height: 70,
        child: ListTile(
          iconColor: Colors.white,
          textColor: Colors.white,
          onTap: (() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    PlayScreen(palySong: Songstorage.playingSongs),
              ),
            );
          }),
          leading: QueryArtworkWidget(
            id: Songstorage.playingSongs[Songstorage.player.currentIndex!].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(
                'asset/images/Defaultimg.png',
              ),
            ),
          ),
          title: Text(
            Songstorage.playingSongs[Songstorage.player.currentIndex!].title,
            style:
                const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
          ),
          subtitle: Text(
            "${Songstorage.playingSongs[Songstorage.player.currentIndex!].artist}",
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 11,
            ),
          ),
          trailing: FittedBox(
            fit: BoxFit.fill,
            child: TextButton(
              clipBehavior: Clip.none,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                //primary: Colors.white
              ),
              onPressed: () async {
                if (Songstorage.player.playing) {
                  await Songstorage.player.pause();
                  //  context.read();
                } else {
                  await Songstorage.player.play();
                  //context.read();
                }
              },
              child: StreamBuilder<bool>(
                stream: Songstorage.player.playingStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  bool? currentPlayingStatus = snapshot.data;
                  if (currentPlayingStatus != null && currentPlayingStatus) {
                    return const Center(
                      child: Icon(
                        Icons.pause_circle_filled_outlined,
                        size: 60,
                        color: Colors.white,
                      ),
                    );
                  } else {
                    return const Icon(
                      Icons.play_circle_filled_outlined,
                      size: 60,
                      color: Colors.white,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
