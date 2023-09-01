import 'package:hive_flutter/hive_flutter.dart';
import 'package:quest_peak/domain/models/quest_model.dart';

class QuestSavedTracker {
  static const boxName = 'questsSaved';
  static late Future<List<Quest>> quests;

  static void fetch() async {
    quests = () async {
      var box = await Hive.openBox<List>(boxName);
      return box.get('list', defaultValue: <Quest>[])!.cast<Quest>();
    }();
  }

  static void store() async {
    var box = await Hive.openBox<List>(boxName);
    await quests.then((list) {
      box.put('list', list);
    });
  }

  static Future<Quest> getQuest(int n) async {
    late Quest quest;
    await quests.then((list) {
      if (n < list.length) {
        quest = list[n];
      } else {
        throw 'List index out of range';
      }
    });
    return quest;
  }

  static Future<bool> addQuest(Quest quest) async {
    bool result = true;
    await quests.then((list) {
      for (Quest quest2 in list) {
        if (quest.name == quest2.name) {
          quest2 = quest;
          result = false;
        }
      }
      if (result) {
        list.add(quest);
        store();
      }
    });
    return result;
  }

  static Future<bool> containQuest(Quest quest) async {
    bool result = false;
    await quests.then((list) {
      for (Quest quest2 in list) {
        if (quest.name == quest2.name) {
          result = true;
        }
      }
    });
    return result;
  }

  static Future<List<Quest>> getQuests() async {
    return quests;
  }

  static Future<bool> deleteQuest(Quest quest) async {
    bool result = true;
    await quests.then((list) {
      int n = -1;
      for (int i = 0; i < list.length; i++) {
        if (quest.name == list[i].name) {
          n = i;
          break;
        }
      }
      if (n == -1) {
        result = false;
        return;
      }
      if (n < list.length) {
        for (int i = n; i + 1 < list.length; i++) {
          list[i] = list[i + 1];
        }
        list.removeLast();
        store();
      }
    });
    return result;
  }

  static void delete() async {
    var box = await Hive.openBox<List>(boxName);
    box.clear();
    await quests.then((list) {
      list.clear();
    });
  }
}
