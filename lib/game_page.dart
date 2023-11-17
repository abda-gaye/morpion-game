import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const String PLAYER_X = "x";
  static const String PLAYER_O = "O";
  late bool endGame;
  late String currentPlayer;
  late List<String> occupied;

  @override
  void initState() {
    initializeGame();
    super.initState();
  }

  void initializeGame() {
    currentPlayer = PLAYER_X;
    endGame = false;
    occupied = ["", "", "", "", "", "", "", "", ""];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _headerText(),
          _gameContainer(),
          _restartButton(),
        ]),
      ),
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text(
          "galsen Morpion",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          "tour du joueur $currentPlayer",
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _gameContainer() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, int index) {
          return _box(index);
        },
      ),
    );
  }

  Widget _box(index) {
    return InkWell(
      onTap: () {
        if (endGame || occupied[index].isNotEmpty) {
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinners();
          checkForDrawer();
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.black26
            : occupied[index] == PLAYER_X
                ? Colors.blue
                : Colors.orange,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            occupied[index],
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
    );
  }

  void changeTurn() {
    if (currentPlayer == PLAYER_O) {
      currentPlayer = PLAYER_X;
    } else {
      currentPlayer = PLAYER_O;
    }
  }

  checkForWinners() {
    List<List<int>> winnerpositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];
    for (var wp in winnerpositions) {
      String playerPos0 = occupied[wp[0]];
      String playerPos1 = occupied[wp[1]];
      String playerPos2 = occupied[wp[2]];

      if (playerPos0.isNotEmpty) {
        if (playerPos0 == playerPos1 && playerPos0 == playerPos2) {
          showGameOverMessage("joueur $playerPos0 a gagné");
          endGame = true;
          return;
        }
      }
    }
  }

  checkForDrawer() {
    if (endGame) {
      return;
    }
    bool draw = true;
    
  }

  showGameOverMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "jeu terminé $message",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
          ),
        )));
  }

  Widget _restartButton() {
    return ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.blue),
        ),
        onPressed: () {
          setState(() {
            initializeGame();
          });
        },
        child: const Text(
          "restaurer",
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }
}
