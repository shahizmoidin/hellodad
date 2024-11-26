import 'package:flutter/material.dart';
import 'package:hello_dad/audio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_dad/screens/debugging/debugging_level2.dart';
import 'package:hello_dad/screens/level_select_screen.dart';

class DebuggingLevel1 extends ConsumerStatefulWidget {
  final VoidCallback onLevelComplete;
  final String mode;

  DebuggingLevel1({required this.onLevelComplete, required this.mode});

  @override
  _DebuggingLevel1State createState() => _DebuggingLevel1State();
}

class _DebuggingLevel1State extends ConsumerState<DebuggingLevel1> {
  final List<String> bugs = ["Missing semicolon", "Incorrect variable name", "Logic error"];
  final List<String> correctBugs = ["Missing semicolon", "Incorrect variable name"];
  final Map<String, bool> userSelections = {};

  @override
  void initState() {
    super.initState();
    for (var bug in bugs) {
      userSelections[bug] = false;
    }
  }

  bool areEqual(List<String> list1, List<String> list2) {
    list1.sort();
    list2.sort();
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final audioHelper = ref.read(audioProvider);
    audioHelper.playMusic('debugging.mp3'); // Play background music

    return Scaffold(
     extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
          onPressed: () {
            audioHelper.stopMusic();
            audioHelper.playSFX('button_click.wav');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: 'Code Clinic')),
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
                    'Level 1: Find the Bugs',
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
                          'Identify the bugs in the following code:',
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
                              '''
void main() {
  int a = 5;
  int b = 10;
  int sum = a + b;
  prnt('Sum: ' + sum.toString());
}
''',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Courier Prime',
                                color: Color(0xFFC1FF72),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ...bugs.map((bug) {
                          return CheckboxListTile(
                            title: Text(
                              bug,
                              style: TextStyle(
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
                            value: userSelections[bug],
                            onChanged: (value) {
                              setState(() {
                                userSelections[bug] = value!;
                              });
                            },
                          );
                        }).toList(),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: userSelections.containsValue(true)
                              ? () {
                                  final selectedBugs = userSelections.entries
                                      .where((entry) => entry.value)
                                      .map((entry) => entry.key)
                                      .toList();
                                  if (areEqual(selectedBugs, correctBugs)) {
                                    audioHelper.playSFX('success.flac');
                                    widget.onLevelComplete();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => DebuggingLevel2(onLevelComplete: widget.onLevelComplete, mode: widget.mode)),
                                    );
                                  } else {
                                    audioHelper.playSFX('error_click.mp3');
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try Again!')));
                                  }
                                }
                              : null,
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
