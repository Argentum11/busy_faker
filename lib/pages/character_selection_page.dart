import 'package:flutter/material.dart';
import 'theme_selection_page.dart';

class CharacterSelectionPage extends StatelessWidget {
  final int minutes;
  final int seconds;

  const CharacterSelectionPage(
      {super.key, required this.minutes, required this.seconds});

  void _navigateToThemeSelectionPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ThemeSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Character Selection Page')),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                _buildCharacterWidget(
                  'assets/images/character1.jpg',
                  'Character 1',
                  context,
                ), //測試圖片，修改後記得到pubspec.yaml改assets，之後執行flutter pub get
                _buildCharacterWidget(
                  'assets/images/character2.jpg',
                  'Character 2',
                  context,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildCharacterWidget(
                  'assets/images/character3.jpg',
                  'Character 3',
                  context,
                ),
                _buildCharacterWidget(
                  'assets/images/character4.jpg',
                  'Character 4',
                  context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterWidget(
      String imagePath, String buttonText, BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 200,
            width: 150,
            fit: BoxFit.cover,
          ),
          ElevatedButton(
            onPressed: () => _navigateToThemeSelectionPage(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
