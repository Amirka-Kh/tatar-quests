import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/quest_model.dart';
import '../../../domain/providers/style_provider.dart';

class PlacePage extends ConsumerStatefulWidget {
  const PlacePage({
    super.key,
    required this.quest,
  });

  final Quest quest;

  @override
  ConsumerState<PlacePage> createState() => _QuestPageState();
}

class _QuestPageState extends ConsumerState<PlacePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.quest.imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: DraggableScrollableSheet(
            // minChildSize: ,
            initialChildSize: 0.4,
            builder: (context, controller) => Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                controller: controller,
                child: PlaceDescription(
                  quest: widget.quest,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceDescription extends ConsumerWidget {
  const PlaceDescription({
    super.key,
    required this.quest,
  });

  final Quest quest;

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
            style: appTheme.heading(),
          ),
          const SizedBox(
            height: 18,
          ),
          Text(
            quest.description,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'Мин шундамы ?',
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
                backgroundColor: const Color(0xFF84B78F),
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
