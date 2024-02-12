import 'package:flutter/material.dart';
import 'Notes.dart';

Widget buildNoteBox(double fretWidth, int fretNo, int stringNo, bool hasStarted,
    bool isCorrect) {
  return Container(
    width: hasStarted ? fretWidth - 5 : fretWidth,
    height: 24,
    decoration: BoxDecoration(
      color: hasStarted
          ? (isCorrect ? Colors.green : Colors.red)
          : Colors.transparent,
    ),
    child: Center(
      child: Text(
        noteList[fretNo][stringNo],
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
    ),
  );
}

Widget buildString(double fretWidth, bool isAskedString) {
  return SizedBox(
    height: 24,
    width: fretWidth,
    child: Center(
      child: Container(
        width: double.infinity,
        height: isAskedString ? 3.0 : 2.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isAskedString
                ? [
                    Colors.lightBlue.shade100,
                    Colors.lightBlue.shade300,
                    Colors.lightBlue,
                  ]
                : [
                    Colors.lime.shade100,
                    Colors.lime.shade300,
                    Colors.lime,
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),
  );
}

/*
Widget buildNormalString(fretWidth, isAsked) {
  return SizedBox(
    height: 24,
    width: fretWidth,
    child: Center(
      child: Container(
        width: double.infinity,
        height: 2.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lime.shade100,
              Colors.lime.shade300,
              Colors.lime,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),
  );
}

buildStringIsCorrect(fretWidth, fretNo, stringNo, isCorrect) {
  print('buildnotebox worked');
  return Container(
    width: fretWidth,
    height: 24,
    decoration: BoxDecoration(
      color: Colors.red,
    ),
    child: Center(
      child: Text(
        noteList[fretNo][stringNo],
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
    ),
  );
}

Widget buildAskedString(fretWidth) {
  return SizedBox(
    height: 24,
    width: fretWidth,
    child: Center(
      child: Container(
        width: double.infinity,
        height: 3.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue.shade100,
              Colors.lightBlue.shade300,
              Colors.lightBlue,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),
  );
}

Widget buildHandler(double fretWidth, int fretNo, int stringNo,
    bool hasGameStarted, bool isAskedString, bool isCorrect, bool isClicked) {
  Widget resultWidget = isClicked
      ? buildNoteBox(fretWidth, fretNo, stringNo, hasGameStarted, isCorrect)
      : buildString(hasGameStarted, isAskedString, stringNo, fretWidth);

  return resultWidget;
}
*/
