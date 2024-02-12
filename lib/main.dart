import 'package:flutter/material.dart';
import 'package:namer_app/services/Game.dart';
import 'package:namer_app/pages/GamePage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<Game>(
      create: (BuildContext context) {
        print('app state reloaded');
        return Game();
      },
      child: GamePage(),
    ),
  );
}
