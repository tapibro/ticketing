import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart' as Constants;
import '../api/response.dart';

Future<ApiResponse> generateTokenAuth(String username, String password) async {
  ApiResponse apiResponse = new ApiResponse();
  final url = Uri.parse('${Constants.API_BASE_URL}api/user/create_token');

  try {
    final response = await http.post(url, body: {
      'email': username,
      'password': password,
      'token_name': 'flutter'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = response.body;
        break;
      case 401:
        apiResponse.errorMessage = response.body;
        break;
      default:
        apiResponse.errorMessage = response.body;
        break;
    }
  } on SocketException {
    apiResponse.errorMessage =
        'Terjadi kesalahan dalam menjalin koneksi. Silahkan coba beberapa saat lagi.';
  }

  return apiResponse;
}

class LoginRoute extends StatelessWidget {
  const LoginRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masuk'),
      ),
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Ticketing',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                )),
            MyCustomForm()
          ])),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  late ApiResponse _loginApiResponse;

  void _handleLogin() async {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      String _username = _usernameTextController.text;
      String _password = _passwordTextController.text;

      _loginApiResponse = await generateTokenAuth(_username, _password);

      if (_loginApiResponse.errorMessage == null) {
        _saveAndRedirectToDashboard();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_loginApiResponse.errorMessage!)),
        );
      }
    }
  }

  void _saveAndRedirectToDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiToken', _loginApiResponse.data as String);
    Navigator.pushNamedAndRemoveUntil(
        context, '/dashboard', ModalRoute.withName('/dashboard'));
  }

  @override
  void dispose() {
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
              controller: _usernameTextController,
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tolong masukkan nama pengguna Anda';
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nama pengguna',
                  icon: Icon(Icons.person))),
          TextFormField(
            controller: _passwordTextController,
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Tolong masukkan kata sandi Anda';
              }
              return null;
            },
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Kata sandi',
                icon: Icon(Icons.vpn_key)),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Masuk'),
            ),
          )),
        ],
      ),
    );
  }
}
