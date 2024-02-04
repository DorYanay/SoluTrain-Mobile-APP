import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile/schemas.dart';
import 'package:http/http.dart' as http;

class CoachProfilePage extends StatefulWidget {
  const CoachProfilePage({super.key});

  @override
  State<CoachProfilePage> createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage>{
  String userId = "userId";
  User user = new User("bla", "ori", "ori@gmail.com", "231232", "d", "melech ahoosharmoota", false, true);
  void getUserDataFormApi( ) async {
    var url = Uri.parse("http://endpoint/user/$userId");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        user = data;
      });
    }
  }

    @override
    void initState() {
      super.initState();
      getUserDataFormApi();
      print("hgfhf");
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[850],
          elevation: 0.0,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/handsomeGuy.jpg'),
                  radius: 80.0,
                ),
              ),
              Divider(
                height: 60.0,
                color: Colors.grey[800],
              ),
              Text(
                'Name',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0,),
              Text(
                  user.name,
                  style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 20.0,),
              Text(
                'Status',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0,),
              Text(
                  user.isTrainer ? "yes" : "no",
                  style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2.0,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 20.0,),
              Text(
                'Expertise',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0,),
              Text(
                  'Pilates, Strength training, Functional training',
                  style: TextStyle(
                      color: Colors.amberAccent[200],
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(height: 20.0,),
              Text(
                'Schedule',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_month,
                    color: Colors.grey[400],
                    size: 35.0,
                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    'To view available trainings',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              Text(
                'Contact',
                style: TextStyle(
                  color: Colors.grey,
                  letterSpacing: 2.0,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.grey[400],
                    size: 35.0,
                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    user.name,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: Colors.grey[400],
                    size: 35.0,

                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    user.phone,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.location_city,
                    color: Colors.grey[400],
                    size: 35.0,

                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    'Rosh Haayin,Ohaley Kedar',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 18.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ); //scaffold
    }
}
