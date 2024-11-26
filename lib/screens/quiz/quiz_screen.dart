import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:hello_dad/audio_provider.dart';
import 'package:hello_dad/screens/level_select_screen.dart';
import 'package:hello_dad/screens/victory_screen.dart';

class TechTriviaLevel extends ConsumerStatefulWidget {
  final int level;
  final VoidCallback onLevelComplete;

  TechTriviaLevel({required this.level, required this.onLevelComplete});

  @override
  _TechTriviaLevelState createState() => _TechTriviaLevelState();
}

class _TechTriviaLevelState extends ConsumerState<TechTriviaLevel> {
  late Timer timer;
  int timeRemaining = 30;
  int questionIndex = 0;
  bool allCorrect = true;
  final AudioPlayer audioPlayer = AudioPlayer();

  final List<List<Map<String, dynamic>>> questionsByLevel = [
    [
  {
    "question": "What does CPU stand for?",
    "options": ["Central Processing Unit", "Computer Personal Unit", "Central Processor Unit", "Central Process Unit"],
    "answer": "Central Processing Unit"
  },
  {
    "question": "What is RAM short for?",
    "options": ["Random Access Memory", "Readily Accessible Memory", "Run Access Memory", "Read Access Memory"],
    "answer": "Random Access Memory"
  },
  {
    "question": "What does HTTP stand for?",
    "options": ["HyperText Transfer Protocol", "HyperText Transmission Protocol", "Hyper Transfer Text Protocol", "Hyper Thread Transfer Protocol"],
    "answer": "HyperText Transfer Protocol"
  },
  {
    "question": "What company created the iPhone?",
    "options": ["Apple", "Microsoft", "Samsung", "Google"],
    "answer": "Apple"
  },
  {
    "question": "What does USB stand for?",
    "options": ["Universal Serial Bus", "Universal Storage Bus", "Unified Serial Bus", "Universal System Bus"],
    "answer": "Universal Serial Bus"
  }
]
,
    // Level 2 questions (moderate)
   [
  {
    "question": "What is the main function of the ALU in a computer?",
    "options": ["Arithmetic and Logic Unit", "Array and List Unit", "Access and Load Unit", "Analog Logic Unit"],
    "answer": "Arithmetic and Logic Unit"
  },
  {
    "question": "What year was the first iPhone released?",
    "options": ["2005", "2006", "2007", "2008"],
    "answer": "2007"
  },
  {
    "question": "What does GPU stand for?",
    "options": ["Graphics Processing Unit", "General Processing Unit", "Graphical Processing Unit", "General Purpose Unit"],
    "answer": "Graphics Processing Unit"
  },
  {
    "question": "Which language is considered the mother of all programming languages?",
    "options": ["C", "Fortran", "Assembly", "COBOL"],
    "answer": "Assembly"
  },
  {
    "question": "Who is known as the father of the computer?",
    "options": ["Charles Babbage", "Alan Turing", "John Von Neumann", "Bill Gates"],
    "answer": "Charles Babbage"
  }
]
,
    // Level 3 questions (challenging)
  [
  {
    "question": "What does BIOS stand for?",
    "options": ["Basic Input Output System", "Binary Input Output System", "Basic Integrated Operating System", "Binary Integrated Operating System"],
    "answer": "Basic Input Output System"
  },
  {
    "question": "Which year did the World Wide Web become publicly available?",
    "options": ["1989", "1990", "1991", "1992"],
    "answer": "1991"
  },
  {
    "question": "What is the full form of SQL?",
    "options": ["Structured Query Language", "Simple Query Language", "Standard Query Language", "Sequential Query Language"],
    "answer": "Structured Query Language"
  },
  {
    "question": "Who is credited with inventing the World Wide Web?",
    "options": ["Tim Berners-Lee", "Bill Gates", "Steve Jobs", "Mark Zuckerberg"],
    "answer": "Tim Berners-Lee"
  },
  {
    "question": "What programming language is used primarily for web development?",
    "options": ["Python", "JavaScript", "C++", "Swift"],
    "answer": "JavaScript"
  }
]
,
    // Level 4 questions (hard)
   [
  {
    "question": "What is the purpose of an IP address?",
    "options": ["Identify a device on a network", "Increase device performance", "Improve internet speed", "Initiate data transfer"],
    "answer": "Identify a device on a network"
  },
  {
    "question": "What does DNS stand for?",
    "options": ["Domain Name System", "Data Network System", "Distributed Network System", "Domain Name Server"],
    "answer": "Domain Name System"
  },
  {
    "question": "Which protocol is used to send email?",
    "options": ["SMTP", "HTTP", "FTP", "IMAP"],
    "answer": "SMTP"
  },
  {
    "question": "What is the main function of a firewall in a computer network?",
    "options": ["Prevent unauthorized access", "Increase network speed", "Manage network devices", "Store network data"],
    "answer": "Prevent unauthorized access"
  },
  {
    "question": "Which year was the first version of HTML released?",
    "options": ["1991", "1993", "1995", "1997"],
    "answer": "1991"
  }
]
,
    // Level 5 questions (expert)
  [
  {
    "question": "What is the Big-O notation for the best case of binary search?",
    "options": ["O(1)", "O(log n)", "O(n)", "O(n log n)"],
    "answer": "O(1)"
  },
  {
    "question": "What is the principle of the Von Neumann architecture?",
    "options": ["Stored Program Concept", "Networking Protocols", "Parallel Processing", "Distributed Systems"],
    "answer": "Stored Program Concept"
  },
  {
    "question": "Which algorithm is used for finding the shortest path in a graph?",
    "options": ["Dijkstra's Algorithm", "Quick Sort", "Merge Sort", "Binary Search"],
    "answer": "Dijkstra's Algorithm"
  },
  {
    "question": "What does REST stand for in web services?",
    "options": ["Representational State Transfer", "Real-time Secure Transfer", "Reliable State Transfer", "Real-time Simple Transfer"],
    "answer": "Representational State Transfer"
  },
  {
    "question": "What is the main difference between TCP and UDP?",
    "options": ["TCP is connection-oriented, UDP is connectionless", "TCP is faster, UDP is more reliable", "TCP is for small data packets, UDP is for large data packets", "TCP is connectionless, UDP is connection-oriented"],
    "answer": "TCP is connection-oriented, UDP is connectionless"
  }
]
    // More levels as in the original code...
  ];

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

