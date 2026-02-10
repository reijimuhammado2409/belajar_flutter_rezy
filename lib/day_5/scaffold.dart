import 'package:flutter/material.dart';

class ScaffoldDay5 extends StatelessWidget {
  const ScaffoldDay5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,//pakai color HEX
      //backgroundColor: Colors.blue, //Pakai Color Native Flutter
      title: Text("Profil saya"),
      centerTitle: true,
      //leading : Icon(Icons.arrow_back)
      // actions: [Text("PPKD Batch 5")]
      ),
      body: Column(
        children:[
          Text("Nama : Muhamamad Fachri Fahrezy"),
          Text("")
        ],
      ),
    );
  }
}