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
    'bad': '',
    'normal': '',
    'good': 'https://assets2.lottiefiles.com/packages/lf20_9qmxhgz4.json',
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
    setState(() {
      _showStatus = !_showStatus;
      status = statuses[random.nextInt(2)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _onTapScreen(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_showStatus == true)
                Align(
                    alignment: Alignment.topCenter,
                    child: PlantStatus(
                        phStatus: status,
                        phValue: 6.421,
                        waterStatus: status,
                        waterValue: 70)),
              Expanded(
                  child: Lottie.network(dataObj['lottieAnimationURL']['good'])),
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
                  child: Text(phValue.toString()))
            ]),
            Column(children: [
              dataObj['icon'][waterStatus],
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(waterValue.toString()))
            ])
          ],
        ));
  }
}
