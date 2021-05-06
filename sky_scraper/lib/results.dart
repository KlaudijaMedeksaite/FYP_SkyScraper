import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysql1/mysql1.dart';
import 'home.dart';

class ResultsRoute extends StatefulWidget {

  final flightOne;
  final flightTwo;

  ResultsRoute({Key key,this.flightOne,this.flightTwo}) : super(key: key);


  @override
  _ResultsRouteState createState() => _ResultsRouteState();
}

//flight vars
String status1 = "", status2 = "";
String times1 ="", times2 = "";
String duration1 ="", duration2 = "";
// ignore: non_constant_identifier_names
String trend_duration1 ="", trend_duration2 = "";
String onTimePerc1 = "", onTimePerc2 = "";

class _ResultsRouteState extends State<ResultsRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              buildFlightTitles(),
              SizedBox(height:20),
              futureTimes(),
              SizedBox(height:20),
              futureDurations(),
              SizedBox(height:20),
              futurePercentages(),
              SizedBox(height:20),
              futureStatuses(),
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

  buildFlightTitles(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(widget.flightOne,
              style: GoogleFonts.oswald(
                textStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                ),
              )),
          SizedBox(width: 90,),
          Text(widget.flightTwo,
              style: GoogleFonts.oswald(
                textStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                ),
              )),
          SizedBox(width: 35,),

        ],
    );
  }

  futureTimes(){
    Future<dynamic> database; //= connectToDB();
    database = connectToDB_Times();

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
                    buildFlightTimes(),
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
  buildFlightTimes(){
    //connectToDB_Durations();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10,),
        Expanded(
        child:Text(
        "Scheduled:",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ))),
        SizedBox(width:20,),
        Expanded(
        child:Text(
        times1,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ))),
        SizedBox(width: 20,),
        Expanded(
        child:Text(
        times2,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ))),
      ],
    );
  }

  /*futureTimeTrends(){
    Future<dynamic> database; //= connectToDB();
    database = connectToDB_TimeTrends();

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
                    buildFlightTimes(),
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
  buildFlightTimeTrends(){
    return Row(
      children: [
        Text("flight one stats"),
        Text("flight two stats"),

      ],
    );
  }
  */
  futureDurations(){
    Future<dynamic> database; //= connectToDB();
    database = connectToDB_Durations();

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
                    buildFlightDurations(),
                    SizedBox(height:20),
                    buildFlightDurationTrends()
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
  buildFlightDurations(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10,),
        Expanded(
        child:Text(
        "Duration:",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ))),
        SizedBox(width:50,),
        Expanded(
        child:Text(
        duration1,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ))),
        SizedBox(width: 20,),
        Expanded(
        child:Text(
        duration2,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ))),
      ],
    );
  }

  buildFlightDurationTrends(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10,),
        Expanded(
        child:Text(
        "Trending \nDuration:",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ))),
        SizedBox(width:50,),
        Expanded(
        child:Text(
        trend_duration1,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ))),
        SizedBox(width: 20,),
        Expanded(
        child:Text(
        trend_duration2,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ))),
      ],
    );
  }

  futurePercentages(){
    Future<dynamic> database; //= connectToDB();
    database = connectToDB_Percentages();

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
                    buildFlightPercentages(),
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
  buildFlightPercentages(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10,),
        Expanded(
            child:Text(
            "On time:",
            style: GoogleFonts.oswald(
            textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            ),
          ))),
        SizedBox(width:60,),
        Expanded(
            child:Text(
          onTimePerc1,
          style: GoogleFonts.lato(
          textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          ),
        ))),
        SizedBox(width: 20,),
        Expanded(
            child:Text(
                onTimePerc2,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
            )),
      ],
    );
  }

  futureStatuses(){
    Future<dynamic> database; //= connectToDB();
    database = connectToDB_Statuses();

    return Container(
        child: database == null
            ? Text('no stat db')
            : FutureBuilder(
            future: database,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("snapshot has data");
                return Column(
                  children: [
                    buildFlightStatuses(),
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
  buildFlightStatuses(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10,),
        Expanded(
          child:Text(
              "Status:",
              style: GoogleFonts.oswald(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )),
        ),
        SizedBox(width:15,),
        Text(
              status1,
              style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )),
        SizedBox(width: 40),
        Expanded(
          child:Text(
            status2,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ))
        ),
      ],
    );
  }

  //db connections
  // ignore: non_constant_identifier_names
  connectToDB_Times() async {
    // connect
    final connection = await MySqlConnection.connect(new ConnectionSettings(
        host: '34.123.203.246',
        port: 3306,
        user: 'root',
        password: '12345',
        db: 'flightDB'
    ));

    var results = await connection.query("select depart_time, arrive_time from ryanair_flights where flight_no like '${widget.flightOne}' or flight_no like '${widget.flightTwo}';");


    // times for display
    times1 = results.first['depart_time'] + " - " + results.first['arrive_time'];
    times2 = results.last['depart_time'] + " - " + results.last['arrive_time'];

    // close connection
    await connection.close();

    return Future<dynamic>.delayed(Duration(seconds: 0), () async => 0);
  }

  // ignore: non_constant_identifier_names
  connectToDB_Percentages() async{
    // connect
    final connection = await MySqlConnection.connect(new ConnectionSettings(
        host: '34.123.203.246',
        port: 3306,
        user: 'root',
        password: '12345',
        db: 'flightDB'
    ));

    var results = await connection.query("select track_stat from statistics where flight_no like '${widget.flightOne}' or flight_no like '${widget.flightTwo}';");

    print(results);
    var newNum;

    onTimePerc1 = results.first['track_stat'];
    onTimePerc2 = results.last['track_stat'];

    if(onTimePerc1 == "100.0"){
      onTimePerc1 = "100%";
    }
    else if (onTimePerc1.length > 2){
      if(onTimePerc1[1] == '.'){
        newNum = onTimePerc1[0];
      }
      else{
        newNum = onTimePerc1[0]+ onTimePerc1[1];
      }
      onTimePerc1 = newNum.toString() + "%";
    }
    if(onTimePerc2 == "100.0"){
      onTimePerc2 = "100%";
    }
    else if (onTimePerc2.length > 2){
      if(onTimePerc2[1] == '.'){
        newNum = onTimePerc2[0];
      }
      else{
        newNum = onTimePerc2[0]+ onTimePerc2[1];
      }
      onTimePerc2 = newNum.toString() + "%";
    }

    // close connection
    await connection.close();

    return Future<dynamic>.delayed(Duration(seconds: 0), () async => 0);
  }

  // ignore: non_constant_identifier_names
  connectToDB_Statuses() async{
    // connect
    final connection = await MySqlConnection.connect(new ConnectionSettings(
        host: '34.123.203.246',
        port: 3306,
        user: 'root',
        password: '12345',
        db: 'flightDB'
    ));

    var results = await connection.query("select flight_status from ryanair_flights where flight_no like '${widget.flightOne}' or flight_no like '${widget.flightTwo}';");


    status1 = results.first['flight_status'];
    status2 = results.last['flight_status'];

    status1 = status1.replaceAll('_', ' ');
    status2 = status2.replaceAll('_', ' ');

    // close connection
    await connection.close();

    return Future<dynamic>.delayed(Duration(seconds: 0), () async => 0);

  }

  // ignore: non_constant_identifier_names
  connectToDB_Durations() async{
    // connect
    final connection = await MySqlConnection.connect(new ConnectionSettings(
        host: '34.123.203.246',
        port: 3306,
        user: 'root',
        password: '12345',
        db: 'flightDB'
    ));

    var results = await connection.query("select cur_dur, track_dur from statistics where flight_no like '${widget.flightOne}' or flight_no like '${widget.flightTwo}';");

    print(results);

    //var h, m = "";
    duration1 = results.first['cur_dur'];
    var h = duration1.split('.');
    duration1 = h[0] + "h " + h[1] + "m";

    duration2 = results.last['cur_dur'];
    h = duration2.split('.');
    duration2 = h[0] + "h " + h[1] + "m";


    trend_duration1 = results.first['track_dur'];
    h = trend_duration1.split('.');
    trend_duration1 = h[0] + "h " + h[1] + "m";
    trend_duration2 = results.last['track_dur'];
    h = trend_duration2.split('.');
    trend_duration2 = h[0] + "h " + h[1] + "m";


    // close connection
    await connection.close();

    return Future<dynamic>.delayed(Duration(seconds: 0), () async => 0);

  }


}
