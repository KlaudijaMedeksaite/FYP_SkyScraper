import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'decison1.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sky Scanner",
          style: TextStyle(color: Color(0xffffffaa)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Get Started\n',
              style: GoogleFonts.dancingScript(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.redAccent),
              textAlign: TextAlign.center,

            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Decision1Route()));
              },
              icon: Icon(Icons.airplanemode_active),
              color:Colors.deepOrangeAccent,
              iconSize: 100,
              highlightColor: Colors.deepOrange,
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
