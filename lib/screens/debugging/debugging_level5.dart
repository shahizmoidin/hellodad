import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:hello_dad/screens/level_select_screen.dart';
import 'package:hello_dad/screens/victory_screen.dart';

class DebuggingLevel5 extends ConsumerStatefulWidget {
  final VoidCallback onLevelComplete;
  final String mode;

  DebuggingLevel5({required this.onLevelComplete, required this.mode});

  @override
  _DebuggingLevel5State createState() => _DebuggingLevel5State();
}

class _DebuggingLevel5State extends ConsumerState<DebuggingLevel5> {
  final List<String> codeSnippets = [
    '''void main() { print('Hello World') }''',
    '''int multiply(int a, int b) { return a * b }''',
    '''List<int> numbers = [1, 2, 3, 4, 5]; print(numbers[5]);'''
  ];
  final List<String> correctFixes = [
    '''void main() { print('Hello World'); }''',
    '''int multiply(int a, int b) { return a * b; }''',
    '''List<int> numbers = [1, 2, 3, 4, 5]; print(numbers[4]);'''
  ];

  final TextEditingController controller = TextEditingController();
  int currentSnippet = 0;
  int score = 0;
  late Timer timer;
  int timeRemaining = 60; // 60 seconds timer
  late AudioPlayer backgroundMusicPlayer;
  late AudioPlayer sfxPlayer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeRemaining > 0) {
          timeRemaining--;
        } else {
          timer.cancel();
          showGameOverDialog();
        }
      });
    });
  }

  void checkAnswer() {
    if (controller.text.trim() == correctFixes[currentSnippet].trim()) {
      score++;
      sfxPlayer.play(AssetSource('assets/audio/correct_answer.mp3'));
      if (currentSnippet < codeSnippets.length - 1) {
        setState(() {
          currentSnippet++;
          controller.clear();
          timeRemaining = 60; // Reset timer for next snippet
        });
      } else {
        backgroundMusicPlayer.stop();
        sfxPlayer.play(AssetSource('assets/audio/level_complete.mp3'));
        showGameOverDialog();
      }
    } else {
      sfxPlayer.play(AssetSource('assets/audio/wrong_answer.mp3'));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try Again!')));
    }
  }

  void showGameOverDialog() {
  if (score == codeSnippets.length) {
    // The player has completed all snippets correctly.
    backgroundMusicPlayer.stop();
    sfxPlayer.play(AssetSource('assets/audio/level_complete.mp3'));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Level Complete'),
        content: Text('Your score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              widget.onLevelComplete();
              Navigator.of(context).pop();
              if (widget.mode == 'Code Clinic') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VictoryScreen()),
                );
              }
            },
            child: Text('Next Level'),
          ),
        ],
      ),
    );
  } else {
    // The player has not completed all snippets, show game over dialog.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your score: $score\nTry again to complete all snippets!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetLevel();
            },
            child: Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: widget.mode)),
              );
            },
            child: Text('Exit to Levels'),
          ),
        ],
      ),
    );
  }
}
// Function to reset level progress
void resetLevel() {
  setState(() {
    score = 0;
    currentSnippet = 0;
    timeRemaining = getTimeLimitForLevel();
    controller.clear();
    startTimer();
  });
}

  @override
  void initState() {
    super.initState();
    timeRemaining = getTimeLimitForLevel();
    backgroundMusicPlayer = AudioPlayer();
    sfxPlayer = AudioPlayer();
    backgroundMusicPlayer.play(AssetSource('assets/audio/debugging.mp3'));
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    backgroundMusicPlayer.stop();
    sfxPlayer.dispose();
    super.dispose();
  }

  int getTimeLimitForLevel() {
    return 60; // Fixed time limit for debugging levels
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
       backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
          onPressed: () {
            backgroundMusicPlayer.stop();
            sfxPlayer.play(AssetSource('assets/audio/button_click.mp3'));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: widget.mode)),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/debugging_bg.jpg'), // Use a suitable background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Level 5: Fix the Code',
                    style: TextStyle(
                      fontSize: 32,
                      color: Color(0xFFFFF176), // Yellow text
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier Prime',
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Color(0xFFC1FF72),
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Fix the code below (time remaining: $timeRemaining seconds):',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFF176), // Yellow text
                            fontFamily: 'Courier Prime',
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Color(0xFFC1FF72),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              codeSnippets[currentSnippet],
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Courier Prime',
                                color: Color(0xFFC1FF72),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: controller,
                          maxLines: 10,
                          decoration: InputDecoration(
                            labelText: 'Your Solution',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Color(0xFFFFF176)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFF176)),
                            ),
                          ),
                          style: TextStyle(fontFamily: 'Courier Prime', color: Color(0xFFFFF176)),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: checkAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFF176), // Yellow button
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Courier Prime'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
