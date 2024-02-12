import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/Game.dart';
import '../utils/Stylesheet.dart';

class FretButton extends StatefulWidget {
  final int index;
  final double fretWidth;
  final int fretNo;

  const FretButton({
    Key? key,
    required this.index,
    required this.fretWidth,
    required this.fretNo,
  }) : super(key: key);

  @override
  State<FretButton> createState() => _FretButtonState();
}

class _FretButtonState extends State<FretButton> {
  late double fretWidth = widget.fretWidth;
  late int fretNo = widget.fretNo;
  late int stringNo = widget.index;

  late bool hasStarted;
  late bool isAskedString;
  late bool isCorrect;
  late GameMode gameMode;
  late String detectedNote;
  late List<int> detectedFrets;
  late List<int> askedNote;
  late Widget buttonWidget;
  late bool flagEnabled;

  @override
  void initState() {
    isCorrect = false;
    flagEnabled = false;
    hasStarted = false;
    askedNote = [0, 0];
    buttonWidget = buildString(fretWidth, false);
    super.initState();
    if (stringNo == 1 && fretNo == 1) print('FretButton InıtState!');
  }

  @override
  void didChangeDependencies() {
    if (stringNo == askedNote[0] && fretNo == askedNote[1]) print('FretButton didChangeDependencies for askedNote');
    hasStarted = Provider.of<Game>(context).hasStarted;
    gameMode = Provider.of<Game>(context).gameMode;
    askedNote = Provider.of<Game>(context).askedNote;
    isAskedString = !hasStarted ? false : stringNo == askedNote[0];
    buttonWidget = buildString(fretWidth, hasStarted ? isAskedString : false);
    super.didChangeDependencies();
  }

  /*Future<void> handleSound() async {
    if (flagEnabled) return;
    flagEnabled = true;

    Provider.of<Game>(context, listen: false).checkNote(stringNo, fretNo);
    isCorrect = Provider.of<Game>(context, listen: false).isCorrect;

    setState(() {
      buttonWidget = buildNoteBox(fretWidth, fretNo, stringNo, hasStarted, isCorrect);
    });

    await Future.delayed(Duration(milliseconds: 300));
    if (isCorrect) {
      Provider.of<Game>(context, listen: false).randomNote();
    }
    isAskedString = stringNo == Provider.of<Game>(context, listen: false).askedNote[0];
    setState(() {
      buttonWidget = buildString(fretWidth, isAskedString);
    });

    Provider.of<Game>(context, listen: false).setLock(false);
    flagEnabled = false;
  }*/

  Future<void> handleTouch() async {
    print('handleTouch Worked');
    if (flagEnabled) return;
    flagEnabled = true;

    if (hasStarted) {
      Provider.of<Game>(context, listen: false).checkNote(stringNo, fretNo);
      isCorrect = Provider.of<Game>(context, listen: false).isCorrect;
    }

    setState(() {
      buttonWidget = buildNoteBox(fretWidth, fretNo, stringNo, hasStarted, isCorrect);
    });

    await Future.delayed(Duration(milliseconds: 300));

    if (hasStarted) {
      if (isCorrect) {
        Provider.of<Game>(context, listen: false).randomNote();
      }
      isAskedString = stringNo == Provider.of<Game>(context, listen: false).askedNote[0];
    }

    setState(() {
      buttonWidget = buildString(fretWidth, hasStarted ? isAskedString : false);
      print('fret button eski haline döndü');
    });

    flagEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () {
          print('Button ${widget.index} tapped');
          if (flagEnabled || gameMode == GameMode.mic) return;
          handleTouch();
        },
        child: buttonWidget,
      ),
    );
  }
}
