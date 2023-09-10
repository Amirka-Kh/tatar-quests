import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/config/quest_geolocator.dart';
import 'package:quest_peak/pages/place_page/place_page_q.dart';

import '../../domain/models/quest_model.dart';
import '../../domain/providers/style_provider.dart';

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
  late double latitude;
  late double longitude;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _startLocationListening();
  }


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> _startLocationListening() async {
    await QuestGeolocator.requestAccessPermission();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      final position = await QuestGeolocator.getPosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
  }

  Future<void> _updateLocation(BuildContext context) async {
    await QuestGeolocator.requestAccessPermission();
    final position = await QuestGeolocator.getPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
    print('latitude: $latitude\nlongitude: $longitude');
    if (QuestGeolocator.distanceLess(
        latitude, longitude, widget.quest.latitude, widget.quest.longitude, 500000)) {
      print('true');
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlacePageQ(
              quest: widget.quest,
            ),
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    timer.cancel();
    return true;
  }


  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
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
              builder: (context, controller) =>
                  Container(
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
                              widget.quest.description,
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
                                onPressed: () async {
                                  // TODO - distance less number
                                  if (QuestGeolocator.distanceLess(
                                      latitude, longitude, widget.quest.latitude, widget.quest.longitude, 50000000)) {
                                    if (context.mounted) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => PlacePageQ(
                                            quest: widget.quest,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PlacePageQ(
                          quest: quest,
                        ),
                  ),
                );
              },
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
