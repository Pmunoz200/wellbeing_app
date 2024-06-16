import 'package:flutter/material.dart';
import 'package:gemini_folder/pages/home_page/exercise_widget.dart';
import 'package:gemini_folder/pages/home_page/food_widget.dart';
import 'package:gemini_folder/pages/home_page/home_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 1;

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
        title: Text('WELLBEING APP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Navigate to the notification page
            },
            color: Colors.black,
          ),],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Color(0xFFEDF1F8),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
        top: BorderSide(
          color: Colors.black,
          width: 0.5,
        ),
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[400],
          items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercise',
        ),
          BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fastfood),
          label: 'Food',
        ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      )
    );
  }
}