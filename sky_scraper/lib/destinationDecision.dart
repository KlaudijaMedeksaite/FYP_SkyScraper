import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sky_scraper/drop_list_1.dart';
import 'decision2.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

class DestinationRoute extends StatefulWidget {
  final departing;
  final climate;
  final date;

  DestinationRoute({Key key,this.departing,this.climate, this.date}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _DestDecisionRouteState();
  }

}
enum DropListChoice { climate, destination }

int x = 10;

class _DestDecisionRouteState extends State<DestinationRoute> {
  // ignore: deprecated_member_use
  List<int> _selectedItems = List<int>();

  // ignore: deprecated_member_use
  List<String> _airports = List<String>();

  //connectToDB();

  @override
  StatefulWidget build(BuildContext context) {
    print("\n\n\nLENGTH: airports length: " + (_airports.length).toString());
    print("Climate t/f? " + widget.climate.toString() + "\nDeparting: " + widget.departing + "\nDate: " + widget.date.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      //child: FutureBuilder
      //future: connectToDB(),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 50),
                  Text("Departing:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DancingScript',
                        ),
                      )),
                  SizedBox(height: 30),
                  Text("Choose Destination:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DancingScript',
                        ),
                      )),
                  /*FutureBuilder(builder: ): */
                  //Text('${buildDestinations()}'),
                  futureDB(),
                  //SizedBox(height: 30),
                  Text("Date of departure:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  //SizedBox(height: 15)
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
                MaterialPageRoute(builder: (context) => Decision2Route()));
          }
        },
      ),
    );
  }

  futureDB() {
    Future<dynamic> database; //= connectToDB();
    database = connectToDB();
    if(database == null){
      setState((){database = connectToDB();});
    }
    return Container(
          height: 500,
          child: database == null
              ? Text('no db')
              : FutureBuilder(
              future: database,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("snapshot has data");
                  return buildDestinations();
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
  buildDestinations() {
    print("airports: " + _airports.length.toString());
      return Container(
        height: 500,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _airports.length,
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
                    });
                  }
                  else {
                    setState(() {
                      _selectedItems.add(index);
                    });
                  }
                },
                title: Text('${_airports[index]}'),
              ),
            ); //ListTile(title: Text('$index'));
          },
        ),
      );
    }
  connectToDB() async {
    _airports.clear();
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
      var city = row['city'].toString();
      var country = row['country'].toString();

      var airport = country + ", " + city;
      //print(airport);
      if(row['code'] !=''){
        _airports.add(airport);
      }
    }

    // close connection
    await connection.close();
    return Future<dynamic>.delayed(Duration(seconds:0),() async => _airports);
  }
}

