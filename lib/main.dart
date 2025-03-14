import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_matching_game/cards.dart';
import 'package:card_matching_game/GameProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Card Matching App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color background = Color(0xFFC9CBA3);
  Color background2 = Color(0xFFFFE1A8);
  Color accent1 = Color(0xFF9C0D38);
  Color accent2 = Color(0xFF4C86A8);
  Color text = Color(0xFF1C1D21);
  Color text2 = Color.fromARGB(255, 250, 254, 252);
  List<Cards> cards = [];
  List<Cards> matchingList = [];
  List<Cards> flippedCards = []; // Track currently flipped cards
  late GameProvider gameProvider;
  //use init state to ensure cards are generated at the start of the application
  @override
  void initState() {
    super.initState();
    generateCards(8);
    matchingList = cards;
    gameProvider = GameProvider(cards: cards);
  }

  //Create this method for generating cards without having to manually do so
  void generateCards(int no) {
    //create 2 cards for each card, one with the original id, and one with the original id + the number of cards [1->9,2->10,3->11,4->12,5->13,6->14,7->15,8->16]
    Cards card;
    Cards card2;
    //adds all cards to the list 2x for matching
    for (int i = 1; i <= no; i++) {
      card = Cards(frontImg: "assets/images/front$i.png", original_id: i, card_no: i);
      card2 = Cards(frontImg: "assets/images/front$i.png", original_id: i+no, card_no: i);
      //adds each card 2x, but with different original_id
      cards.add(card);
      cards.add(card2);
    }

    setState(() {}); //update UI
  }

  //This will reset and randomize the order of the cards being displayed
  void populateCards() {
    //reset the cards
    cards.clear();
    matchingList.clear();
    //generate new cards
    generateCards(8);
    //reset the game provider
    gameProvider.resetGame();

    Map<int, int> cardTracker = {};
    List<Cards> tempMatchList = [];

    //loop until 16 cards have been added to tempMatchList
    while (tempMatchList.length < 16) {
      int rando = Random().nextInt(cards.length);
      int getCardId = cards[rando].original_id;
      Cards getCard = cards[rando];

      //if the card hasn't been added, add it to the list, and track it in the map
      if (!cardTracker.containsKey(getCardId)) {
        cardTracker[getCardId] = 1;
        tempMatchList.add(getCard);
      }
      //setState to ensure changes show up correctly
      setState(() {
        matchingList = tempMatchList;
      });
    }
  }

  void flipCard(Cards flip) {
    // Don't allow flipping if two cards are already selected
    if (gameProvider.selectedCards.length >= 2 || flip.getFrozen) return;

    setState(() {
      flip.flipCard();
      gameProvider.selectCard(flip);

      // If we now have 2 cards selected
      if (gameProvider.selectedCards.length == 2) {
        gameProvider.checkMatch();
        gameProvider.freezeCards(cards);
        
        // Wait 2 seconds before flipping back if no match
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            if (!gameProvider.getIsMatch) {
              gameProvider.selectedCards[0].flipCard();
              gameProvider.selectedCards[1].flipCard();
              gameProvider.unfreezeCards(cards);
            } else {
              // If it's a match, keep the cards frozen
              gameProvider.selectedCards[0].freezeCard();
              gameProvider.selectedCards[1].freezeCard();
              gameProvider.unfreezeCards(cards);
            }
            gameProvider.updateScore(gameProvider.getIsMatch);
            gameProvider.selectedCards.clear();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: background2,
        title: Text(widget.title),
        titleTextStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),

      backgroundColor: background,
      body: Column(
        //mainAxisAlignment:MainAxisAlignment.start, // Align all children to the start
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First Expanded for Calculations + Error messages
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome to Card Matching",
                style:TextStyle(fontFamily:'Poker',fontSize:50)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: accent1),
                  onPressed: () {
                    populateCards();
                  },
                  child: Text('Randomize Cards',
                  style:TextStyle(fontSize:30, color:text2)),
                ),
              ],
            ),
          ),

          // Card Grid takes remaining space
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Add vertical padding
                //get the size screen size, and adjust card size accordingly
                final double availableWidth = constraints.maxWidth * 0.9;
                final double availableHeight = constraints.maxHeight * 0.9;

                double cardWidth = availableWidth / 4;
                double cardHeight = availableHeight / 4;

                double cardSize = min(cardWidth, cardHeight);

                return Center(
                  child: SizedBox(
                    height: cardSize * 4 + 24,
                    width: cardSize * 4 + 24,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: matchingList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        mainAxisSpacing: 8, // Space between rows
                        crossAxisSpacing: 8, // Space between cols
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("${matchingList[index].getCurrImg}"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              flipCard(matchingList[index]);
                            });
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
