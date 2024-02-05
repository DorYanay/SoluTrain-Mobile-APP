import 'package:flutter/material.dart';
import 'package:mobile/schemas.dart';

class TrainerProfilePage extends StatefulWidget {
  const TrainerProfilePage({super.key});

  @override
  State<TrainerProfilePage> createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends State<TrainerProfilePage> {
  String userId = "userId";
  UserSchema user = UserSchema("bla", "ori", "ori@gmail.com", "231232", "d", "melech ahoosharmoota", false);

  @override
  void initState() {
    super.initState();
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
                "yes",
                style: TextStyle(
                    color: Colors.amberAccent[200],
                    letterSpacing: 2.0,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold
                )
            ),
            SizedBox(height: 20.0,),
            Text(
              'Personal information',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
                "16",
                style: TextStyle(
                    color: Colors.amberAccent[200],
                    letterSpacing: 2.0,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                )
            ),
            Text(
                'Activity level:',
                style: TextStyle(
                    color: Colors.amberAccent[200],
                    letterSpacing: 2.0,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                )
            ),
            Row(
              children: [
                Text(
                    'Gender:',
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    )
                ),
                Text(
                    user.gender,
                    style: TextStyle(
                        color: Colors.amberAccent[200],
                        letterSpacing: 2.0,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                    )
                ),
              ],
            ),
            SizedBox(height: 20.0,),
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
                  user.email,
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
            )
          ],
        ),
      ),
    ); //scaffold
  }
}

