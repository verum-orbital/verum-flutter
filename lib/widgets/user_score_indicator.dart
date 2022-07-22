import 'package:flutter/material.dart';

class UserScoreIndicator extends StatelessWidget {
  final double score;
  const UserScoreIndicator({Key? key, required this.score}) : super(key: key);

  TextStyle getStyle() {
    TextStyle style = const TextStyle(fontWeight: FontWeight.bold);
    if (score > 80) {
      style = style.merge(TextStyle(color: Colors.greenAccent.shade200));
    } else if (score > 50) {
      style = style.merge(TextStyle(color: Colors.orangeAccent.shade200));
    } else {
      style = style.merge(TextStyle(color: Colors.redAccent.shade200));
    }
    return style;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0)),
      ),
      child: Text(
        '${score.toStringAsFixed(1)}',
        style: getStyle(),
      ),
    );
  }
}
