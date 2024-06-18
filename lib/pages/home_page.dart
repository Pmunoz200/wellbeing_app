import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/home_page/exercise_widget.dart';
import 'package:gemini_folder/pages/home_page/food_widget.dart';
import 'package:gemini_folder/pages/home_page/home_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    ExerciseWidgetPage(),
    HomeWidgetPage(),
    FoodWidgetPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WELLBEING APP'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, "/profile");
              },
              color: Colors.lightBlueAccent,
            ),
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.grey[400],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.fitness_center),
              label: 'Exersice',
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              label: 'Food',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
