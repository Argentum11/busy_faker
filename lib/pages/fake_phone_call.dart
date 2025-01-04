import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

/*
假的來電介面
先寫起來放著
(暫時用Theme2按鈕觸發)
*/

class FakePhoneCallPage extends StatefulWidget {
  const FakePhoneCallPage({super.key});

  @override
  _FakePhoneCallPageState createState() => _FakePhoneCallPageState();
}

class _FakePhoneCallPageState extends State<FakePhoneCallPage> {
  late Timer _timer;
  bool _isRinging = true;

  void _startVibration() {
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: 10000); // Vibrate for 10 seconds
    }
  }

  void _stopVibration() {
    Vibration.cancel();
  }

  void _endCall() {
    _stopVibration();
    setState(() {
      _isRinging = false;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _startVibration();
    // Automatically end call after 10 seconds
    _timer = Timer(const Duration(seconds: 10), _endCall);
  }

  @override
  void dispose() {
    _stopVibration();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isRinging
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Incoming Call',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                        'assets/images/caller.jpg'), // Replace with a caller image
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: _endCall,
                        child: const Icon(Icons.call_end, color: Colors.white),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                        ),
                        onPressed: () {
                          _stopVibration();
                          setState(() {
                            _isRinging = false;
                          });
                          // Add logic for answering call here if needed
                        },
                        child: const Icon(Icons.call, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              )
            : const Center(
                child: Text(
                  'Call Ended',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
      ),
    );
  }
}
