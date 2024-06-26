import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeAppBar extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback goBackOneDayOnDate;
  final VoidCallback advanceOneDayOnDate;

  const HomeAppBar({
    required this.selectedDate,
    required this.goBackOneDayOnDate,
    required this.advanceOneDayOnDate,
  });

  @override
  Widget build(BuildContext context) {
    // final startOfTomorrow = DateTime.now().add(const Duration(days: 1)).toLocal();
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: goBackOneDayOnDate,
        color: Colors.black,
      ),
      title: Center(
        child: Text(
          DateFormat('EEEE, MMM d').format(selectedDate),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1))))
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_forward),
            onPressed: selectedDate == DateTime.now() ? null : advanceOneDayOnDate,
            color: Colors.black,
          )
        else
          const SizedBox(width: 2),
        Container(
          width: 40,
          height: 40,
          margin: EdgeInsets.zero,
          child: IconButton(
            onPressed: () {},
            constraints: const BoxConstraints(),
            icon: Image.asset("assets/icon_profile.png"),
          ),
        ),
      ],
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}