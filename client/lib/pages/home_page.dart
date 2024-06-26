import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
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
  DateTime _selectedDate = DateTime.now();
  DateTime startOfTomorrow = DateTime.now();

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

  void _advanceOneDayOnDate() {
    setState(() {
      DateTime targetDate = _selectedDate.add(const Duration(days: 1));
      if (targetDate.isBefore(startOfTomorrow)) {
        _selectedDate = targetDate;
      }
    });
  }

  void _goBackOneDayOnDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  @override
  void initState() {
    super.initState();
    startOfTomorrow = DateTime(
        startOfTomorrow.year, startOfTomorrow.month, startOfTomorrow.day + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        // Handle previous date logic
                        _goBackOneDayOnDate();
                      },
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM d')
                                .format(_selectedDate)
                                .toString(), // Fix the DateTime.format method
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Don't show 4 the current date
                    _selectedDate.isBefore(
                            startOfTomorrow.subtract(const Duration(days: 1)))
                        ? IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () {
                              // Handle next date logic
                              _selectedDate == DateTime.now()
                                  ? null
                                  : _advanceOneDayOnDate();
                            },
                            color: Colors.black,
                          )
                        : const SizedBox(
                            width: 48,
                          ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
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
        ));
  }
}
