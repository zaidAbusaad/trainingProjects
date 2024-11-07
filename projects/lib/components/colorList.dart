import 'package:flutter/material.dart';
import 'package:projects/components/category_item.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:projects/models/colorModel.dart';

class ColorItems extends StatelessWidget {
  const ColorItems({super.key, required this.tune,});
final ColorTile tune;
  @override
  Widget build(BuildContext context) {
    return Category(
      onTap: () async {
        final player = AudioPlayer();
        await player.setSource(AssetSource(tune.audio));
        await player.resume();
      },
      color: tune.color,
    );
  }
}