  void checkAnswer(String selectedOption) {
    if (selectedOption != questionsByLevel[widget.level - 1][questionIndex]["answer"]) {
      allCorrect = false;
    }

    setState(() {
      if (questionIndex < questionsByLevel[widget.level - 1].length - 1) {
        questionIndex++;
        timeRemaining = getTimeLimitForLevel(widget.level);
      } else {
        timer.cancel();
        if (allCorrect) {
          ref.read(audioProvider).playSFX('success.flac');
          widget.onLevelComplete();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VictoryScreen()),
          );
        } else {
          showGameOverDialog();
        }
      }
    });
  }

  int getTimeLimitForLevel(int level) {
    switch (level) {
      case 1:
        return 30;
      case 2:
        return 25;
      case 3:
        return 20;
      case 4:
        return 15;
      case 5:
        return 10;
      default:
        return 30;
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Level Failed'),
        content: Text('You missed some questions! Try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      questionIndex = 0;
      allCorrect = true;
      timeRemaining = getTimeLimitForLevel(widget.level);
      startTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    timeRemaining = getTimeLimitForLevel(widget.level);
    startTimer();
    ref.read(audioProvider).playMusic('quiz.mp3'); // Start background music
  }

  @override
  void dispose() {
    timer.cancel();
    ref.read(audioProvider).stopMusic(); // Stop background music
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade900, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.cyanAccent, size: 30),
                  onPressed: () {
                    ref.read(audioProvider).stopMusic(); // Stop background music when navigating back
                    ref.read(audioProvider).playSFX('button_click.wav');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LevelSelectScreen(mode: 'Tech Trivia Time')),
                    );
                  },
                ),
                SizedBox(width: 16),
                Text(
                  'Level ${widget.level}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Orbitron',
                    color: Colors.cyanAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.cyanAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Time remaining: $timeRemaining seconds',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Orbitron',
                      color: Colors.cyanAccent,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.cyanAccent,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Flexible(
                    child: Text(
                      questionsByLevel[widget.level - 1][questionIndex]["question"],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                        color: Colors.cyanAccent,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.cyanAccent,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: questionsByLevel[widget.level - 1][questionIndex]["options"]
                          .map<Widget>((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () => checkAnswer(option),
                            child: Text(option),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.cyanAccent,
                              shadowColor: Colors.cyan,
                              elevation: 5,
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Orbitron',
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        );
                      }).toList()..shuffle(Random()), // Randomize options order
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
