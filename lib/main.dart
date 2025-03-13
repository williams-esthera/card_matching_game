import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_matching_game/cards.dart';

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

  //use init state to ensure cards are generated at the start of the application
  @override
  void initState() {
    super.initState();
    generateCards(8);
    matchingList = cards;
  }

  //Create this method for generating cards without having to manually do so
  void generateCards(int no) {
    Cards card;
    //adds all cards to the list 2x for matching
    for (int i = 1; i <= no; i++) {
      card = Cards(frontImg:"front$i", id:i);
      //adds each card 2x
      cards.add(card);
      cards.add(card);
    }

    setState((){}); //update UI
  }

  //This will randomize the order of the cards being displayed
  void populateCards() {
    Map<Cards, int> cardTracker = {};
    List<Cards> tempMatchList = [];

    //loop until 16 cards have been added to tempMatchList
    while (tempMatchList.length < 16) {
      int rando = Random().nextInt(cards.length);
      Cards getCard = cards[rando];

      //if the card hasn't been added, add it to the list, and track it in the map
      if (!cardTracker.containsKey(getCard)) {
        cardTracker[getCard] = 1;
        tempMatchList.add(getCard);
        //if the value of the card is 1, increase counter and add card to MatchList
      } else if (cardTracker[getCard] == 1) {
        cardTracker.update(getCard, (value) => value + 1);
        tempMatchList.add(getCard);
      }

      setState(() {
        matchingList = tempMatchList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background2,
        title: Text(widget.title),
        titleTextStyle: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: text),
      ),
      backgroundColor: background,
      body: Column(
        mainAxisAlignment:MainAxisAlignment.start, // Align all children to the start
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First Expanded for Calculations + Error messages
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Welcome to Card Matching"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: accent1),
                    onPressed: () {
                      populateCards();
                    },
                    child: Text('Randomize Cards'),
                  ),
                ],
              ),
            ),
          ),

          // GridView for Cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 70.0,
              ), // Add vertical padding
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Center(
                  child: GridView.builder(
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
                          height: 15,
                          width: 5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/back.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        onTap: () {
                          //test dialog to ensure tap is working
                          showDialog(
                            context: context,
                            builder:(context) => AlertDialog(
                                  title: Text(
                                    "Tapped: ${matchingList[index].getId}",
                                  ),
                                  content: Text("If you're seeing this the code works",),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Ok'),
                                    ),
                                  ],
                                ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
