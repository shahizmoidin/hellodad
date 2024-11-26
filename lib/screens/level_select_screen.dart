import 'package:flutter/material.dart';
import 'package:hello_dad/db_helper.dart';
import 'package:hello_dad/screens/debugging/debugging_level1.dart'; 
import 'package:hello_dad/screens/debugging/debugging_level2.dart';
import 'package:hello_dad/screens/debugging/debugging_level3.dart';
import 'package:hello_dad/screens/debugging/debugging_level4.dart';
import 'package:hello_dad/screens/debugging/debugging_level5.dart';

import 'package:hello_dad/screens/drag_and_drop/tech_tressures.dart';
import 'package:hello_dad/screens/quiz/quiz_screen.dart'; // Ensure this import points to your quiz screen
import 'package:hello_dad/screens/game_modes.dart';

class LevelSelectScreen extends StatefulWidget {
  final String mode;

  LevelSelectScreen({required this.mode});

  @override
  _LevelSelectScreenState createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  List<bool> levelUnlocked = [true, false, false, false, false];
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadLevelStatus();
  }

  _loadLevelStatus() async {
    List<Map<String, dynamic>> status = await dbHelper.getLevelStatus(widget.mode);
    setState(() {
      for (var entry in status) {
        levelUnlocked[entry['level'] - 1] = entry['status'] == 'unlocked';
      }
    });
  }

  _unlockNextLevel(int level) async {
    if (level < 5) {
      setState(() {
        levelUnlocked[level] = true;
      });
      await dbHelper.insertLevelStatus(widget.mode, level + 1, 'unlocked');
    }
  }

  _navigateToLevel(BuildContext context, int level) {
    Widget nextScreen;
    switch (level) {
      case 1:
        nextScreen = widget.mode == 'Tech Treasures'
            ? TechTreasures(level: level, mode: widget.mode, onLevelComplete: () => _unlockNextLevel(level))
            : widget.mode == 'Tech Trivia Time'
                ? TechTriviaLevel(level: level, onLevelComplete: () => _unlockNextLevel(level))
                : DebuggingLevel1(onLevelComplete: () => _unlockNextLevel(level), mode: 'Code Clinic');
        break;
      case 2:
        nextScreen = widget.mode == 'Tech Treasures'
            ? TechTreasures(level: level, mode: widget.mode, onLevelComplete: () => _unlockNextLevel(level))
            : widget.mode == 'Tech Trivia Time'
                ? TechTriviaLevel(level: level, onLevelComplete: () => _unlockNextLevel(level))
                : DebuggingLevel2(onLevelComplete: () => _unlockNextLevel(level), mode: 'Code Clinic');
        break;
      case 3:
        nextScreen = widget.mode == 'Tech Treasures'
            ? TechTreasures(level: level, mode: widget.mode, onLevelComplete: () => _unlockNextLevel(level))
            : widget.mode == 'Tech Trivia Time'
                ? TechTriviaLevel(level: level, onLevelComplete: () => _unlockNextLevel(level))
                : DebuggingLevel3(onLevelComplete: () => _unlockNextLevel(level), mode:'Code Clinic');
        break;
      case 4:
        nextScreen = widget.mode == 'Tech Treasures'
            ? TechTreasures(level: level, mode: widget.mode, onLevelComplete: () => _unlockNextLevel(level))
            : widget.mode == 'Tech Trivia Time'
                ? TechTriviaLevel(level: level, onLevelComplete: () => _unlockNextLevel(level))
                : DebuggingLevel4(onLevelComplete: () => _unlockNextLevel(level), mode: 'Code Clinic');
        break;
      case 5:
        nextScreen = widget.mode == 'Tech Treasures'
            ? TechTreasures(level: level, mode: widget.mode, onLevelComplete: () => _unlockNextLevel(level))
            : widget.mode == 'Tech Trivia Time'
                ? TechTriviaLevel(level: level, onLevelComplete: () => _unlockNextLevel(level))
                : DebuggingLevel5(onLevelComplete: () => _unlockNextLevel(level), mode: 'Code Clinic');
        break;
      default:
        nextScreen = DebuggingLevel1(onLevelComplete: () => _unlockNextLevel(level), mode: 'Code Clinic');
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/levelselect.jpg'), // Bluish-purple background
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Ensure center alignment
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: levelUnlocked[index]
                      ? () => _navigateToLevel(context, index + 1)
                      : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: levelUnlocked[index] ? Colors.blueAccent.withOpacity(0.7) : Colors.grey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: levelUnlocked[index] ? Colors.blueAccent : Colors.grey,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        width: 70, // Adjusted size to prevent overflow
                        height: 70, // Adjusted size to prevent overflow
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              levelUnlocked[index] ? Icons.lock_open : Icons.lock,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Courier', // Game-themed font
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.blueAccent,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GameModes()),
                );
              },
              iconSize: 50,
            ),
          ),
        ],
      ),
    );
  }
}
