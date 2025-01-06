import 'package:flutter/material.dart';
import 'theme_selection_page.dart';
import 'package:busy_faker/models/character.dart';

class CharacterSelectionPage extends StatelessWidget {
  final int minutes;
  final int seconds;

  CharacterSelectionPage(
      {super.key, required this.minutes, required this.seconds});

  final List<Character> characters = [
    Character(name: 'Character 1', imagePath: 'assets/images/character1.jpg'),
    Character(name: 'Character 2', imagePath: 'assets/images/character2.jpg'),
    Character(name: 'Character 3', imagePath: 'assets/images/character3.jpg'),
    Character(name: 'Character 4', imagePath: 'assets/images/character4.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Character Selection Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CharacterRow(
            leftCharacter: characters[0],
            rightCharacter: characters[1],
          ),
          CharacterRow(
            leftCharacter: characters[2],
            rightCharacter: characters[3],
          )
        ],
      ),
    );
  }
}

class CharacterRow extends StatelessWidget {
  final Character leftCharacter, rightCharacter;
  const CharacterRow(
      {super.key, required this.leftCharacter, required this.rightCharacter});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CharacterButton(
          character: leftCharacter,
          context: context,
        ),
        CharacterButton(
          character: rightCharacter,
          context: context,
        ),
      ],
    );
  }
}

class CharacterButton extends StatelessWidget {
  final Character character;
  final BuildContext context;
  const CharacterButton(
      {super.key, required this.character, required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(character.imagePath,
            height: 200, width: 150, fit: BoxFit.cover),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ThemeSelectionPage()),
            );
          },
          child: Text(character.name),
        ),
      ],
    );
  }
}
