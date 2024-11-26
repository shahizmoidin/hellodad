import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:hello_dad/widgets/settings.dart';
import 'game_modes.dart';
import '../audio_provider.dart';

class MainMenu extends ConsumerStatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends ConsumerState<MainMenu> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Ensure music plays when the screen is rebuilt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioProvider).playMusic('main-menu.mp3'); // Start playing music on screen load
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ref.read(audioProvider).stopMusic(); // Stop music when the main menu is disposed
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(audioProvider).playMusic('main-menu.mp3'); // Resume playing music when the app is resumed
    } else if (state == AppLifecycleState.paused) {
      ref.read(audioProvider).stopMusic(); // Stop music when the app is paused
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mainmenu.jpg'), // Use your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  HoverButton(
                    text: 'Start Lessons',
                    onPressed: () {
                      ref.read(audioProvider).stopMusic();
                      ref.read(audioProvider).playSFX('button_click.wav');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameModes()),
                      );
                    },
                    color: const Color.fromARGB(148, 93, 64, 55),
                    hoverColor: Colors.brown.shade900,
                  ),
                  SizedBox(height: 10),
                  HoverButton(
                    text: 'Class Settings',
                    onPressed: () {
                      ref.read(audioProvider).playSFX('button_click.wav');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                    },
                    color: const Color.fromARGB(148, 93, 64, 55),
                    hoverColor: Colors.brown.shade900,
                  ),
                  SizedBox(height: 10),
                  HoverButton(
                    text: 'End Session',
                    onPressed: () {
                      ref.read(audioProvider).playSFX('button_click.wav');
                      Future.delayed(Duration(milliseconds: 200), () {
                        SystemNavigator.pop(); // Exit the app
                      });
                    },
                    color: const Color.fromARGB(148, 93, 64, 55),
                    hoverColor: Colors.brown.shade900,
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

class HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color hoverColor;

  HoverButton({required this.text, required this.onPressed, required this.color, required this.hoverColor});

  @override
  _HoverButtonState createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: _isHovered ? widget.hoverColor : widget.color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: Offset(5, 5),
              ),
          ],
        ),
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'FunFont',
            ),
          ),
        ),
      ),
    );
  }
}
