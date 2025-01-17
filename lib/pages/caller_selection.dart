import 'package:flutter/material.dart';
import 'package:busy_faker/pages/theme_selection.dart';
import 'package:busy_faker/models/caller.dart';

class CallerSelectionPage extends StatelessWidget {
  final int callDelay;

  const CallerSelectionPage({super.key, required this.callDelay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('請選擇來電者')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CallerRow(
            leftCaller: heMo,
            rightCaller: qingYang,
            callDelay: callDelay,
          ),
          CallerRow(
            leftCaller: pingXin,
            rightCaller: miaoGe,
            callDelay: callDelay,
          )
        ],
      ),
    );
  }
}

class CallerRow extends StatelessWidget {
  final Caller leftCaller, rightCaller;
  final int callDelay;
  const CallerRow({super.key, required this.leftCaller, required this.rightCaller, required this.callDelay});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CallerButton(
          caller: leftCaller,
          callDelay: callDelay,
        ),
        CallerButton(
          caller: rightCaller,
          callDelay: callDelay,
        ),
      ],
    );
  }
}

class CallerButton extends StatelessWidget {
  final Caller caller;
  final int callDelay;
  const CallerButton({super.key, required this.caller, required this.callDelay});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThemeSelectionPage(caller: caller, callDelay: callDelay),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset(caller.imagePath, height: 200, width: 150, fit: BoxFit.cover), Text(caller.name)],
      ),
    );
  }
}
