import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/controller/tic_tac_toe_provider.dart';

class TicTacToeScreen extends StatefulWidget {
  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  @override
  void initState() {
    var provider = Provider.of<TicTacToeProvider>(context, listen: false);
    provider.loadGameState();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ticTacToeProvider = Provider.of<TicTacToeProvider>(context);

    return WillPopScope(
        onWillPop: () async {
          // Save the game state when the back button is pressed
          await ticTacToeProvider.saveGameState();
          Navigator.pop(context, true);

          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              iconSize: 20.0,
              onPressed: () async {
                await ticTacToeProvider.saveGameState();
                Navigator.pop(context, true);
              },
            ),
            title: Text('Tic Tac Toe'),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                _playerSymbol(
                    'Player 1',
                    Icons.person,
                    ticTacToeProvider.currentPlayer == Player.X
                        ? Colors.blue
                        : Colors.grey,
                    context,
                    Icons.clear,
                    Colors.red),
                const SizedBox(
                  height: 20,
                ),
                _playerSymbol(
                    'Player 2',
                    Icons.person,
                    ticTacToeProvider.currentPlayer == Player.O
                        ? Colors.blue
                        : Colors.grey,
                    context,
                    Icons.panorama_fish_eye,
                    Colors.green),
                _buildBoard(context),
                if (ticTacToeProvider.isGameFinished)
                  ElevatedButton(
                    onPressed: () => ticTacToeProvider.resetGame(),
                    child: const Text('Restart'),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildBoard(BuildContext context) {
    final ticTacToeProvider = Provider.of<TicTacToeProvider>(context);
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final row = index ~/ 3;
        final col = index % 3;
        return GestureDetector(
          onTap: () {
            print('the row was  $row the colum was  $col');
            if (!ticTacToeProvider.isGameFinished) {
              ticTacToeProvider.makeMove(row, col);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Center(
              child: _buildPlayerSymbol(ticTacToeProvider.board[row][col]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayerSymbol(Player player) {
    if (player == Player.X) {
      return const Icon(
        Icons.clear,
        size: 50,
        color: Colors.red,
      );
    } else if (player == Player.O) {
      return const Icon(
        Icons.panorama_fish_eye,
        size: 50,
        color: Colors.green,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _playerSymbol(String name, IconData iconData, Color color,
      BuildContext context, IconData symbolIconData, Color symbolColor) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              iconData,
              size: 16,
              color: color,
            ),
          ),
          Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color),
              )),
          Container(
              padding: const EdgeInsets.all(8),
              child: Icon(
                symbolIconData,
                size: 20,
                color: symbolColor,
              )),
        ],
      ),
    );
  }
}
