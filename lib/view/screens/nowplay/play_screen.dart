import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicrythum/controller/provider/playscreen_provider.dart';
import 'package:musicrythum/controller/provider_db/favorite_db.dart';
import 'package:musicrythum/controller/provider/favorite_bttn.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PlayScreen extends StatelessWidget {
  PlayScreen({
    Key? key,
    required this.palySong,
  }) : super(key: key);
  final List<SongModel> palySong;

  bool _isShuffle = false;

  bool isPop = false;
  DateTime isBackButtonCicked = DateTime.now();
  @override
  

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<PlayScreenProvider>(context, listen: false)
            .checkSongIndex();
      },
    );

    return Consumer<PlayScreenProvider>(builder: (context, value, child) {
      return WillPopScope(
        onWillPop: () async {
          if (DateTime.now().difference(isBackButtonCicked) >=
              const Duration(microseconds: 100)) {
            Navigator.pop(context);
            //FavoriteDB.favorite.notifyListeners();
            Provider.of<FavoriteDB>(context, listen: false);
            isBackButtonCicked = DateTime.now();
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              color: Colors.black,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .005,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, right: 8, top: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                //  FavoriteDB.favorite.notifyListeners();
                                Provider.of<FavoriteDB>(context, listen: false);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 7,
                            child: Center(
                              child: Text(
                                'Now Playing',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onHorizontalDragEnd: (dragDownDetails) {
                        if (dragDownDetails.primaryVelocity! < 20) {
                          if (Songstorage.player.hasNext) {
                            Songstorage.player.seekToNext();
                            context.read();
                          }
                        } else if (dragDownDetails.primaryVelocity! > 20) {
                          if (Songstorage.player.hasPrevious) {
                            Songstorage.player.seekToPrevious();
                            context.read();
                          }
                        }
                      },
                      onVerticalDragEnd: (dragDownDetails) {
                        if (dragDownDetails.primaryVelocity! > 0) {
                          Navigator.pop(context);
                          // FavoriteDB.favorite.notifyListeners();
                          Provider.of<FavoriteDB>(context, listen: false);
                        }
                        context.read();
                      },
                      child: Consumer<PlayScreenProvider>(
                          builder: (context, value, child) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: QueryArtworkWidget(
                            id: palySong[value.currentIndex].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 300,
                            ),
                          ),
                        );
                      }),
                    ),
                    ListTile(
                      title: Text(
                        palySong[value.currentIndex].displayNameWOExt,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      subtitle: Text(
                        palySong[value.currentIndex].artist.toString() ==
                                "<unknown>"
                            ? "Unknown Artist"
                            : palySong[Songstorage.player.currentIndex!]
                                .artist
                                .toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: FavoriteBtn(
                        song: palySong[value.currentIndex],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: StreamBuilder<DurationState>(
                          stream: _durationStateStream,
                          builder: (context, snapshot) {
                            final durationState = snapshot.data;
                            final progress =
                                durationState?.position ?? Duration.zero;
                            final total = durationState?.total ?? Duration.zero;

                            return ProgressBar(
                                progress: progress,
                                total: total,
                                barHeight: 3.0,
                                thumbRadius: 10,
                                progressBarColor: Colors.white,
                                thumbColor:
                                    const Color.fromARGB(255, 192, 33, 33),
                                baseBarColor: Colors.grey,
                                bufferedBarColor: Colors.grey,
                                buffered: const Duration(milliseconds: 2000),
                                timeLabelTextStyle:
                                    const TextStyle(color: Colors.white),
                                onSeek: (duration) {
                                  Songstorage.player.seek(duration);
                                });
                          }),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              _isShuffle == false
                                  ? Songstorage.player
                                      .setShuffleModeEnabled(true)
                                  : Songstorage.player
                                      .setShuffleModeEnabled(false);
                            },
                            child: StreamBuilder(
                              stream:
                                  Songstorage.player.shuffleModeEnabledStream,
                              initialData: _isShuffle,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                _isShuffle = snapshot.data;
                                if (_isShuffle) {
                                  return const Icon(
                                    Icons.shuffle,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                  );
                                } else {
                                  return const Icon(
                                    Icons.shuffle,
                                    color: Colors.white,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              if (Songstorage.player.hasPrevious) {
                                await Songstorage.player.seekToPrevious();
                                await Songstorage.player.play();
                              } else {
                                await Songstorage.player.play();
                              }
                            },
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            clipBehavior: Clip.none,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              //primary: Colors.white
                            ),
                            onPressed: () async {
                              if (Songstorage.player.playing) {
                                await Songstorage.player.pause();
                                //setState(() {});
                              } else {
                                await Songstorage.player.play();
                                //setState(() {});
                              }
                            },
                            child: StreamBuilder<bool>(
                              stream: Songstorage.player.playingStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                bool? currentPlayingStatus = snapshot.data;
                                if (currentPlayingStatus != null &&
                                    currentPlayingStatus) {
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
                        Expanded(
                          child: IconButton(
                            onPressed: () async {
                              if (Songstorage.player.hasNext) {
                                await Songstorage.player.seekToNext();
                                await Songstorage.player.play();
                              } else {
                                await Songstorage.player.play();
                              }
                            },
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              if (Songstorage.player.loopMode == LoopMode.off) {
                                Songstorage.player.setLoopMode(LoopMode.one);
                              } else if (Songstorage.player.loopMode ==
                                  LoopMode.one) {
                                Songstorage.player.setLoopMode(LoopMode.all);
                              } else {
                                Songstorage.player.setLoopMode(LoopMode.off);
                              }
                            },
                            child: StreamBuilder(
                              stream: Songstorage.player.loopModeStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                final loopMode = snapshot.data;
                                if (LoopMode.one == loopMode) {
                                  return const Icon(
                                    Icons.repeat_one_rounded,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                  );
                                } else if (LoopMode.off == loopMode) {
                                  return const Icon(
                                    Icons.repeat_rounded,
                                    color: Colors.white,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.repeat_rounded,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    Songstorage.player.seek(duration);
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          Songstorage.player.positionStream,
          Songstorage.player.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));
}

class DurationState {
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
