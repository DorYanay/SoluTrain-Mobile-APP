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

          // TODO: This is only example that show data from server that saved in the app on login
          const Text('This is only example that show'),
          const SizedBox(height: 5),
          const Text('data from server that'),
          const SizedBox(height: 5),
          const Text('saved in the app on login'),
          const SizedBox(height: 15),
          Text('authToken: ${Provider.of<AppModel>(context).authToken!}'),
          const SizedBox(height: 15),
          Text('user.name: ${Provider.of<AppModel>(context).user!.name}'),
          const SizedBox(height: 10),
          Text('user.email: ${Provider.of<AppModel>(context).user!.email}'),
          const SizedBox(height: 10),
          Text('user.phone: ${Provider.of<AppModel>(context).user!.phone}'),
          const SizedBox(height: 10),
          Text('user.gender: ${Provider.of<AppModel>(context).user!.gender}'),
          const SizedBox(height: 10),
          Text('user.isCoach: ${Provider.of<AppModel>(context).user!.isCoach}'),
          const SizedBox(height: 15),
          Text('areas.length: ${Provider.of<AppModel>(context).areas.length}'),
        ],
      ),
    );
  }
}
