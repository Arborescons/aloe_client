import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:aloe_client/secret.dart";

class NftScreen extends StatefulWidget {
  const NftScreen({Key? key}) : super(key: key);

  @override
  _NftScreenState createState() => _NftScreenState();
}

class _NftScreenState extends State<NftScreen> {
  TextEditingController _textFieldController = TextEditingController();
  String address = "";
  List<NftData> nfts = <NftData>[];

  Future<http.Response> getNfts() async {
    return await http.get(Uri.parse(alchemyHttp + "/getNFTs?owner=" + address));
  }

  Future<List<NftData>> fetchNfts() async {
    final response = await getNfts();
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);
      var tempNfts = <NftData>[];

      for(var i in decoded['ownedNfts']) {
        tempNfts.add(NftData.fromJson(i));
      }

      return tempNfts;
    } else {
      throw Exception("failed to get Nfts");
    }
  }

  void onPressedFindNftsButton() async {
    var res = await fetchNfts();
    setState(() {
      nfts = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(nfts[0].title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("NFT 주소를 입력해주세요."),
                  content: TextField(
                      onChanged: (value) {
                        setState(() {
                          address = value;
                        });
                      },
                      controller: _textFieldController,
                      decoration:
                          InputDecoration(hintText: "Text Field in Dialog")),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text('취소'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text('완료'),
                      onPressed: onPressedFindNftsButton,
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
