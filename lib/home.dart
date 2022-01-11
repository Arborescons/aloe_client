import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showStatus = false;

  final Map lottieAnimationURL = {
    'bad': '',
    'normal': '',
    'good': 'https://assets2.lottiefiles.com/packages/lf20_9qmxhgz4.json',
  };

  void _onTapScreen() {
    setState(() {
      _showStatus = !_showStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTapScreen(),
        child: Stack(children: [
          if (_showStatus == true)
            const Positioned.fill(
                top: 24.0,
                child:
                    Align(alignment: Alignment.topCenter, child: Text("임시"))),
          Expanded(
              child: Align(child: Lottie.network(lottieAnimationURL['good'])))
        ]));
  }
}
