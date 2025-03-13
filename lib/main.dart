import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Calc App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'My Calc App'),
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
  Color accent1 = Color(0xFFA9C0D38);
  Color accent2 = Color(0xFF4C86A8);
  Color text = Color(0xFF1C1D21);
  Color text2 = Color.fromARGB(255, 250, 254, 252);
  List grid1 = ['card1','card2','card3'];

//checks edge cases for enter button
  void method() {

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background2,
        title: Text(widget.title),
        titleTextStyle: TextStyle( // Your custom font
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
      backgroundColor: background,
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // Align all children to the start
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First Expanded for Calculations + Error messages
          Expanded(
            child: Container(
              color: background2,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Container(
                    width: 450,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: accent1,width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  ],
                ),
                ),
              ),
            ),
          ),

          // for Numbers, Clear button, and Equal button
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
                    itemCount: grid1.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 8, // Space between rows
                      crossAxisSpacing: 8, // Space between cols
                    ),

                    itemBuilder: (context, index) {
                      return Container(
                        height: 5,
                        width: 5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accent1,
                          ),
                          onPressed: () {
                            _gridOneOperators(grid1[index]);
                          },
                          child: Center(
                            child: Text(
                              grid1[index],
                              style: TextStyle(fontSize: 50, color: text),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          //Grid for operators 
          Container(
            height: 200, // Set the height as needed
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: Center(
                child: GridView.builder(
                  itemCount: grid2.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                    mainAxisSpacing: 8, // Space between rows
                    crossAxisSpacing: 8, // Space between cols
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 5,
                      width: 5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent2,
                        ),
                        onPressed: () {
                          _gridTwoOperators(grid2[index]);
                        },
                        child: Center(
                          child: Text(
                            grid2[index],
                            style: TextStyle(fontSize: 50, color: text2),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
