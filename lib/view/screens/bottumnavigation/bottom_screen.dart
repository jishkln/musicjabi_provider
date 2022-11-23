import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider/bottum_navi_provider.dart';
import 'package:musicrythum/controller/widgets/song_storage.dart';
import 'package:musicrythum/view/screens/favorite/favorite_screeen.dart';
import 'package:musicrythum/view/screens/home/home_screen.dart';
import 'package:musicrythum/view/screens/mini_player/mini_player.dart';
import 'package:musicrythum/view/screens/playlist/playlist_folders.dart';
import 'package:musicrythum/view/screens/settings/settings.dart';
import 'package:provider/provider.dart';

class BottumScreen extends StatelessWidget {
  BottumScreen({Key? key}) : super(key: key);

  

  final bottumScreen = [
    HomeScreen(),
    const FavoriteScreeen(),
    PlayListFolder(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    final currentIndex = Provider.of<BottumNaviProvider>(context).getIndex;
    //  final botumPro = Provider.of<BottumNaviProvider>(context);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Scaffold(
        body: IndexedStack(index: currentIndex, children: bottumScreen),
        bottomNavigationBar: Consumer<BottumNaviProvider>(
          builder: (BuildContext context, btumNavi, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (Songstorage.player.playing) ||
                        (Songstorage.player.currentIndex != null)
                    ? const MiniPlayer()
                    : const SizedBox(),
                Theme(
                  data: Theme.of(context).copyWith(
                      canvasColor: Colors.black,
                      primaryColor: Colors.red,
                      textTheme: Theme.of(context).textTheme.copyWith(
                          caption: const TextStyle(color: Colors.yellow))),
                  child: BottomNavigationBar(
                    fixedColor: Colors.red,
                    elevation: 0,
                    unselectedIconTheme:
                        const IconThemeData(color: Colors.white),
                    selectedIconTheme: const IconThemeData(color: Colors.red),
                    // backgroundColor: Colors.blue,
                    type: BottomNavigationBarType.fixed,
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: "Home",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: "Fevorite",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        label: "PlayList",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: "Settings",
                      ),
                    ],
                    currentIndex: currentIndex,

                    onTap: (index) {
                      btumNavi.setIndex = index;
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
