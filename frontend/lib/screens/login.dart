import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/orders.dart';
import 'package:frontend/screens/register.dart';
import 'package:frontend/screens/tabs.dart';
import 'package:frontend/utils/functions.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void loginUser(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      showMessage('Please make sure that you filled all fields', context);
    } else {
      final response = await http.post(
        Uri.parse(loginApi),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {'email': email, 'password': password},
        ),
      );
      if (response.statusCode == 200 && context.mounted) {
        token = json.decode(response.body)['token'];
        getUserInfo();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const TabsScreen(),
          ),
        );
      } else {
        print(response.body);
        showMessage('Please provide correct email and password', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: customInputDesign('Enter your email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: customInputDesign('Enter your password'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: customButtonStyle,
                        onPressed: () {
                          loginUser(
                            _emailController.text,
                            _passwordController.text,
                          );
                        },
                        child: Text(
                          'Login',
                          style: customTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text('New user? Register here.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
