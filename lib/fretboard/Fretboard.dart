import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/Game.dart';
import 'Fret.dart';
import 'FretButton.dart';

class FretBoard extends StatefulWidget {
  const FretBoard({Key? key}) : super(key: key);

  @override
  State<FretBoard> createState() => _FretBoardState();
}

class _FretBoardState extends State<FretBoard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Nut(),
          Neck(),
          SizedBox(
            height: 144,
            width: 50,
          ),
        ],
      ),
    );
  }
}

class Nut extends StatefulWidget {
  const Nut({super.key});

  @override
  State<Nut> createState() => _NutState();
}

class _NutState extends State<Nut> {
  double fretWidth = 45;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(builder: (context, game, child) {
      return Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 35,
                height: 144,
                decoration: BoxDecoration(
                  color: Colors.brown,
                  border: Border(
                    left: BorderSide.none,
                    right: BorderSide.none,
                    top: BorderSide(width: 1.0, color: Colors.black),
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
              ),
              Container(
                width: 10,
                height: 144,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide.none,
                    right: BorderSide.none,
                    top: BorderSide(width: 1.0, color: Colors.black),
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                  ),
                  color: Colors.brown[100],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              6,
              (index) {
                return FretButton(
                  index: index,
                  fretWidth: 45,
                  fretNo: 0,
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class Neck extends StatelessWidget {
  const Neck({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 534,
          height: 144,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide.none,
              right: BorderSide.none,
              top: BorderSide(width: 1.0, color: Colors.black),
              bottom: BorderSide(width: 1.0, color: Colors.black),
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/fullfretboard.png'),
            ),
          ),
        ),
        Row(
          children: List.generate(12, (index) {
            double width = 50.0 - index;
            width = width < 0 ? 0 : width;
            return Fret(fretNo: index, fretWidth: width);
          }),
        ),
      ],
    );
  }
}
