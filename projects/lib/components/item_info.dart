import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../models/number.dart';

class ItemInfo extends StatelessWidget {
  const ItemInfo({super.key, required this.item});

  final ItemModel item;
  @override
  Widget build(BuildContext context) {
    return Row(
        children: [

          Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.jpName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  item.enName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 1),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: IconButton(
                  splashColor: Colors.yellow,
                  onPressed: () async {
                    final player = AudioPlayer();
                    await player.setSource(AssetSource(item.audio));
                    await player.resume();
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ]
    );
  }
}