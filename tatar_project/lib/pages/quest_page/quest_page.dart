import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/domain/entities/quest1.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';

class QuestPage extends ConsumerWidget {
  const QuestPage({
    super.key,
    required this.quest,
  });

  final Quest1 quest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(quest.imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: QuestDescription(
            quest: quest,
          ),
        ),
      ),
    );
  }
}

class QuestDescription extends ConsumerWidget {
  const QuestDescription({
    super.key,
    required this.quest,
  });

  final Quest1 quest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 34,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quest.name,
            style: appTheme.heading().copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            quest.description,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 28,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Башлау',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
