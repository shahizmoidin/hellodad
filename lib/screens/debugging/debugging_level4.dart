import 'package:flutter/material.dart';
import 'package:hello_dad/audio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_dad/screens/debugging/debugging_level5.dart';
import 'package:hello_dad/screens/level_select_screen.dart';

class DebuggingLevel4 extends ConsumerStatefulWidget {
  final VoidCallback onLevelComplete;
  final String mode;

  DebuggingLevel4({required this.onLevelComplete, required this.mode});

  @override
  _DebuggingLevel4State createState() => _DebuggingLevel4State();
}

class _DebuggingLevel4State extends ConsumerState<DebuggingLevel4> {
  final String brokenCode = '''void main() {
    List<String> fruits = ['apple', 'banana', 'cherry'];
    print('First fruit: ' + fruits[1]);
    Map<String, int> ages = {'Alice': 25, 'Bob': 30, 'Charlie': 35};
    print("Bob's age: " + ages['Bob'].toString());
    for (int i = 0; i < fruits.length; i++) {
      print(fruits[i]);
    }
    if (ages.containsKey('Alice')) {
      print('Alice is ' + ages['Alice'].toString() + ' years old');
    }
  }''';
  
  final List<String> bugs = [
    "Incorrect list indexing",
    "Missing escape character in string",
    "Off-by-one error in for loop"
  ];
  final Set<String> correctBugs = {
    "Incorrect list indexing",
    "Missing escape character in string",
    "Off-by-one error in for loop"
  };
  final Map<String, bool> userSelections = {};

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
         
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Level 4: Identify the Bugs',
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
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
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
                              brokenCode,
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
                            value: userSelections[bug] ?? false,
                            onChanged: (value) {
                              setState(() {
                                userSelections[bug] = value!;
                              });
                            },
                          );
                        }).toList(),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final selectedBugs = userSelections.keys
                                .where((key) => userSelections[key] == true)
                                .toSet();
                            if (selectedBugs.containsAll(correctBugs) && correctBugs.containsAll(selectedBugs)) {
                              audioHelper.playSFX('success.flac');
                              widget.onLevelComplete();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => DebuggingLevel5(onLevelComplete: widget.onLevelComplete, mode: widget.mode)),
                              );
                            } else {
                              audioHelper.playSFX('error_click.mp3');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try Again!')));
                            }
                          },
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
