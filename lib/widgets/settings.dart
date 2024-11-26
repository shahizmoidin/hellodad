import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_dad/db_helper.dart';
import 'package:hello_dad/audio_provider.dart';
import 'package:hello_dad/screens/main_menu.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    final audioHelper = ref.read(audioProvider);
  }

  Future<void> _clearData() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.clearData();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All game data cleared!')));
  }

  @override
  Widget build(BuildContext context) {
    final audioHelper = ref.watch(audioProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gamemodeselect.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainMenu()),
                    );
                  },
                ),
                Text(
                  'Background Music',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: audioHelper.musicVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: (audioHelper.musicVolume * 100).round().toString(),
                  onChanged: (double value) {
                    audioHelper.setMusicVolume(value);
                    if (value == 0.0) {
                      audioHelper.stopMusic();
                    } else {
                      audioHelper.playMusic('background.mp3');
                    }
                  },
                ),
                Text(
                  'Sound Effects',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: audioHelper.sfxVolume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: (audioHelper.sfxVolume * 100).round().toString(),
                  onChanged: (double value) {
                    audioHelper.setSFXVolume(value);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Clear Data'),
                          content: Text('Are you sure you want to clear all game data?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Confirm'),
                              onPressed: () async {
                                await _clearData();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  child: Text('Clear Data'),
                ),
                SizedBox(height: 40),
                Text(
                  'About the Game',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellowAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.redAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Enhance your technical skills through engaging challenges and puzzles. Navigate through multiple levels, designed to test your coding and problem-solving abilities. Whether you are a beginner or an experienced developer, this game offers something for everyone. Get ready for an educational and fun adventure!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Courier Prime',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
