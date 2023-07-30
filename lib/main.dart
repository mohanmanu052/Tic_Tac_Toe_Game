import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/controller/tic_tac_toe_provider.dart';

import 'view/tic_tac_toe_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final ticTacToeProvider = TicTacToeProvider();
  //await ticTacToeProvider.loadGameState();

  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TicTacToeProvider(),
      child: MaterialApp(
        title: 'Tic Tac Toe',
        home: TicTacToeScreen(),
      ),
    );
  }
}
