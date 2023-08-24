import 'package:hive_flutter/hive_flutter.dart';

class ServiceLocalStorage {
  late Box userPrefBox;

  Future<void> init() async {
    userPrefBox = await Hive.openBox('userPrefBox');
  }

  int getLevelsCompleted() {
    return userPrefBox.get('levelsCompleted', defaultValue: 0);
  }

  void setLevelsCompleted(int levelsCompleted) {
    userPrefBox.put('levelsCompleted', levelsCompleted);
  }
}
