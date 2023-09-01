import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import 'package:quest_peak/domain/models/quest_model.dart';

class QuestFetcher {
  static late Future<List<Quest>> quests;

  static void fetch() async {
    quests = _fetchFirebase();
  }

  static void addQuest(Quest quest) {
    quests.then((list) async {
      list.add(quest);
      final ref = FirebaseDatabase.instance.ref("/");
      List<Map<String, dynamic>> data = [];
      for (int i = 0; i < list.length; i++) {
        Map<String, dynamic> mp = {
          "name": list[i].name,
          "description": list[i].description,
          "question": list[i].question,
          "answer": list[i].answer,
          "latitude": list[i].latitude,
          "longitude": list[i].longitude,
          "imagePath": list[i].imagePath,
          "colors": fromListQuestColor(list[i].colors)
        };
        data.add(mp);
      }
      await ref.set(data);
    });
  }

  static Future<List<Quest>> _fetchFirebase() async {
    List<Quest> quests = [];
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('/').get();

    final List<dynamic> list = snapshot.value as List<dynamic>;
    for (int i = 0; i < list.length; i++) {
      Map<String, dynamic> object = Map<String, dynamic>.from(list[i]!);
      quests.add(Quest(
          object['name']!,
          object['description']!,
          object['question']!,
          object['answer']!,
          object['latitude']!,
          object['longitude']!,
          object['imagePath']!,
          toListQuestColor(object['colors']!.cast<String>())));
    }
    return quests;
  }

  // Deprecated
  // This function fetches data from github repo
  // ignore: unused_element
  static Future<List<Quest>> _fetchGithub() async {
    final response = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/Amirka-Kh/QuestPeaker/main/api/quests.json'));
    if (response.statusCode == 200) {
      List<Quest> quests = [];
      final List<Map<String, dynamic>> list =
          json.decode(response.body).cast<Map<String, dynamic>>();
      for (int i = 0; i < list.length; i++) {
        quests.add(Quest(
            list[i]['name'],
            list[i]['description'],
            list[i]['question'],
            list[i]['answer'],
            list[i]['latitude'],
            list[i]['longitude'],
            list[i]['imagePath'],
            toListQuestColor(list[i]['colors'].cast<String>())));
      }
      return quests;
    } else {
      throw Exception("Could not retrieve data");
    }
  }
}
