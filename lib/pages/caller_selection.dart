import 'package:flutter/material.dart';
import 'theme_selection.dart';
import 'package:busy_faker/models/caller.dart';

class CallerSelectionPage extends StatelessWidget {
  final int minutes;
  final int seconds;

  const CallerSelectionPage(
      {super.key, required this.minutes, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a caller')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CallerRow(
            leftCaller: heMo,
            rightCaller: qingYang,
          ),
          CallerRow(
            leftCaller: pingXin,
            rightCaller: miaoGe,
          )
        ],
      ),
    );
  }
}

class CallerRow extends StatelessWidget {
  final Caller leftCaller, rightCaller;
  const CallerRow(
      {super.key, required this.leftCaller, required this.rightCaller});

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
          MaterialPageRoute(
            builder: (context) => ThemeSelectionPage(caller: caller),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(caller.imagePath,
              height: 200, width: 150, fit: BoxFit.cover),
          Text(caller.name)
        ],
      ),
    );
  }
}
