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
    final textStyle = Theme.of(context).textTheme.headlineMedium;
    const fontSize = 18.0;

    return AppBar(
      title: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: goBackOneDayOnDate,
                  color: Colors.black,
                  iconSize: fontSize,
                ),
                Container(
                  width: 160, // Fixed width for the text container
                  child: Text(
                    DateFormat('EEEE, MMM d').format(selectedDate),
                    style: textStyle?.copyWith(fontSize: fontSize),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Visibility(
                  visible: selectedDate.isBefore(
                      DateTime.now().subtract(const Duration(days: 1))),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: advanceOneDayOnDate,
                    color: Colors.black,
                    iconSize: fontSize,
                  ),
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
              iconSize: fontSize * 1.2,
              icon: const Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
