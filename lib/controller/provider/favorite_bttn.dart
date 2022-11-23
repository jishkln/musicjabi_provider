import 'package:flutter/material.dart';
import 'package:musicrythum/controller/provider_db/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteBtn extends StatelessWidget {
  const FavoriteBtn({
    Key? key,
    required this.song,
  }) : super(key: key);
  final SongModel song;
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteDB>(
      builder: (BuildContext context, favordata, child) {
        return IconButton(
          onPressed: () {
            if (favordata.isFavorate(song)) {
              favordata.delete(song.id);
              // Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
              context.read();
              const snackBar = SnackBar(
                content: Text('Removed Song'),
                duration: Duration(milliseconds: 190),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              // Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
              context.read();
            } else {
              favordata.add(song);
              context.read();
              const snackBar = SnackBar(
                content: Text('Added Song'),
                duration: Duration(milliseconds: 190),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //Provider.of<FavoriteDB>(context, listen: false).notifyListeners();
              context.read();
            }

            context.read();
          },
          icon: favordata.isFavorate(song)
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(Icons.favorite, color: Colors.grey),
        );
      },
    );
  }
}
