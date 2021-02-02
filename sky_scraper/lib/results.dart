import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

class ResultsRoute extends StatefulWidget {
  @override
  _ResultsRouteState createState() => _ResultsRouteState();
}

class _ResultsRouteState extends State<ResultsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // TITLES
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Fr672",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                        ),
                      )),
                  SizedBox(width: 125,),
                  Text("Fr2520",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
                        ),
                      )),
                  SizedBox(width: 15,),

                ],
              ),
              SizedBox(height:20),

              //SCHEDULED TIMES
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Text("Scheduled:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(width:30,),
                  Text("13:15 - 14:35",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(width: 75,),
                  Text("13:45 - 15:15",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
              SizedBox(height:20),

              //TRENDING TIMES
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Text("Trending:",
                    style: GoogleFonts.oswald(
                    textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
      )),
                  SizedBox(width:42,),
                  Text("13:15 - 14:35",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(width: 75,),
                  Text("13:45 - 15:15",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
              // DURATION
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Text("Duration:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(width:50,),
                  Text("1hr 20min",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(width: 100,),
                  Text("0hr 30min",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
              //TRENDING DURATION
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Text("Trending:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(width:50,),
                  Text("1hr 00min",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(width: 100,),
                  Text("1hr 00min",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
              // ON TIME PERCENTAGE
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Text("On time:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(width:70,),
                  Text("100%",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(width: 140,),
                  Text("25%",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
              // CURRENT STATUS
              SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 10,),
                  Text("Status:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(width:78,),
                  Text("In-air",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(width: 135,),
                  Text("Delayed",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
            ]
        ),
      ),
      bottomNavigationBar:BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon:Icon(Icons.arrow_back, color: Colors.deepOrange),
              label: "Back"
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.home, color: Colors.deepOrange),
              label: "Home"
          )

        ],
        onTap:(label){
          if(label == 0){
            Navigator.pop(context);
          }
          else{
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeRoute())
            );
          }
        },
      ),
    );
  }

}
