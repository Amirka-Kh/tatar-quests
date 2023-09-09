import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/config/app_locale_extension.dart';
import 'package:quest_peak/config/string.dart';

import '../../domain/models/quest_model.dart';
import '../../domain/providers/quest_provider.dart';
import '../../domain/providers/style_provider.dart';
import '../../domain/trackers/quest_solved_tracker.dart';

class PlacePageQ extends ConsumerStatefulWidget {
  const PlacePageQ({
    super.key,
    required this.quest,
  });

  final Quest quest;

  @override
  ConsumerState<PlacePageQ> createState() => _PlacePageQState();
}

class _PlacePageQState extends ConsumerState<PlacePageQ> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 34,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.quest.name,
                        style: appTheme.heading(),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        widget.quest.question,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            hintText: 'жавап куегыз',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (checkAnswer(
                                widget.quest.answer, _controller.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Text(
                                    context.locale.correctAnswer,
                                  ),
                                ),
                              );
                              QuestSolvedTracker.addQuest(widget.quest);
                              ref.watch(questSolvedProvider.notifier).set(
                                    !ref.watch(
                                      questSolvedProvider,
                                    ),
                                  );
                              Navigator.of(context).popUntil(
                                    (route) => route.isFirst,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Text(
                                    context.locale.incorrectAnswer,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'тикшерү',
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceDescription extends ConsumerWidget {
  const _PlaceDescription({
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
            quest.question,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: 'жавап куегыз',
              ),
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'тикшерү',
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
