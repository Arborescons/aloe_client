import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:aloe_client/secret.dart";
import 'package:transparent_image/transparent_image.dart';

class NftScreen extends StatefulWidget {
  const NftScreen({Key? key}) : super(key: key);

  @override
  _NftScreenState createState() => _NftScreenState();
}

class _NftScreenState extends State<NftScreen> {
  TextEditingController _textFieldController = TextEditingController();
  String address = "";
  List<NftData> nfts = <NftData>[];
  bool isProgress = false;

  Future<http.Response> getNfts() async {
    return await http.get(Uri.parse(alchemyHttp + "/getNFTs?owner=" + address));
  }

  Future<List<NftData>> fetchNfts() async {
    final response = await getNfts();
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      var tempNfts = <NftData>[];

      for (var i in decoded['ownedNfts']) {
        tempNfts.add(NftData.fromJson(i));
      }

      return tempNfts;
    } else {
      throw Exception("failed to get Nfts");
    }
  }

  Future<void> onPressedFindNftsButton() async {
    var res = await fetchNfts();
    setState(() {
      nfts = res;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: !isProgress
              ? nfts.isEmpty
                  ? Text("하단의 버튼을 눌러 주소를 입력해주세요.")
                  : GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: nfts.map((e) => FadeInImage.assetNetwork(
                        placeholder: "lib/assets/loading.gif",
                        image: e.mediaRaw,
                      )).toList(),
                    )
              : const CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("NFT 주소를 입력해주세요."),
                  content: TextField(
                      onChanged: (value) {
                        setState(() {
                          address = value;
                        });
                      },
                      controller: _textFieldController,
                      decoration: const InputDecoration(hintText: "Address")),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      child: const Text('취소'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: const Text('완료'),
                      onPressed: () async {
                        setState(() {
                          Navigator.pop(context);
                          isProgress = true;
                        });
                        await onPressedFindNftsButton();
                        setState(() {
                          isProgress = false;
                        });
                      },
                    ),
                  ],
                );
              });
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.check),
      ),
    );
  }
}

class NftData {
  final String contractAddress;
  final String title;
  final String description;
  final String mediaRaw;

  const NftData({
    required this.contractAddress,
    required this.title,
    required this.description,
    required this.mediaRaw,
  });

  factory NftData.fromJson(Map<String, dynamic> json) {
    return NftData(
        contractAddress: json['contract']['address'],
        title: json['title'],
        description: json['description'],
        mediaRaw: json['media'][0]['gateway']);
  }
}
