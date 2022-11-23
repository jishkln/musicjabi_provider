import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicrythum/controller/provider/bottum_navi_provider.dart';
import 'package:musicrythum/controller/provider/home_provider.dart';
import 'package:musicrythum/controller/provider/playscreen_provider.dart';
import 'package:musicrythum/controller/provider/search_provider.dart';
import 'package:musicrythum/controller/provider/splash_provider.dart';
import 'package:musicrythum/controller/provider_db/favorite_db.dart';
import 'package:musicrythum/controller/provider_db/play_list_db.dart';
import 'package:musicrythum/model/musicplayer_model.dart';
import 'package:musicrythum/view/screens/splashscreen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(MusicPlayeerModelAdapter().typeId)) {
    Hive.registerAdapter(MusicPlayeerModelAdapter());
  }

  await Hive.openBox<int>('favoriteDB');
  await Hive.openBox<MusicPlayeerModel>('playListDB');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/ic_launcher',
    preloadArtwork: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SplashScreanProvider(),
        ),
         ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlayScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottumNaviProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoriteDB(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlayListDB(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Jabi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
