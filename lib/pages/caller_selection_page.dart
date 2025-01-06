import 'package:flutter/material.dart';
import 'theme_selection_page.dart';
import 'package:busy_faker/models/caller.dart';

class CallerSelectionPage extends StatelessWidget {
  final int minutes;
  final int seconds;

  CallerSelectionPage({super.key, required this.minutes, required this.seconds});

  final List<Caller> callers = [
    Caller(name: 'Character 1', imagePath: 'assets/images/character1.jpg'),
    Caller(name: 'Character 2', imagePath: 'assets/images/character2.jpg'),
    Caller(name: 'Character 3', imagePath: 'assets/images/character3.jpg'),
    Caller(name: 'Character 4', imagePath: 'assets/images/character4.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a caller')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CallerRow(
            leftCaller: callers[0],
            rightCaller: callers[1],
          ),
          CallerRow(
            leftCaller: callers[2],
            rightCaller: callers[3],
          )
        ],
      ),
    );
  }
}

class CallerRow extends StatelessWidget {
  final Caller leftCaller, rightCaller;
  const CallerRow({super.key, required this.leftCaller, required this.rightCaller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CallerButton(
          caller: leftCaller,
          context: context,
        ),
        CallerButton(
          caller: rightCaller,
          context: context,
        ),
      ],
    );
  }
}

class CallerButton extends StatelessWidget {
  final Caller caller;
  final BuildContext context;
  const CallerButton({super.key, required this.caller, required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ThemeSelectionPage()),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset(caller.imagePath, height: 200, width: 150, fit: BoxFit.cover), Text(caller.name)],
      ),
    );
  }
}
