import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/config/app_locale_extension.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';
import 'package:quest_peak/pages/quest_page/quest_page.dart';

import '../../../domain/entities/quest1.dart';

class QuestCard extends ConsumerWidget {
  const QuestCard({
    super.key,
    required this.quest,
    required this.pageController,
    required this.currentPage,
  });

  final Quest1 quest;
  final PageController pageController;
  final int currentPage;

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
              return QuestPage(quest: quest);
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
              // Align(
              //   alignment: const Alignment(0.65, 0.7),
              //   child: IsSolvedWidget(quest: quest),
              // ),
              // Align(
              //   alignment: const Alignment(0.65, 0.95),
              //   child: SaveToFavouritesWidget(quest: quest),
              // ),
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
                      context.locale.learnMore,
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
