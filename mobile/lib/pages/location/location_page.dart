import 'package:flutter/material.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/schemas.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  AreaSchema? selectedOption; // Make the selectedOption variable nullable

  @override
  Widget build(BuildContext context) {
    print(Provider.of<AppModel>(context).areas);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 70.0),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: Icon(
              Icons.location_on_outlined,
              size: 200.0,
              color: Colors.black12,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Text('Select your area', style: TextStyle(fontSize: 40.0)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 50.0),
            // margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Text(
              'Choose the area where you want to train',
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
            ),
          ),
          DropdownButtonHideUnderline(
            // Hide the default underline of the DropdownButton
            child: DropdownButton<AreaSchema>(
              value: selectedOption, // Set the selected option value
              onChanged: (AreaSchema? newValue) {
                // Make the newValue nullable
                setState(() {
                  selectedOption =
                      newValue; // Update the selected option value when user makes a selection
                });
              },
              items: Provider.of<AppModel>(context)
                  .areas
                  .map<DropdownMenuItem<AreaSchema>>((AreaSchema area) {
                return DropdownMenuItem<AreaSchema>(
                  value: area,
                  child: Text(area.name), // Display the option text
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement the functionality for the "Continue" button
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}
