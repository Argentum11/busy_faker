import 'package:flutter/material.dart';
import 'package:busy_faker/pages/theme_selection.dart';
import 'package:busy_faker/models/caller.dart';

class CallerSelectionPage extends StatelessWidget {
  final int callDelay;

  const CallerSelectionPage({super.key, required this.callDelay});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '請選擇來電者',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.black87, // Darker text for better contrast
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white, // Light background
        iconTheme: const IconThemeData(color: Colors.black87), // Dark icons
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CallerRow extends StatelessWidget {
  final Caller leftCaller, rightCaller;
  final int callDelay;

  const CallerRow({
    super.key,
    required this.leftCaller,
    required this.rightCaller,
    required this.callDelay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
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
      ),
    );
  }
}

class CallerButton extends StatefulWidget {
  final Caller caller;
  final int callDelay;

  const CallerButton({
    super.key,
    required this.caller,
    required this.callDelay,
  });

  @override
  State<CallerButton> createState() => _CallerButtonState();
}

class _CallerButtonState extends State<CallerButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThemeSelectionPage(
              caller: widget.caller,
              callDelay: widget.callDelay,
            ),
          ),
        );
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.caller.imagePath,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      widget.caller.imagePath,
                      height: 180,
                      width: 135,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.caller.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
