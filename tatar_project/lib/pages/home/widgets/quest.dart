import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/domain/models/quest_model.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';
import 'package:quest_peak/pages/home/widgets/is_solved.dart';
import 'package:quest_peak/pages/place_page/place_page.dart';
import 'package:quest_peak/pages/home/widgets/to_favorite_button.dart';
// import 'package:quest_peak/config/styles.dart';

// ignore: must_be_immutable
class QuestWidget extends ConsumerWidget {
  late Quest quest;
  late PageController pageController;
  late int currentPage;

  QuestWidget(
      {super.key,
      required this.quest,
      required this.pageController,
      required this.currentPage});

  // user will interact with a widget, thus Gesture detection is needed
  // for this purposes InkWell is used since it  shows a visual indication
  // that the touch was received, while in GestureDetector this should be implemented
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final appTheme = ref.watch(themeProvider);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, _, __) {
              // return QuestDetailsWidget(quest: quest);
              return PlacePage(quest: quest);
            },
          ),
        );
      },
      child: AnimatedBuilder(
        animation: pageController,
        builder: (context, child) {
          double value = 1;
          if (pageController.position.haveDimensions) {
            value = pageController.page! - currentPage;
            value = (1 - (value.abs() * 0.6)).clamp(0.0, 1.0);
          }

          return Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Hero(
                    tag: "background-${quest.name}",
                    child: Image.asset(
                      quest.imagePath,
                      height: screenHeight * 0.5 * value,
                      width: screenWidth * 0.75 * value,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.65, 0.7),
                child: IsSolvedWidget(quest: quest),
              ),
              Align(
                alignment: const Alignment(0.65, 0.95),
                child: SaveToFavouritesWidget(quest: quest),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 58, right: 36, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        quest.name,
                        style: appTheme.headingWhite(),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.learnMore,
                      style: appTheme.subHeadingWhite(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
