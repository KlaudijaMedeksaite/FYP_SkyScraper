import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'destinationDecision.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

class Decision1Route extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Decision1RouteState();
  }
}
bool _climate = false;

//AIRPORTS
Map<String,String> _airportMap = Map<String,String>();

String optionSelected = "Select";
String codeSelected = "0000";
class _Decision1RouteState extends State<Decision1Route> {
  DateTime selectedDate = DateTime.now();

  @override
  StatefulWidget build(BuildContext context) {
    print(optionSelected);
    print("LOADED");
    print(_airportMap.values);
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50),
                  Text("Departing:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DancingScript',
                        ),
                      )
                  ),
                  SizedBox(height: 30),
                  //dropdown here
                  futureDB(),
                  SizedBox(height: 30),
                  Text("Choose Climate or Destination:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DancingScript',
                        ),
                      )),
                  //radio button
                    RadioListTile(
                      title: const Text("Climate"),
                      value: true,
                      activeColor: Colors.lightGreenAccent,
                      groupValue: _climate,
                      onChanged: (value) {
                        setState(() {
                          print("_climate = true");
                          _climate = value;
                        });
                      },
                    ),
                  RadioListTile(
                    title: Text("Destination"),
                    value: false,
                    groupValue: _climate,
                    activeColor: Colors.lightGreenAccent,
                    onChanged: (value) {
                      setState(() {
                        print("_climate = false");
                        _climate = value;
                      });
                    },
                  ),
                  SizedBox(height: 50),
                  Text(
                      "Date of departure: " + selectedDate.day.toString() + "/" +
                          selectedDate.month.toString() + "/" +
                          selectedDate.year.toString() ,
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(height: 15),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    onPressed: () => selectDate(context),
                    child: Text("Select Date",
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                    ),
                    padding: EdgeInsets.all(20.0),
                  ),
                  // calendar to select date here
                ]
            ),
          )

      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_back, color: Colors.deepOrange),
              label: "Back"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward, color: Colors.deepOrange),
              label: "Next"
          )
        ],
        onTap: (label) {
          if (label == 0) {
            Navigator.pop(context);
          }
          else {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DestinationRoute(departing: codeSelected, climate: _climate ,date: selectedDate))
            );
          }
        },
      ),
    );
  }

  //Date Selector
  Future<void> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 12),
        lastDate: DateTime(2021, 12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  futureDB() {
    Future<dynamic> database; //= connectToDB();
    database = connectToDB();
    /*if (database == null) {
      setState(() {
        database = connectToDB();
      });
    }*/
    return Container(
        child: database == null
            ? Text('no db')
            : FutureBuilder(
            future: database,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("snapshot has data");
                return buildDrop();
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

    _airportMap.clear();
    //_airportCities.clear();
    if (_airportMap.length<1 && optionSelected == "Select"){
      _airportMap.addAll({codeSelected:optionSelected});
    }
    // connect
    final connection = await MySqlConnection.connect(new ConnectionSettings(
        host: '34.123.203.246',
        port: 3306,
        user: 'root',
        password: '12345',
        db: 'flightDB'
    ));
    //query
    var results = await connection.query("select * from airports");
    for (var row in results) {
      var code = row['code'].toString();
      var city = row['city'].toString();
      var country = row['country'].toString();

      var airport = city + ", " +country;
      //print(airport);
      if (row['code'] != '') {
        _airportMap.addAll({code:airport});
        //_airportCities.add(airport);
      }
    }
    //_airportCities.sort();
    var sortedKeys = _airportMap.keys.toList()..sort();
    // close connection
    await connection.close();

    print("number of airports");
    print(_airportMap.length);
    return Future<dynamic>.delayed(Duration(seconds: 0), () async => _airportMap);
  }

  buildDrop() {
    return DropdownButton<String>(
        value: optionSelected,
        onChanged: (String newValue) {
          setState(() {
            optionSelected = newValue;
            codeSelected = _airportMap.keys.firstWhere((k) =>(_airportMap[k]) == newValue);
            print("code: " + codeSelected + ", city: " + optionSelected);

          });
        },
        items: _airportMap.values.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList()
    );
  }

}