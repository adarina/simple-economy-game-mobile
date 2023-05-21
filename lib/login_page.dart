import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:simple_econmy_game/home_page.dart';
import 'package:simple_econmy_game/models/user.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final url = Uri.parse('http://localhost:8080/api/users/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': username, 'password': password});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String accessToken = responseData['accessToken'];
      int userId = responseData['id'];

      User user = User(username, password, userId, accessToken);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 112, 112),
        title: const Text('Login'),
      ),
      backgroundColor: const Color.fromARGB(255, 250, 244, 211), // Zmi
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                fillColor: Color.fromARGB(255, 134, 150, 103),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 134, 150, 103)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 134, 150, 103)),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                fillColor: Color.fromARGB(255, 134, 150, 103),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 134, 150, 103)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 134, 150, 103)),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 134, 150, 103)),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
