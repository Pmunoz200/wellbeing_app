import 'package:flutter/material.dart';
import 'home_page/home_app_bar.dart';
import 'package:gemini_folder/pages/home_page/exercise_widget.dart';
import 'package:gemini_folder/pages/home_page/food_widget.dart';
import 'package:gemini_folder/pages/home_page/home_widget.dart';
import 'package:gemini_folder/pages/home_page/home_bottom_bar.dart';

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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: HomeAppBar(advanceOneDayOnDate: _advanceOneDayOnDate, goBackOneDayOnDate: _goBackOneDayOnDate, selectedDate: _selectedDate),
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
        bottomNavigationBar: HomeBottomBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ));
  }
}
