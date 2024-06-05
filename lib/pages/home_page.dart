import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Row(
      children: [
        Icon(Icons.fitness_center),
        Text('Exercise'),
      ],
    ),
    const Row(
      children: [
        Icon(Icons.fastfood),
        Text('Food'),
      ],
    ),
    const Row(
      children: [
        Icon(Icons.home),
        Text('Home'),
      ],
    ),
    const Row(
      children: [
        Icon(Icons.person),
        Text('Profile'),
      ],
    ),
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
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to the notification page
            },
            color: Colors.lightBlueAccent,
          ),],
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
            icon: Icon(Icons.fitness_center),
            label: 'Excersice',
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Food',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      )
    );
  }
}