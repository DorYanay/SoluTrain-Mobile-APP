import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/app_model.dart';
import 'package:mobile/api.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // method to log user out
  void logUserOut(BuildContext context) {
    API.post(context, '/auth/logout').then((value) {
      Provider.of<AppModel>(context, listen: false).setLogout();
    }).onError((error, stackTrace) {
      Provider.of<AppModel>(context, listen: false).setLogout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[300],
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: Icon(
                Icons.phone_iphone_rounded,
                size: 64,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              onTap: () => logUserOut(context),
              title: Text(
                "LOGOUT",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
