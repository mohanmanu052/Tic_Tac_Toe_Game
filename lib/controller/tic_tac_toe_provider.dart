import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Player { X, O, None }

class TicTacToeProvider with ChangeNotifier {
  List<List<Player>> board =
      List.generate(3, (_) => List.filled(3, Player.None));
  Player currentPlayer = Player.X;
  bool isGameFinished = false;
  Future<void> saveGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> boardState = board
        .map((row) => row.map((player) => player.toString()).toList())
        .toList()
        .expand((row) => row)
        .toList();
    await prefs.setStringList('board', boardState);
    await prefs.setString('currentPlayer', currentPlayer.toString());
    await prefs.setBool('isGameFinished', isGameFinished);
    print('coming to save game state---' + boardState.toString());
  }

  Future<void> loadGameState() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? boardState = prefs.getStringList('board');
    final String? currentPlayerStr = prefs.getString('currentPlayer');
    final bool? isGameFinishedSaved = prefs.getBool('isGameFinished');

    if (boardState != null &&
        currentPlayerStr != null &&
        isGameFinishedSaved != null) {
      board = List.generate(3, (_) => List.filled(3, Player.None));
      for (int i = 0; i < boardState.length; i++) {
        final row = i ~/ 3;
        final col = i % 3;
        board[row][col] = playerFromString(boardState[i]);
      }
      currentPlayer = playerFromString(currentPlayerStr);
      isGameFinished = isGameFinishedSaved;
      notifyListeners();
      print('loading  save game state---' + boardState.toString());
    }
  }

  Player playerFromString(String playerStr) {
    switch (playerStr) {
      case 'Player.X':
        return Player.X;
      case 'Player.O':
        return Player.O;
      default:
        return Player.None;
    }
  }

  void resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    board = List.generate(3, (_) => List.filled(3, Player.None));
    currentPlayer = Player.X;
    isGameFinished = false;
    notifyListeners();
  }

  bool makeMove(int row, int col) {
    if (!isGameFinished && board[row][col] == Player.None) {
      board[row][col] = currentPlayer;
      if (_checkWin(row, col)) {
        isGameFinished = true;
      } else {
        _togglePlayer();
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  bool _checkWin(int row, int col) {
    // Check row
    if (board[row][0] == currentPlayer &&
        board[row][1] == currentPlayer &&
        board[row][2] == currentPlayer) {
      return true;
    }

    // Check column
    if (board[0][col] == currentPlayer &&
        board[1][col] == currentPlayer &&
        board[2][col] == currentPlayer) {
      return true;
    }

    // Check diagonals
    if ((board[0][0] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][2] == currentPlayer) ||
        (board[0][2] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][0] == currentPlayer)) {
      return true;
    }

    return false;
  }

  void _togglePlayer() {
    currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;
  }
}
