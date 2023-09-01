import 'package:flutter_riverpod/flutter_riverpod.dart';

final questSolvedProvider = StateNotifierProvider<QuestSolvedClass, bool>(
    (ref) => QuestSolvedClass(true));

class QuestSolvedClass extends StateNotifier<bool> {
  QuestSolvedClass(super.state);

  void set(bool s) {
    state = s;
  }
}
