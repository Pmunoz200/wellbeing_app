import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:gemini_folder/pages/home_page/exercise_widget.dart';
import 'package:gemini_folder/pages/home_page/food_widget.dart';
import 'package:gemini_folder/pages/home_page/home_widget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();

  final List<Widget> _widgetOptions = <Widget>[
    HomeWidgetPage(),
    ExerciseWidgetPage(),
    FoodWidgetPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _advanceOneDayOnDate () {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  void _goBackOneDayOnDate () {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
          // Handle previous date logic
              _goBackOneDayOnDate();
              },
              color: Colors.black,
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(_selectedDate).toString(), // Fix the DateTime.format method
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Handle next date logic
                _selectedDate == DateTime.now() ? null : _advanceOneDayOnDate();
              },
              color: Colors.black,
              )
          ],
        ),
        actions: [
           MaterialButton(
          onPressed: () {},
          color: Colors.black,
          textColor: Colors.white,
          shape: CircleBorder(),
          child: const Icon(
            Icons.person,
            size: 30,
          ),
        )],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Colors.white,
              Colors.white,
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
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercise',
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