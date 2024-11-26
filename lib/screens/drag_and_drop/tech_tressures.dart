import 'package:flutter/material.dart';
import 'package:hello_dad/audio_provider.dart';
import 'package:hello_dad/db_helper.dart';
import 'package:hello_dad/screens/drag_and_drop/models/level_model.dart';
import 'package:hello_dad/screens/level_select_screen.dart';
import 'package:hello_dad/screens/victory_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class TechTreasures extends ConsumerStatefulWidget {
  final int level;
  final String mode;
  final VoidCallback onLevelComplete;

  TechTreasures({required this.level, required this.mode, required this.onLevelComplete});

  @override
  _TechTreasuresState createState() => _TechTreasuresState();
}

class _TechTreasuresState extends ConsumerState<TechTreasures> {
  Map<String, bool> matches = {};
  bool levelCompleted = false;
  DatabaseHelper dbHelper = DatabaseHelper();
  late Timer shuffleTimer;
  late int shuffleInterval;

  @override
  void initState() {
    super.initState();
    matches = {for (var item in levels[widget.level - 1].itemNames) item: false};
    shuffleInterval = 3000 ~/ widget.level; // Faster shuffle at higher levels
    startShuffling();
    final audioHelper = ref.read(audioProvider);
    audioHelper.playMusic('drag-drop.mp3');
  }

  void startShuffling() {
    shuffleTimer = Timer.periodic(Duration(milliseconds: shuffleInterval), (timer) {
      setState(() {
        levels[widget.level - 1].itemNames.shuffle();
      });
    });
  }

  @override
  void dispose() {
    shuffleTimer.cancel();
    super.dispose();
  }

  void checkCompletion() {
    if (matches.values.every((matched) => matched)) {
      final audioHelper = ref.read(audioProvider);
      audioHelper.playSFX('success.flac');
      setState(() {
        levelCompleted = true;
      });
      widget.onLevelComplete();
      _unlockNextLevel(widget.level);
    }
  }

  Future<void> _unlockNextLevel(int level) async {
    if (level < 5) {
      await dbHelper.insertLevelStatus(widget.mode, level + 1, 'unlocked');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TechTreasures(level: level + 1, mode: widget.mode, onLevelComplete: widget.onLevelComplete)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VictoryScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> itemNames = levels[widget.level - 1].itemNames;
    List<String> itemImages = levels[widget.level - 1].itemImages;
    final audioHelper = ref.watch(audioProvider);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dragdroplevels.png'), // Add a nice background
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
                  onPressed: () {
                    audioHelper.stopMusic();
                    audioHelper.playSFX('button_click.wav');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: widget.mode)),
                    );
                  },
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Level ${widget.level}',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.blueAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100), // Adjust height for spacing
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: itemNames.map((name) {
                            return DragTarget<String>(
                              onAccept: (image) {
                                if (image == name.toLowerCase().replaceAll(' ', '_')) {
                                  setState(() {
                                    matches[name] = true;
                                  });
                                  audioHelper.playSFX('correct_click.wav');
                                  checkCompletion();
                                } else {
                                  audioHelper.playSFX('error_click.mp3');
                                }
                              },
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: matches[name]! ? Colors.green : Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                    color: matches[name]! ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.blueAccent,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: itemImages.map((image) {
                            return Draggable<String>(
                              data: image.split('.').first, // Use image name without extension
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/$image',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              feedback: Material(
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue, width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      'assets/images/$image',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/images/$image',
                                    color: Colors.grey,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
