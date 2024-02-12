import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/services/Game.dart';
import 'package:provider/provider.dart';
import '../Fretboard/Fretboard.dart';
import '../utils/Notes.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late bool hasGameStarted;
  late List<int> currentNoteAsked;
  late GameMode gameMode;

  @override
  void didChangeDependencies() {
    gameMode = Provider.of<Game>(context).gameMode;
    hasGameStarted = Provider.of<Game>(context).hasStarted;
    currentNoteAsked = Provider.of<Game>(context).askedNote;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Y-Fret',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //PitchUpTest(),
              GameInfo(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: FretBoard(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MySegmentedButton(),
                  IconButton(
                    onPressed: () {
                      if (hasGameStarted) {
                        Provider.of<Game>(context, listen: false).setHasStarted(false);
                      } else {
                        if (gameMode == GameMode.mic) {
                          Provider.of<Game>(context, listen: false).theMicGame();
                        }
                        Provider.of<Game>(context, listen: false).setHasStarted(true);
                      }
                    },
                    icon: hasGameStarted ? Icon(FluentIcons.pause_16_filled) : Icon(FluentIcons.play_16_filled),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySegmentedButton extends StatefulWidget {
  const MySegmentedButton({super.key});

  @override
  State<MySegmentedButton> createState() => _MySegmentedButtonState();
}

class _MySegmentedButtonState extends State<MySegmentedButton> {
  late Set<GameMode> mode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mode = <GameMode>{Provider.of<Game>(context).gameMode};
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: const <ButtonSegment<GameMode>>[
        ButtonSegment(
          value: GameMode.touch,
          icon: Icon(FluentIcons.tap_single_20_filled),
        ),
        ButtonSegment(
          value: GameMode.mic,
          icon: Icon(FluentIcons.mic_16_filled),
        ),
      ],
      selected: mode,
      onSelectionChanged: (Set<GameMode> newMode) {
        setState(() {
          Provider.of<Game>(context, listen: false).changeGameMode(newMode);
        });
      },
      multiSelectionEnabled: false,
    );
  }
}

class GameInfo extends StatefulWidget {
  const GameInfo({super.key});

  @override
  State<GameInfo> createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> {
  late Widget gameInfoWidget;
  late bool isCorrect;
  late bool isRecording;
  late bool hasStarted;
  late List<int> currentNote;

  @override
  void initState() {
    // TODO: implement initState
    gameInfoWidget = Text('Welcome :)');
    isCorrect = false;
    isRecording = false;
    hasStarted = false;
    currentNote = [];
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    hasStarted = Provider.of<Game>(context).hasStarted;
    currentNote = Provider.of<Game>(context).askedNote;
    isCorrect = Provider.of<Game>(context).isCorrect;
    isRecording = Provider.of<Game>(context).isRecording;
    handleDependencyChange();
    super.didChangeDependencies();
  }

  Future<void> handleDependencyChange() async {
    if (hasStarted) {
      if (isCorrect) {
        //toggle gameInfoWidget
        setState(() {
          gameInfoWidget = Row(
            children: <Widget>[
              Text('You\'re correct!'),
              Icon(
                FluentIcons.checkmark_16_filled,
                color: Colors.green,
              ),
            ],
          );
        });
        await Future.delayed(Duration(milliseconds: 400));
        setState(() {
          gameInfoWidget = Text(
              'Find ${noteList[currentNote[1]][currentNote[0]]} (${currentNote[0]},${currentNote[1]}) ${isRecording ? 'Recording...' : ''}');
        });
        isCorrect = false;
      } else {
        setState(() {
          gameInfoWidget = Text(
              'Find ${noteList[currentNote[1]][currentNote[0]]} (${currentNote[0]},${currentNote[1]}) ${isRecording ? 'Recording...' : ''}');
        });
      }
    } else {
      setState(() {
        gameInfoWidget = Text('Welcome :)');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: gameInfoWidget,
    );
  }
}
