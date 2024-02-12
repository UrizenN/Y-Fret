import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

import '../utils/Notes.dart';

final _random = Random();

enum GameMode { mic, touch }

class Game with ChangeNotifier {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final pitchupDart = PitchHandler(InstrumentType.guitar);

  late GameMode gameMode;
  late List<int> widths = [45, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39];
  late bool hasStarted;
  late String noteSnap;
  late String note;
  late String status;
  late bool isCorrect;
  late bool isRecording;
  late bool locked;
  late List<int> askedNote;
  late List<int> detectedFrets;

  Game() {
    askedNote = [randomNumberInterval(0, 5), randomNumberInterval(0, 12)];
    detectedFrets = [];
    noteSnap = "";
    note = "";
    locked = false;
    status = "Click on start";
    gameMode = GameMode.touch;
    isCorrect = false;
    hasStarted = false;
    isRecording = false;
    notifyListeners();
  }

  int randomNumberInterval(int min, int max) => min + _random.nextInt(max - min);

  Future<void> listener(dynamic obj) async {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    final result = pitchDetectorDart.getPitch(audioSample);
    //If there is a pitch - evaluate it
    if (result.pitched) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      final handledPitchResult = pitchupDart.handlePitch(result.pitch);
      //Updates the state with the result
      noteSnap = handledPitchResult.note;
      status = handledPitchResult.tuningStatus.toString();
    }
  }

  void setLock(val) {
    print('lock set to $val');
    locked = val;
  }

  void onError(Object e) {
    print(e);
  }

  Future<void> theMicGame() async {
    return;
    await Future.delayed(Duration(milliseconds: 1000));
    startCapture();
    while (hasStarted && gameMode == GameMode.mic) {
      while (locked) {}

      if (noteSnap != note) {
        note = noteSnap;
        detectedFrets.clear();
        for (int i = 0; i < noteList.length; i++) {
          if (noteList[i][askedNote[0]].contains(note)) {
            detectedFrets.add(i);
          }
        }
        notifyListeners();
        await Future.delayed(Duration(milliseconds: 1000));
      }
    }
    stopCapture();
  }

  void checkNote(stringNo, fretNo) {
    if (!hasStarted) {
      print('Failed. Game has not started yet!');
      isCorrect = false;
    }

    if (gameMode == GameMode.touch) {
      if (askedNote[0] == stringNo && askedNote[1] == fretNo) {
        print('Correct!');
        isCorrect = true;
      } else {
        print('Not Correct!');
        isCorrect = false;
      }
    } else {
      if (noteList[fretNo][stringNo].contains(note)) {
        print('Correct!');
        isCorrect = true;
      } else {
        print('Not Correct!');
        isCorrect = false;
      }
    }
    notifyListeners();
  }

  Future<void> startCapture() async {
    isRecording = true;
    noteSnap = '';
    status = 'Play Something?';
    notifyListeners();
    await _audioRecorder.start(listener, onError, sampleRate: 44100, bufferSize: 3000);
  }

  Future<void> stopCapture() async {
    await _audioRecorder.stop();
    isRecording = false;
    noteSnap = '';
    status = "Click on start";
    notifyListeners();
  }

  void randomNote() {
    askedNote = [randomNumberInterval(0, 5), randomNumberInterval(0, 12)];
    notifyListeners();
    print('note is fret ${askedNote[1]} string ${askedNote[0]}');
  }

  void setHasStarted(val) {
    hasStarted = val;
    print('setHasStarted: $hasStarted');
    isCorrect = hasStarted ? isCorrect : false;
    notifyListeners();
  }

  void changeGameMode(Set<GameMode> selectedMode) {
    gameMode = selectedMode.first;
    print('Game Mode Changed. Current Mode is : ${gameMode.toString()}');
    notifyListeners();
  }
}
