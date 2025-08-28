import 'package:flutter/material.dart';
import 'birds_of_a_feather.dart';
import 'dart:math';
import 'dart:io' show Platform;
import 'package:window_size/window_size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    setWindowTitle('Birds Of A Feather');
    setWindowFrame(const Rect.fromLTWH(100, 100, 500, 760));
    setWindowMinSize(const Size(500, 760));
  }

  runApp(BirdsApp());
}

class BirdsApp extends StatelessWidget {
  const BirdsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birds Of A Feather',
      home: BirdsHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BirdsHomePage extends StatefulWidget {
  const BirdsHomePage({super.key});

  @override
  _BirdsHomePageState createState() => _BirdsHomePageState();
}

class _BirdsHomePageState extends State<BirdsHomePage> {
  late BirdsOfAFeather game;
  final List<String> moveHistory = [];
  String? selectedCard;
  String outputMessage = '';
  late int savedSeed;

  @override
  void initState() {
    super.initState();
    savedSeed = Random().nextInt(1000000);
    game = BirdsOfAFeather(seed: savedSeed);
  }

  void newGame() {
    setState(() {
      savedSeed = Random().nextInt(1000000);
      game = BirdsOfAFeather(seed: savedSeed);
      moveHistory.clear();
      selectedCard = null;
      outputMessage = '';
    });
  }

  void restart() {
    setState(() {
      game = BirdsOfAFeather(seed: savedSeed);
      moveHistory.clear();
      selectedCard = null;
      outputMessage = '';
    });
  }

  void undo() {
    setState(() {
      game.undo();
      if (moveHistory.isNotEmpty) moveHistory.removeLast();
      outputMessage = '';
    });
  }

  void showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help'),
        content: Text(
          'Birds of a Feather is a solitaire card game where you merge cards of the same suit or adjacent rank, on the same row or column.\n\n'
          'The goal is to merge all the cards, leaving only one card.\n\n'
          'To play, drag a card onto another card of the same suit or adjacent rank.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void handleCardDrag(String sourceCard, String targetCard) {
    setState(() {
      String move = "$sourceCard-$targetCard";
      game.move(move);
      if (game.previousTarget.isNotEmpty &&
          game.previousTarget.last == targetCard) {
        moveHistory.add(move);
        outputMessage = '';
      } else {
        outputMessage = game.illegalMove;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B6623),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E4D2B),
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 20),
        title: SelectableText('Birds Of A Feather'),
        actions: [
          IconButton(onPressed: undo, icon: Icon(Icons.undo)),
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (value) {
              switch (value) {
                case 'New Game':
                  newGame();
                  break;
                case 'Restart':
                  restart();
                  break;
                case 'Help':
                  showHelpDialog();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'New Game', child: Text('New Game')),
              PopupMenuItem(value: 'Restart', child: Text('Restart')),
              PopupMenuItem(value: 'Help', child: Text('Help')),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth - 120;
          double height = constraints.maxHeight;
          double cardWidth = width / BirdsOfAFeather.SIZE - 8;
          double cardHeight = height / BirdsOfAFeather.SIZE - 80;
          double size = cardWidth < cardHeight ? cardWidth : cardHeight;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                color: Color(0xFF0A5A20),
                child: ListView.builder(
                  itemCount: moveHistory.length,
                  itemBuilder: (context, index) => ListTile(
                    title: SelectableText(
                      moveHistory[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: List.generate(BirdsOfAFeather.SIZE, (i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(BirdsOfAFeather.SIZE, (j) {
                            String card = game.grid[i][j];
                            if (card.trim().isEmpty) {
                              return blankCard(size);
                            }
                            return Draggable<String>(
                              data: card,
                              feedback: cardWidget(card, size, isDragging: true),
                              childWhenDragging: Container(
                                margin: EdgeInsets.all(4),
                                width: size,
                                height: size * 10 / 7,
                                color: Colors.transparent,
                              ),
                              child: DragTarget<String>(
                                onAcceptWithDetails: (draggedCard) {
                                  handleCardDrag(draggedCard.data, card);
                                },
                                builder: (context, candidateData, rejectedData) {
                                  return cardWidget(card, size);
                                },
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                    Spacer(),
                    SizedBox(height: 12),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF1E4D2B),
                        border: Border.all(color: Colors.lightGreenAccent, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        outputMessage.isEmpty ? 'Ready to play!' : outputMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Times New Roman',
                          color: outputMessage.isEmpty ? Colors.white : Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget cardWidget(String card, double size, {bool isDragging = false}) {
    return Container(
      margin: EdgeInsets.all(4),
      width: size,
      height: size * 10 / 7,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(6),
        image: card.trim().isEmpty
            ? null
            : DecorationImage(
                image: AssetImage('cards/${card.trim()}.png'),
                fit: BoxFit.cover,
              ),
        // ignore: deprecated_member_use
        color: isDragging ? Colors.white.withOpacity(0.7) : Colors.white,
      ),
    );
  }

  Widget blankCard(double size) {
    return Container(
      margin: EdgeInsets.all(4),
      width: size,
      height: size * 10 / 7,
    );
  }
}
