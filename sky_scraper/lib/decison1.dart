import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sky_scraper/drop_list_1.dart';
import 'destinationDecision.dart';
import 'dart:async';

class Decision1Route extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Decision1RouteState();
  }
}
enum DropListChoice {climate, destination}


class _Decision1RouteState extends State<Decision1Route> {

  //String dropdownValue = 'One';
  DropListChoice dListChoice = DropListChoice.destination;

  OptionItem optionItemSelectedDep = OptionItem(id: "", title: "Select");
  //OptionItem optionItemSelectedClim = OptionItem(id: null, title: "Select");
  //OptionItem optionItemSelectedDes = OptionItem(id: null, title: "Select");
  DropListModel dropListDepart = DropListModel([
    OptionItem(id: "1", title: "Spain"),
    OptionItem(id: "2", title: "England"),
    OptionItem(id: "3", title: "Wales"),
    OptionItem(id: "4", title: "Scotland"),
    OptionItem(id: "5", title: "Ireland"),
    OptionItem(id: "6", title: "France")
  ]);



  DropListModel dropListClimate = DropListModel([
    OptionItem(id: "1", title: "Hot"),
    OptionItem(id: "2", title: "Mild"),
    OptionItem(id: "3", title: "Cold"),
    OptionItem(id: "4", title: "Seasonal"),
  ]);
/* DropListModel dropListDestination = DropListModel([
    OptionItem(id: "1", title: "Spain"),
    OptionItem(id: "2", title: "England"),
    OptionItem(id: "3", title: "Wales"),
    OptionItem(id: "4", title: "Scotland"),
    OptionItem(id: "5", title: "Ireland"),
    OptionItem(id: "6", title: "France")
  ]);*/

  DateTime selectedDate = DateTime.now();


  @override
  StatefulWidget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height:50),
                  Text("Departing:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DancingScript',
                        ),
                      )
                  ),
                  SizedBox(height:30),
                  //dropdown here
                  SelectDropList(
                    this.optionItemSelectedDep,
                    this.dropListDepart,
                        (optionItem){
                      optionItemSelectedDep = optionItem;
                      setState(() {
                      });
                    },
                  ),
                  SizedBox(height:30),
                  Text("Choose Climate or Destination:",
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'DancingScript',
                        ),
                      )),
                  //radio button
                  for(var choice in DropListChoice.values)
                    RadioListTile (
                      title: Text(choice.toString().replaceAll("DropListChoice.", "").replaceAll("c", "C").replaceAll("d", "D")),
                      value: choice,
                      activeColor: Colors.blue,
                      groupValue: dListChoice,
                      onChanged: (DropListChoice value){
                        setState(() {
                          print(value);
                          dListChoice = value;
                          print(dListChoice);
                        });

                      },
                    ),
                  SizedBox(height:30),
                  // dropdown here for destinations
                  //generateDropdown(),

                  SizedBox(height:50),
                  Text("Date of departure:" + selectedDate.day.toString() +"/"+
                      selectedDate.month.toString()+"/"+selectedDate.year.toString(),
                      style: GoogleFonts.oswald(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                  SizedBox(height:15),

                  RaisedButton(
                    onPressed: ()=>selectDate(context),
                    child: Text("Select Date",
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        )
                    ),
                    padding:  EdgeInsets.all(20.0),
                  ),
                  // calendar to select date here
                ]
            ),
          )

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
                MaterialPageRoute(builder: (context) => DestinationRoute())
            );
          }
        },
      ),
    );
  }

  //Create dropdown for climate or dropdown for destination
  //depending on selection
/*  Widget generateDropdown(){
    print("gendrop"+dListChoice.toString());

    switch(dListChoice){
      case DropListChoice.climate:
        return SelectDropList(
          this.optionItemSelectedClim,
          this.dropListClimate,
              (optionItem){
            optionItemSelectedClim = optionItem;
            setState(() {
            });
          });
        break;
      case DropListChoice.destination:
        return SelectDropList(
            this.optionItemSelectedDes,
            this.dropListDestination,
                (optionItem){
              optionItemSelectedDes = optionItem;
              setState(() {
              });
            });
      default:
        return SelectDropList(
            this.optionItemSelectedDes,
            this.dropListDestination,
                (optionItem){
              optionItemSelectedDes = optionItem;
              setState(() {
              });
            });
        break;
    }
  }
*/
  //Date Selector
  Future<void> selectDate(BuildContext context)async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020,12),
        lastDate: DateTime(2021,12));
    if(picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

