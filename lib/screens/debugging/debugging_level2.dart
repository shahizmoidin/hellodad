import 'package:flutter/material.dart';
import 'package:hello_dad/audio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_dad/screens/debugging/debugging_level3.dart';
import 'package:hello_dad/screens/level_select_screen.dart';
import 'dart:async';

class DebuggingLevel2 extends ConsumerStatefulWidget {
  final VoidCallback onLevelComplete;
  final String mode;

  DebuggingLevel2({required this.onLevelComplete, required this.mode});

  @override
  _DebuggingLevel2State createState() => _DebuggingLevel2State();
}

class _DebuggingLevel2State extends ConsumerState<DebuggingLevel2> {
  final List<String> codeParts = [
    "int a = 5;", 
    "int b = 10;", 
    "int sum = a + b;", 
    "print('Sum: ' + sum.toString());"
  ];
  final List<String> correctOrder = [
    "int a = 5;", 
    "int b = 10;", 
    "int sum = a + b;", 
    "print('Sum: ' + sum.toString());"
  ];
  final List<String> userOrder = [];
  late Timer shuffleTimer;

  @override
  void initState() {
    super.initState();
    startShuffling();
  }

  @override
  void dispose() {
    shuffleTimer.cancel();
    super.dispose();
  }

  void startShuffling() {
    shuffleTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        codeParts.shuffle();
      });
    });
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
         
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Level 2: Arrange the Code',
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
                          'Arrange the code blocks to form a working code:',
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
                        SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: codeParts.map((part) {
                            return Draggable<String>(
                              data: part,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                color: Colors.blueAccent,
                                child: Text(part, style: TextStyle(color: Colors.white)),
                              ),
                              feedback: Container(
                                padding: EdgeInsets.all(8.0),
                                color: Colors.blueAccent,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(part, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              childWhenDragging: Container(),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        DragTarget<String>(
                          onAccept: (part) {
                            setState(() {
                              userOrder.add(part);
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: ListView.builder(
                                itemCount: userOrder.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(userOrder[index]),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: userOrder.length == correctOrder.length
                              ? () {
                                  if (userOrder.toString() == correctOrder.toString()) {
                                    audioHelper.playSFX('success.flac');
                                    widget.onLevelComplete();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => DebuggingLevel3(onLevelComplete: widget.onLevelComplete, mode: widget.mode)),
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
