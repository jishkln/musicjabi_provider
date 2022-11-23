import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider_db/favorite_db.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';
import 'package:musicrythum/controller/widgets/text_widget.dart';
import 'package:musicrythum/controller/widgets/widget_apps.dart';
import 'package:musicrythum/view/screens/nowplay/play_screen.dart'; 
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteScreeen extends StatelessWidget {
  const FavoriteScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FavoriteDB>(context, listen: false).notifi();
    });
    //final provider = Provider.of<FavoriteDB>(context);
    return Scaffold(
      backgroundColor: WidgetApps.bckgrndColor,
      body: SafeArea(
        child: Consumer<FavoriteDB>(
            builder: (BuildContext context, favorData, child) {
          return ListView(
            shrinkWrap: true,
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
                      image: AssetImage(WidgetApps().imgLib[4]),
                      fit: BoxFit.cover),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(150),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 160),
                      child: Text(
                        'Favorite',
                        style: TextStyles().titleStyle(
                          sizeFont: 60.00,
                          textGradiantColor1:
                              const Color.fromARGB(255, 3, 2, 2),
                          textGradiantColor2:
                              const Color.fromARGB(169, 11, 14, 7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              favorData.favorite.isEmpty
                  ? Center(
                      child: Column(
                      children: [
                        const SizedBox(
                          height: 70,
                        ),
                        Text('No favorites yet',
                            style: TextStyles().titleStyle(
                              sizeFont: 40,
                              textGradiantColor1:
                                  const Color.fromARGB(255, 244, 0, 0),
                              textGradiantColor2:
                                  const Color.fromARGB(169, 255, 255, 255),
                            )),
                      ],
                    ))
                  : ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                          Consumer<FavoriteDB>(
                            // valueListenable: FavoriteDB.favorite,
                            builder: (BuildContext ctx, value, Widget? child) {
                              return ListView.builder(
                                  itemExtent: 90,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (ctx, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 2),
                                      child: ListTile(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        tileColor: Colors.white,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 5),
                                        onTap: () {
                                          List<SongModel> newlist = [
                                            ...value.favorite
                                          ];

                                          Songstorage.player.pause();

                                          Songstorage.player.setAudioSource(
                                              Songstorage.createSongList(
                                                  newlist),
                                              initialIndex: index);
                                          Songstorage.player.play();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (ctx) => PlayScreen(
                                                palySong: value.favorite,
                                              ),
                                            ),
                                          );
                                        },
                                        leading: QueryArtworkWidget(
                                          id: value.favorite[index].id,
                                          type: ArtworkType.AUDIO,
                                          nullArtworkWidget: const CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                              'asset/images/Defaultimg.png',
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          value.favorite[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 15),
                                        ),
                                        subtitle: Text(
                                          value.favorite[index].artist!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              context.read();
                                              value.delete(
                                                  value.favorite[index].id);
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {});
                                              const snackBar = SnackBar(
                                                content: Text('Removed Song'),
                                                duration:
                                                    Duration(milliseconds: 190),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            },
                                            icon: const Icon(
                                              Icons.heart_broken_sharp,
                                              size: 30,
                                              color: Colors.red,
                                            )),
                                      ),
                                    );
                                  },
                                  itemCount: value.favorite.length);
                            },
                          ),
                        ]),
            ],
          );
        }),
      ),
    );
    // });
  }
}
