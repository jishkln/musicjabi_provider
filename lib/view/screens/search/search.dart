import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider/search_provider.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';
import 'package:musicrythum/controller/widgets/widget_apps.dart';
import 'package:musicrythum/view/screens/home/home_screen.dart';
import 'package:musicrythum/view/screens/nowplay/play_screen.dart';
 
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

//ValueNotifier<List<SongModel>> temp = ValueNotifier([]);

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context, listen: false);
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
        backgroundColor: WidgetApps.bckgrndColor,
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 90,
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: WidgetApps.bckgrndColor,
          title: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (String? value) {
                  provider.searchFile(value);
                }),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16, top: 10),
              child: Column(
                children: [
                  Consumer<SearchProvider>(
                      builder: (BuildContext context, value, child) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final data = value.temp[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              tileColor: Colors.white,
                              leading: QueryArtworkWidget(
                                  nullArtworkWidget:
                                      const Icon(Icons.music_note),
                                  artworkFit: BoxFit.cover,
                                  id: data.id,
                                  type: ArtworkType.AUDIO),
                              title: Text(
                                data.title,
                                style: const TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(data.genre.toString()),
                              onTap: () {
                                final searchIndex = creatSearchIndex(data);
                                FocusScope.of(context).unfocus();
                                Songstorage.player.setAudioSource(
                                    Songstorage.createSongList(
                                        HomeScreen.allSongs),
                                    initialIndex: searchIndex);
                                Songstorage.player.play();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => PlayScreen(
                                        palySong: HomeScreen.allSongs),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        itemCount: value.temp.length);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int? creatSearchIndex(SongModel data) {
    for (int i = 0; i < HomeScreen.allSongs.length; i++) {
      if (data.id == HomeScreen.allSongs[i].id) {
        return i;
      }
    }
    return null;
  }
}
