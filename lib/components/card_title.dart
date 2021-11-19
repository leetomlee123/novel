import 'package:flutter/material.dart';

class card_title extends StatelessWidget {
  late final String? title;
  late final Widget? child;

  card_title(this.title, this.child);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Container(
            height: 30,
            child: Row(
              children: [
                VerticalDivider(
                  color: Colors.blue,
                  width: 10,
                  thickness: 6,
                  indent: 2,
                  endIndent: 2,
                ),
                SizedBox(
                  width: 1,
                ),
                Text(
                  title ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          child ?? Container()
        ],
      ),
    );
  }
}
