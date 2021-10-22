import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class DashboardRoute extends StatefulWidget {
  const DashboardRoute({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<DashboardRoute> {
  User? _user;

  void _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiToken = prefs.getString('apiToken');

    if (apiToken != null) {
      _user = await User.fromApiToken(apiToken);

      if (_user != null) {
        setState(() {});

        return;
      }
    }

    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('apiToken');
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Welcome back " +
                    (_user?.email ?? 'email') +
                    " with " +
                    (_user?.name ?? 'name') +
                    "!"),
                ElevatedButton(onPressed: _handleLogout, child: Text("Keluar"))
              ],
            ))));
  }
}
