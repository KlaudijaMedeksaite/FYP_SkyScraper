import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'results.dart';
import 'dart:convert';

class Decision2Route extends StatefulWidget{

  final Map<String, String>destinations;
  final date;
  final origin;
  Decision2Route({Key key,this.origin, this.destinations, this.date}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return new _Decision2RouteState();
  }
 
}

// ignore: deprecated_member_use
List<String> airlines = List<String>();
// ignore: deprecated_member_use
var _destinations = new List(25);
Map<String,String> _allFlights = Map<String, String>();

// for flight selection
int limitCnt = 0;
String flightOne = "";
String flightTwo = "";


class _Decision2RouteState extends State<Decision2Route> {
  List<int> _selectedItemsFs = List<int>();

  @override
  StatefulWidget build(BuildContext context) {

    print("destinations: " );

    airlines.clear();
    airlines.add("Ryanair");
    print("origin: " + widget.origin);

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  printDestinations(),
                  printAirlines(),
                  futureDB(),
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
                MaterialPageRoute(builder: (context) => ResultsRoute()));
          }
        },
      ),
    );


  }

  printDestinations() {

    //_destinations.clear();
    for(int x = 0; x < widget.destinations.values.length; x++){
      _destinations[x] = widget.destinations.values.elementAt(x);
    }
    print(_destinations);
    String destinations = "";
    for(int i = 0; i < widget.destinations.values.length; i++){
      destinations += widget.destinations.values.elementAt(i);
      destinations += "\n";
    }
    return Column(
      children: [
        Text("Destinations Chosen:\n",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'DancingScript',
              ),
            )
        ),
        Text(destinations,
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'DancingScript',
              ),
            )
        ),
      ],
    );

  }

  printAirlines() {
    String airlineStr = "";
    for(int i = 0; i < airlines.length; i++){
      airlineStr += airlines[i];
      airlineStr += "\n";
    }

    // make this into a check list
    return Column(
      children: [
        Text("Airlines:\n",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'DancingScript',
              ),
            )
        ),
        Text(airlineStr,
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'DancingScript',
              ),
            )
        ),
      ],
    );
  }

  connectToDB() async {

    // clear flights to make sure no old data left
    _allFlights.clear();

    // connect to db
    final connection = await MySqlConnection.connect(new ConnectionSettings(
        host: '34.123.203.246',
        port: 3306,
        user: 'root',
        password: '12345',
        db: 'flightDB'
    ));

    // query to get all airports
    var results = await connection.query("select * from airports;");

    // ignore: deprecated_member_use
    List<String> airportcities = List<String>();
    // ignore: deprecated_member_use
    List<String> airportcodes = List<String>();

    for (var row in results) {
      airportcities.add(row['city']);
      airportcodes.add(row['code']);
    }

    // ignore: deprecated_member_use
    List<String> desCodes = new List<String>();
    for (int x = 0; x<_destinations.length;x++) {

      if(_destinations[x] != null){
        print(_destinations[x]);
        // using full name of destination airport to get the city
        String cit = "";
        cit += _destinations[x].toString();
        int start = cit.indexOf(",");
        cit = cit.substring(start);
        cit = cit.replaceAll(",", "");
        cit = cit.trim();
        print("CIT: " + cit);
        //checking for the code of the airport
        if(airportcities.indexOf(cit) > -1){
          var index = airportcities.indexOf(cit);
          // adding airport code to desCodes
          desCodes.add(airportcodes.elementAt(index));
        }
      }
    }
    // building query for all flights to destinations destinations
    String query = "";
    query += "Select flight_no from ryanair_flights where ";
    for(int x = 0; x< desCodes.length; x++){
      query += "origin like '${widget.origin}' and destination like '${desCodes[x]}' ";
      print("descodes[x]"+desCodes[x]);
      if((x+1)<desCodes.length){
        query+="or ";
      }
      else{
        query += ";";
      }
    }
    print(query);
    results = await connection.query(query);

    //adding to flights map
    int cnt = 0;
    for (var row in results){
      _allFlights.addAll({row['flight_no'].toString():""});
      cnt ++;
    }

    // build query for the arrival airports of the flights
    query = "select distinct rf.origin, a.city, a.country, rf.flight_no from ryanair_flights as rf left join airports as a on rf.destination=a.code where rf.flight_no like '";
    for(int x = 0; x < _allFlights.length; x++){
      print(_allFlights.keys.elementAt(x));
      query += _allFlights.keys.elementAt(x);
      if(x+1 < _allFlights.length){
        query+="' or flight_no like '";
      }
      else{
        query+="';";
      }
    }
    
    //print(query);
    results = await connection.query(query);

    //add the airports to flight map so each flight maps to an airport
    cnt = 0;
    for (var row in results){
      String airport = row['city'] + ", " + row['country'];
      String k = _allFlights.keys.elementAt(cnt);
      _allFlights[k] = airport;
      cnt++;
    }

    return Future<dynamic>.delayed(Duration(seconds: 0), () async => _allFlights);
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
                    showFlights()
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

  showFlights() {
    print("in showFlights()");
    return Column(
        children: [
          Text("Select up to Two Flights:",
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
              itemCount: _allFlights.length,
              itemBuilder: (context, index) {
                return Container(
                  color: (_selectedItemsFs.contains(index)) ? Colors.green.withOpacity(
                      0.5) : Colors.transparent,
                  child: ListTile(
                    trailing: _selectedItemsFs.contains(index) ? Icon(Icons.check_box)
                        : Icon(Icons.check_box_outline_blank),
                    onTap: () {
                      if (_selectedItemsFs.contains(index)) {
                        setState(() {
                          _selectedItemsFs.removeWhere((val) => val == index);
                          limitCnt--;
                        });
                      }
                      else {

                        if(limitCnt<2){
                          setState(() {
                            _selectedItemsFs.add(index);
                            print(index);
                            limitCnt++;
                          });
                        }
                      }
                    },
                    title: Text('${_allFlights.keys.elementAt(index)} - ${_allFlights.values.elementAt(index)}'),
                  ),
                );
              },
            ),
          )
        ]
    ) ;

  }

}





