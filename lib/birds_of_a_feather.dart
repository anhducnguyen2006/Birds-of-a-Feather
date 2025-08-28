import 'dart:math';

class BirdsOfAFeather {
  late Random _random;
  late List<List<String>> grid;
  final String suitChars = "CHSD";
  final String rankChars = "A23456789TJQK";
  static const int SIZE = 4;
  late List<String> deck;
  late List<String> previousSource;
  late List<String> previousTarget;
  late List<List<int>> previousSourceIndex;
  late List<List<String>> initialGrid;
  int seed;
  List<String> cards = [];
  String illegalMove = "";

  BirdsOfAFeather({required this.seed}) {
    _random = Random(seed);
    // INIT DATA
    grid = List.generate(SIZE, (_) => List.filled(SIZE, ''));
    deck = [];
    previousSource = [];
    previousTarget = [];
    previousSourceIndex = [];
    initialGrid = List.generate(SIZE, (_) => List.filled(SIZE, ''));

    newGame();
  }

  void move(String move) {
    cards = move.split("-");
    if (cards.length != 2 || move.length > 5) {
      illegalMove = "Illegal move: wrong input format\n";
      // print("Illegal move: wrong input format\n");
      return;
    } else {
      illegalMove = "";
    }
    
    if(cards[0] == cards[1]) {
      // print("Illegal move: cannot play on the same card\n");
      return;
    } else {
      illegalMove = ""; 
    }

    List<int> sourceIndex = indexOf(grid, cards[0]);
    List<int> targetIndex = indexOf(grid, cards[1]);

    if (sourceIndex[0] == -1 || targetIndex[0] == -1) {
      illegalMove = "Illegal move: wrong input format\n";
      // print("Illegal move: wrong input format\n");
      return;
    } else {
      illegalMove = "";
    }

    if (validMove(sourceIndex, targetIndex, cards)) {
      grid[sourceIndex[0]][sourceIndex[1]] = "  ";
      grid[targetIndex[0]][targetIndex[1]] = cards[0];

      previousSource.add(cards[0]);
      previousTarget.add(cards[1]);
      previousSourceIndex.add(sourceIndex);
    }

    // print(toString());

    if (isWin()) {
      illegalMove = "You won!";
      // print("You won!");
    }
  }
  
  void newGame() {
    deck.clear();
    for (int i = 0; i < suitChars.length; i++) {
      for (int j = 0; j < rankChars.length; j++) {
        deck.add("${rankChars[j]}${suitChars[i]}");
      }
    }
    deck.shuffle(_random);

    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        grid[i][j] = deck.removeLast();
        initialGrid[i][j] = grid[i][j];
      }
    }
  }

  void undo() {
    if (previousSource.isEmpty) {
      illegalMove = "No previous move done\n";
      // print("No previous move done\n");
      return;
    } else {
      illegalMove = "";
    }
    String source = previousSource.removeLast();
    String target = previousTarget.removeLast();
    List<int> sourceIndex = indexOf(grid, source);
    List<int> targetIndex = previousSourceIndex.removeLast();

    grid[targetIndex[0]][targetIndex[1]] = source;
    grid[sourceIndex[0]][sourceIndex[1]] = target;

    // print(toString());
  }

  bool validMove(List<int> source, List<int> target, List<String> cards) {
    if (source[0] == target[0] || source[1] == target[1]) {
      illegalMove = "";
      if (cards[0][1] == cards[1][1]) {
        return true;
      } else {
        if (getRank(cards[0][0]) == getRank(cards[1][0]) ||
            (getRank(cards[0][0]) - getRank(cards[1][0])).abs() == 1) {
          illegalMove = "";
          return true;
        } else {
          illegalMove = "Illegal move: ranks must be same or adjacent\nIllegal move: suits must be same";
          // print("Illegal move: ranks must be same or adjacent\nIllegal move: suits must be same\n");
        }
      }
    } else {
      illegalMove = "Illegal move: Wrong column and row";
      // print("Illegal move: Wrong column and row\n");
    }

    return false;
  }

  bool isWin() {
    bool isOnly = false;
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        if (grid[i][j] != "  ") {
          if (isOnly) return false;
          isOnly = true;
        }
      }
    }
    return true;
  }

  int getRank(String rankChar) {
    switch (rankChar) {
      case 'A':
        return 1;
      case '2':
        return 2;
      case '3':
        return 3;
      case '4':
        return 4;
      case '5':
        return 5;
      case '6':
        return 6;
      case '7':
        return 7;
      case '8':
        return 8;
      case '9':
        return 9;
      case 'T':
        return 10;
      case 'J':
        return 11;
      case 'Q':
        return 12;
      case 'K':
        return 13;
      default:
        return 0;
    }
  }

  List<int> indexOf(List<List<String>> grid, String target) {
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        if (grid[i][j] == target) {
          return [i, j];
        }
      }
    }
    return [-1, -1];
  }
  String getInitialGridAsString() {
    return initialGrid.map((row) => row.join(' ')).join('\n');
  }
  @override
  String toString() {
    String temp = "";
    for (int i = 0; i < SIZE; i++) {
      for (int j = 0; j < SIZE; j++) {
        temp += "${grid[i][j]} ";
      }
      temp += "\n";
    }
    return temp;
  }
}

