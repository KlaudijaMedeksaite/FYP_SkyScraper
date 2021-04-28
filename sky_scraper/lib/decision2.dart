import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'results.dart';
import 'dart:convert';

class Decision2Route extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _Decision2RouteState();
  }
 
}

class Flight
{
  String flightNo;
  String time;

  Flight(this.flightNo, this.time);
  factory Flight.fromJson(dynamic json){
  return Flight(json['flightNo'] as String, json['time'] as String);
  }

  String toString(){
  return '{${this.flightNo}, ${this.time}}';
  }
}

class _Decision2RouteState extends State<Decision2Route> {
  bool _isChecked = false;
  List<bool> boolList = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];

  List<String> options = ["","","","","","","","","","","","","","","","","","","","","","","","","","",""];

  List<String> frs = ["","","","","","","","","","","","","","","","","","","","","","","","","","",""];

  int selections = 0;

  main(){
    var flights = ['{"flightNo": "fr233", "time": "11:55"}',
      '{"flightNo": "fr234", "time": "12:45"}',
      '{"flightNo": "fr235", "time": "13:25"}',
      '{"flightNo": "fr236", "time": "14:00"}',
      '{"flightNo": "fr237", "time": "14:55"}',
      '{"flightNo": "fr238", "time": "15:45"}'
    ];

    /*var jFlight = [];
    int i = 0;
    for(var flight in flights){
      jFlight[i] =  Flight.fromJson(jsonDecode(flights[i]));
      i++;
    }*/

    /*int totalFrs = 21;
    for(int j = 0; j <= totalFrs; j++){
      String fr = ((j+2)*12).toString();
      frs = frs.map((j)=>(fr));
      //frs[j] = "fr"+j.toString();//((;
      print(frs[j]);
    }*/

  }

  @override
  Widget build(BuildContext context) {
    main();
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: SingleChildScrollView(
          //mainAxisAlignment: MainAxisAlignment.center,
          //shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: <Widget>[
              Text("Select two Flights for comparison",
                  style: GoogleFonts.oswald(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'DancingScript',
                ),
              )),
              // checklist, allow two selections
              /*CheckboxListTile(
                value: _isChecked,
                title: Text("FR442"),
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
              CheckboxListTile(
                value: _isChecked,
                title: Text("Fr233"),
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("FR442"),
                value: _isChecked,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Fr233"),
                value: _isChecked,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("A342"),
                value: _isChecked,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("EK24"),
                value: _isChecked,
                onChanged: (bool value) {
                  setState(() {
                    _isChecked = value;
                  });
                },
              ),*/
              buildFlights(),
              //Buttons

            ]
          ),
        ),
      ),
      bottomNavigationBar:BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon:Icon(Icons.arrow_back, color: Colors.deepOrange),
            label: "Back"
          ),
          BottomNavigationBarItem(
              icon:Icon(Icons.arrow_forward, color: Colors.deepOrange),
              label: "Next"
          )
        ],
        onTap:(label){
          if(label == 0) {
            Navigator.pop(context);

          }
          else{
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResultsRoute())

            );
          }
        },
      ),

    );
  }

  Widget buildFlights(){
    return Container(
      width: MediaQuery. of(context). size. width,
      height: MediaQuery. of(context). size. height,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(16.0),
        itemCount: 25,
        itemBuilder: buildRow,
      ),
    );
  }

  Widget buildRow(BuildContext context, int i){
    //int j = round(i);
    return GestureDetector(
        child: ListTile(
          title: Text(
            'fr'+(((i+2)*((i+1)*12))).toString(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              )
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          dense: true,
          trailing: boolList[i]
              ?Icon(Icons.check_box)
              :Icon(Icons.check_box_outline_blank),
          onTap: (){
            setState((){
              print(frs[i]);
              if(selections >= 2 && boolList[i] == false){

              }
              else{
                boolList[i] = !boolList[i];
                if( boolList[i] == false){
                  selections--;
                  options[i] = null;
                }
                else{
                  selections++;
                  //options[i] = ListTile.title.Text.toString();
                }
              }

            });
          },
        ),
      );
  }


}


