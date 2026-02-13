import 'package:flutter/material.dart';
class SideboxDay7 extends StatelessWidget {
  const SideboxDay7({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Day 7")),
      body: Column(
        children: [
          // SideboxDay7(),
          // PaddingDay7(),

          Image.asset("assets/images/priasolo.jpg"),
        ],
      ),
    );
  }
}