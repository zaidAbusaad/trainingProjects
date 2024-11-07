import 'package:flutter/material.dart';
import 'package:projects/components/colorList.dart';
import '';
import '../models/colorModel.dart';

class TuneApp extends StatefulWidget {
  TuneApp({super.key});

  @override
  State<TuneApp> createState() => _TuneAppState();
}

class _TuneAppState extends State<TuneApp> {
  List<ColorTile> tunes = const [
    ColorTile(
      color: Colors.blue,
      audio: 'audio/tunes/note1.wav',
    ),
    ColorTile(
      color: Colors.red,
      audio: 'audio/tunes/note4.wav',
    )
  ];

  late List<Widget> myItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myItems = getList(tunes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'TuneApp',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: myItems

        ),
      ),
    );
  }
}
List<Widget> getList (List<ColorTile> tunes){
  List<ColorItems> tunesList=[];
  for(int i = 0 ; i<tunes.length;i++)
    {
      tunesList.add(ColorItems(tune: tunes[i]));
    }
  return tunesList;
}
