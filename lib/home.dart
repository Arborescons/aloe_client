import 'dart:math';

import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';

final Map dataObj = {
  'icon': {
    'bad': const Icon(Icons.sentiment_dissatisfied_outlined,
        color: Colors.redAccent, size: 48.0),
    'normal': const Icon(Icons.sentiment_satisfied_outlined,
        color: Colors.amberAccent, size: 48.0),
    'good': const Icon(Icons.sentiment_very_satisfied_outlined,
        color: Colors.greenAccent, size: 48.0),
  },
  'lottieAnimationURL': {
    'bad': 'https://assets8.lottiefiles.com/packages/lf20_th87EG.json',
    'normal': 'https://assets8.lottiefiles.com/packages/lf20_zsskr8pv.json',
    'good': 'https://assets8.lottiefiles.com/packages/lf20_ho3vw7rh.json',
  }
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showStatus = false;
  String status = 'good';

  final List<String> statuses = ['good', 'normal', 'bad'];

  final random = Random();

  void _onTapScreen() {
    if (_showStatus == false) {
      setState(() {
        status = statuses[random.nextInt(3)];
      });
    }
    setState(() {
      _showStatus = !_showStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTapScreen(),
        child: Stack(children: [
          Positioned.fill(
              top: 0,
              child: AnimatedOpacity(
                  opacity: _showStatus ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: PlantStatus(
                          phStatus: status,
                          phValue: 6.421,
                          waterStatus: status,
                          waterValue: 70)))),
          Positioned.fill(
              bottom: -100,
              child: Lottie.network(dataObj['lottieAnimationURL'][status])),
        ]));
  }
}

class PlantStatus extends StatelessWidget {
  const PlantStatus(
      {required this.phStatus,
      required this.phValue,
      required this.waterValue,
      required this.waterStatus,
      Key? key})
      : super(key: key);

  final String waterStatus;
  final String phStatus;
  final double phValue;
  final double waterValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(children: [
              dataObj['icon'][phStatus],
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text("pH : " + phValue.toString()))
            ]),
            Column(children: [
              dataObj['icon'][waterStatus],
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(waterValue.toString() + "%"))
            ])
          ],
        ));
  }
}
