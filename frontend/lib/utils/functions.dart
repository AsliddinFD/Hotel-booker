import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

String token = '';
String name = '';
String email = '';
late int userId;
void login(email, password) async {
  final response = await http.post(
    Uri.parse(loginApi),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(
      {'email': email, 'password': password},
    ),
  );

  if (response.statusCode == 200) {
    token = json.decode(response.body)['token'];
  }
}

bool isEmailValid(String email) {
  RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  return regex.hasMatch(email);
}

customInputDesign(String title) {
  return InputDecoration(
    hintText: title,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(17),
    ),
  );
}

final customButtonStyle = ElevatedButton.styleFrom(
  elevation: 1,
  backgroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 12,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    side: const BorderSide(width: 1, color: Colors.black),
  ),
);

TextStyle customTextStyle = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

void showMessage(String msg, BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}

bool switchVal = false;

void getUserInfo() async {
  final response = await http.get(
    Uri.parse(getUserInfoApi),
    headers: {
      'Authorization': 'Token $token',
    },
  );

  if (response.statusCode == 200) {
    final responseDate = json.decode(response.body);

    name = responseDate['name'];
    email = responseDate['email'];
    userId = responseDate['id'];
  } else {
    print(
      'Failed to retrieve user information. Status code: ${response.statusCode}',
    );
  }
}

bool userPermission = false;

