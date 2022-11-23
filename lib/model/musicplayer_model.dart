import 'package:hive/hive.dart';
part 'musicplayer_model.g.dart';

@HiveType(typeId: 1)
class MusicPlayeerModel extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final List<int> songsId;

  MusicPlayeerModel({required this.songsId, required this.name});
  add(int id) async {
    songsId.add(id);
    save();
  }

  deleteData(int id) {
    songsId.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songsId.contains(id);
  }

  bool isNameIn(String plylstnme) {
    return name.contains(plylstnme);
  }
}
