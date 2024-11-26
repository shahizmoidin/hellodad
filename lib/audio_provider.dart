import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

final audioProvider = ChangeNotifierProvider<AudioHelper>((ref) => AudioHelper());

class AudioHelper extends ChangeNotifier {
  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isMusicPlaying = false;
  double _musicVolume = 1.0;
  double _sfxVolume = 1.0;

  bool get isMusicPlaying => _isMusicPlaying;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  Future<void> playMusic(String filename) async {
    _isMusicPlaying = true;
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
    await _musicPlayer.play(AssetSource('sounds/$filename'), volume: _musicVolume);
    notifyListeners();
  }

  Future<void> stopMusic() async {
    if (_isMusicPlaying) {
      _isMusicPlaying = false;
      await _musicPlayer.stop();
      notifyListeners();
    }
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume;
    await _musicPlayer.setVolume(_musicVolume);
    notifyListeners();
  }

  Future<void> playSFX(String filename) async {
    await _sfxPlayer.play(AssetSource('sounds/$filename'), volume: _sfxVolume);
  }

  Future<void> setSFXVolume(double volume) async {
    _sfxVolume = volume;
    notifyListeners();
  }

  void toggleSFX(bool isEnabled) {
    _sfxVolume = isEnabled ? 1.0 : 0.0;
    notifyListeners();
  }
}
