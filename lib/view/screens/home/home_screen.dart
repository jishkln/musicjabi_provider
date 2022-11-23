import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider/home_provider.dart';
import 'package:musicrythum/controller/provider_db/favorite_db.dart';
import 'package:musicrythum/controller/provider/favorite_bttn.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';
import 'package:musicrythum/controller/widgets/text_widget.dart';
import 'package:musicrythum/controller/widgets/widget_apps.dart';
import 'package:musicrythum/view/screens/nowplay/play_screen.dart';
import 'package:musicrythum/view/screens/search/search.dart';
import 'package:on_audio_query/on_audio_query.dart'; 
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  static List<SongModel> allSongs = [];

  final _audioQuery = OnAudioQuery();

  @override
  @override
  Widget build(BuildContext context) {
    //final requstPermis = Provider.of<HomeScreen>(context, listen: false);
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).requestPermission();

      //  requstPermis;
    });
    return Scaffold(
      backgroundColor: WidgetApps.bckgrndColor,
      appBar: AppBar(
        backgroundColor: WidgetApps.appBarColor,
        //centerTitle: true,
        title: Text(
          'Music Jabi',
          style: TextStyles().titleStyle(
            sizeFont: 45,
            textGradiantColor1: const Color.fromARGB(255, 219, 93, 93),
            textGradiantColor2: const Color.fromARGB(169, 255, 255, 255),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchBar()));
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: ((context, value, child) => FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
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
                    child: Text("No songs Founf"),
                  );
                }

                HomeScreen.allSongs = item.data!;
                final provider =
                    Provider.of<FavoriteDB>(context, listen: false);
                if (!provider.isInitialized) {
                  provider.initialise(item.data!);
                }
                Songstorage.songCopy = item.data!;

                return SafeArea(
                  child: ListView(
                    //shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 15, top: 25),
                        child: Center(
                          child: Text(
                            'All Songs',
                            style: TextStyles().titleStyle(
                              sizeFont: 35,
                              textGradiantColor1:
                                  const Color.fromARGB(255, 142, 190, 150),
                              textGradiantColor2:
                                  const Color.fromARGB(169, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        itemExtent: 90,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: item.data!.length,
                        itemBuilder: (BuildContext context, allSongIndex) {
                          // Songstorage.currentIndexx = allSongIndex;
                          return Card(
                            child: ListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              leading: QueryArtworkWidget(
                                id: item.data![allSongIndex].id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: const CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                    'asset/images/Defaultimg.png',
                                  ),
                                ),
                              ),
                              title: Text(
                                item.data![allSongIndex].displayNameWOExt,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                item.data![allSongIndex].artist.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              trailing: FavoriteBtn(
                                  song: HomeScreen.allSongs[allSongIndex]),
                              onTap: () {
                                Songstorage.player.setAudioSource(
                                    Songstorage.createSongList(item.data!),
                                    initialIndex: allSongIndex);
                                Songstorage.player.play();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlayScreen(
                                      palySong: item.data!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
