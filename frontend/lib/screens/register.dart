import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/utils/urls.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/utils/functions.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() async {
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords did not match'),
          duration: Duration(seconds: 4),
        ),
      );
    } else if (isEmailValid(emailController.text) == false) {
      showMessage('Enter a valid email', context);
    } else if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty || nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please make sure that you have filled all the fields'),
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      final response = await http.post(
        Uri.parse(registerApi),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name':nameController.text,
            'email': emailController.text,
            'password': passwordController.text,
          },
        ),
      );

      if (response.statusCode > 200 &&
          response.statusCode < 400 &&
          context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully registered'),
            duration: Duration(seconds: 4),
          ),
        );
        login(emailController.text, passwordController.text);
        setState(() {
          name = nameController.text;
        });
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              json.decode(response.body)['email'][0],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: customInputDesign('Enter your full name please'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: customInputDesign('Enter your email please'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: customInputDesign('Please, create a password'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  decoration:
                      customInputDesign('Please, confirm your password'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: register,
                        style: customButtonStyle,
                        child: Text(
                          'Register',
                          style: customTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text('Already have account?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
