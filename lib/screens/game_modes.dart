import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_dad/audio_provider.dart';
import 'main_menu.dart';
import 'level_select_screen.dart'; // Ensure to import Level Select Screen

class GameModes extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHelper = ref.watch(audioProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gamemodeselect.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GameModeButton(
                      imagePath: 'assets/images/dragdrop.png',
                      text: 'Tech Treasures',
                      onPressed: () {
                        audioHelper.playSFX('button_click.wav');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: 'Tech Treasures')),
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    GameModeButton(
                      imagePath: 'assets/images/debug.png',
                      text: 'Code Clinic',
                      onPressed: () {
                        audioHelper.playSFX('button_click.wav');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: 'Code Clinic')),
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    GameModeButton(
                      imagePath: 'assets/images/quiz.png',
                      text: 'Tech Trivia Time',
                      onPressed: () {
                        audioHelper.playSFX('button_click.wav');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: 'Tech Trivia Time')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                audioHelper.playSFX('button_click.wav');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainMenu()),
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

class GameModeButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  GameModeButton({required this.imagePath, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Courier',
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.blueAccent,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
