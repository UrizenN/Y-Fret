import 'package:flutter/material.dart';
import 'FretButton.dart';

class Fret extends StatelessWidget {
  final int fretNo;
  final double fretWidth;
  const Fret({Key? key, required this.fretWidth, required this.fretNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: fretWidth - 5,
              height: 144,
            ),
            Container(
              width: 5,
              height: 144,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffbdbdbd),
                    Color(0xfff5f5f5),
                    Color(0xff616161)
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) {
            return FretButton(
              fretNo: fretNo + 1,
              index: index,
              fretWidth: fretWidth,
            );
          }),
        ),
      ],
    );
  }
}
