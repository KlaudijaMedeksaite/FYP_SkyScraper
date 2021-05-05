import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'decision2.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

class DestinationRoute extends StatefulWidget {
  //final Map<String, String>destinations;
  final departing;
  final climate;
  final date;

  DestinationRoute({Key key,this.departing,this.climate, this.date}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DestDecisionRouteState();
  }

}

  Map<String,String> destinations = Map<String,String>();

// ignore: deprecated_member_use
  List<String> climates = List<String>();
  String optionSelected = "Select";

  Map<String,String> _selectedDestinations = Map<String,String>();


class _DestDecisionRouteState extends State<DestinationRoute> {
  // ignore: deprecated_member_use
  List<int> _selectedItems = List<int>();

  @override
  StatefulWidget build(BuildContext context) {

    //_selectedDestinations.clear();
    var depDate = widget.date.day.toString() + "/" + widget.date.month.toString() + "/" + widget.date.year.toString();
    print("Climate t/f? " + widget.climate.toString() + "\nDeparting: " + widget.departing + "\nDate: " + widget.date.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 50),
                  Text("Departing: " + widget.departing ,
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DancingScript',
                        ),
                      )),
                  SizedBox(height: 30),
                  futureDB(),
                  Text("Date of departure: " + depDate,
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ]),
          )),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
              label: "Back"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward, color: Colors.deepOrange),
              label: "Next")
        ],
        onTap: (label) {
          if (label == 0) {
            Navigator.pop(context);
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Decision2Route(destinations:_selectedDestinations, date:widget.date, origin: widget.departing)));
          }
        },
      ),
    );
  }

  futureDB() {
    Future<dynamic> database; //= connectToDB();
    database = connectToDB();

    return Container(
        child: database == null
            ? Text('no db')
            : FutureBuilder(
            future: database,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("snapshot has data");
                return Column(
                  children: [
                    (widget.climate)
                    ? buildClimates()
                    : SizedBox(height: 1),
                    buildDestinations()
                  ],
                );
              }
              else if (snapshot.hasError) {
                print("snapshot has error");
                return Text("Database error: ${snapshot.error.toString()}");
              }
              else {
                print("snapshot loading?");
                return CircularProgressIndicator();
              }
            })
    );
  }

  connectToDB() async {

    destinations.clear();

    // connect
    final connection = await MySqlConnection.connect(new ConnectionSettings(
        host: '34.123.203.246',
        port: 3306,
        user: 'root',
        password: '12345',
        db: 'flightDB'
    ));
    var results;
    if(widget.climate == true){
      climates.clear();
      if (climates.length<1 && optionSelected == "Select"){
        climates.add("Select");
      }

      //query for climates
      results = await connection.query("select distinct climate from airports");

      for (var row in results) {
        if(row['climate'] != null){
          climates.add(row['climate'].toString());
        }
      }
    }

    //query for countries with climate
    if(widget.climate == true){
      String queryS = "select distinct rf.flight_no , rf.destination as code, a.city, a.country from ryanair_flights as rf left join airports as a on rf.destination=a.code where rf.origin = '${widget.departing}' and a.climate like '$optionSelected'";
      //"select distinct rf.destination as code, a.city, a.country from ryanair_flights as rf left join airports as a on rf.destination=a.code where rf.origin = 'MAD' and a.climate like 'Tropical'";
      results = await connection.query(queryS);
      print(results);
    } //if climate true
    else{
      results = await connection.query("select distinct rf.flight_no, rf.destination as code, a.city, a.country from ryanair_flights as rf left join airports as a on rf.destination=a.code where rf.origin = '${widget.departing}'");
    }// climate not true

    String dayQ = "Select ";
    String column = "";
    int dayNo = widget.date.weekday;
    switch(dayNo){
      case 1:
        column = "mon_fly";
        break;
      case 2:
        column = "tue_fly";
        break;
      case 3:
        column = "wed_fly";
        break;
      case 4:
        column = "thu_fly";
        break;
      case 5:
        column = "fri_fly";
        break;
      case 6:
        column = "sat_fly";
        break;
      case 7:
        column = "sun_fly";
        break;
    }
    dayQ += column + " from fly_days where flight_no like '";
    //print(results);
    for (var row in results) {
      var fno = row['flight_no'].toString();
      var code = row['code'].toString();
      var city = row['city'].toString();
      var country = row['country'].toString();

      var airport = country + ", " + city;
      String query = dayQ + fno + "'";
      var results2 = await connection.query(query);
      String flyBool = results2.first[column];

      //print("AIRPORT: "+airport);
      if (row['code'] != '' && flyBool == 'true') {
        destinations.addAll({code:airport});
      }
    }

    var sortedKeys = destinations.keys.toList()..sort();
    // close connection
    await connection.close();

    return Future<dynamic>.delayed(Duration(seconds: 0), () async => climates);
  }

  buildClimates() {

    return Column(
      children: [
        Text("Choose Climate:",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'DancingScript',
              ),
            )),
        DropdownButton<String>(
          value: optionSelected,
          onChanged: (String newValue) {
          setState(() {
          optionSelected = newValue;

          });
          },
          items: climates.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
          );
          }).toList()
          ),
        SizedBox(height: 30),

      ]
          );
  }

  buildDestinations() {
    return Column(
        children: [
          Text("Choose Destination:",
              style: GoogleFonts.oswald(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'DancingScript',
                ),
              )),
          Container(
            height: 300,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                return Container(
                  color: (_selectedItems.contains(index)) ? Colors.green.withOpacity(
                      0.5) : Colors.transparent,
                  child: ListTile(
                    trailing: _selectedItems.contains(index) ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                    onTap: () {
                      if (_selectedItems.contains(index)) {
                        setState(() {
                          _selectedItems.removeWhere((val) => val == index);
                          _selectedDestinations.remove(index.toString());
                          print("selected destinations rn");
                          print(_selectedDestinations);
                        });
                      }
                      else {
                        setState(() {
                          _selectedItems.add(index);
                          print(index);
                          _selectedDestinations.addAll({index.toString():destinations.values.elementAt(index)});
                        });
                      }
                    },
                    title: Text('${destinations.values.elementAt(index)}'),
                  ),
                );
              },
            ),
          )
        ]
      ) ;

    }
  }

