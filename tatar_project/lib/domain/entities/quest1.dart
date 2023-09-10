import 'package:quest_peak/domain/models/quest_model.dart';

class Quest1 {
  final String name;
  final String description;
  final String imagePath;
  final List<Quest> places;

  Quest1({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.places,
  });
}
