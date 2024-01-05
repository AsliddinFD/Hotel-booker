import 'dart:convert';
import 'package:frontend/screens/orders.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/urls.dart';
import 'package:frontend/utils/functions.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.room});
  final Map<dynamic, dynamic> room;
  @override
  State<BookingScreen> createState() {
    return _BookScreenState();
  }
}

class _BookScreenState extends State<BookingScreen> {
  dynamic startingDate;
  dynamic endingDate;

  void selectStartingDate() async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate = startingDate ?? currentDate;
    final roomStartingDate = widget.room['booking_start_date'] == null
        ? DateTime.now()
        : DateTime.parse(widget.room['booking_start_date']);
    final roomEndingDate = widget.room['booking_start_date'] == null
        ? DateTime.now()
        : DateTime.parse(widget.room['booking_end_date']);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: startingDate ?? DateTime.now(),
      lastDate: DateTime(2025),
      selectableDayPredicate: (DateTime day) {
        return day.isAfter(roomStartingDate) && day.isBefore(roomEndingDate)
            ? false
            : true;
      },
    );

    if (picked != null && picked != startingDate) {
      setState(() {
        startingDate = picked;
      });
    }
  }

  void selectEndingDate() async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate = startingDate ?? currentDate;
    final roomStartingDate = widget.room['booking_start_date'] == null
        ? DateTime.now()
        : DateTime.parse(widget.room['booking_start_date']);
    final roomEndingDate = widget.room['booking_start_date'] == null
        ? DateTime.now()
        : DateTime.parse(widget.room['booking_end_date']);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: startingDate ?? DateTime.now(),
      lastDate: DateTime(2025),
      selectableDayPredicate: (DateTime day) {
        return day.isAfter(roomStartingDate) && day.isBefore(roomEndingDate)
            ? false
            : true;
      },
    );

    if (picked != null && picked != endingDate) {
      setState(() {
        endingDate = picked;
      });
    }
  }

  void book() async {
    try {
      if (startingDate != null && endingDate != null) {
        final response = await http.post(
          Uri.parse(bookRoom),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json'
          },
          body: json.encode(
            {
              'is_cancelled': false,
              'starting_date': DateFormat('yyyy-MM-dd').format(startingDate),
              'ending_date': DateFormat('yyyy-MM-dd').format(endingDate),
              'room': widget.room['id'],
              'customer': userId,
              'price': widget.room['price']
            },
          ),
        );
        if (response.statusCode == 200 && context.mounted) {
          Navigator.pop(context);
        } else {
          print(response.body);
        }
      } else {
        showMessage('Please, choose the date', context);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('Please select a starting date'),
                trailing: startingDate == null
                    ? IconButton(
                        onPressed: selectStartingDate,
                        icon: const Icon(Icons.calendar_month),
                      )
                    : GestureDetector(
                        onTap: selectStartingDate,
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(startingDate),
                        ),
                      ),
              ),
              ListTile(
                leading: const Text('Please select a ending date'),
                trailing: endingDate == null
                    ? IconButton(
                        onPressed: selectEndingDate,
                        icon: const Icon(Icons.calendar_month),
                      )
                    : GestureDetector(
                        onTap: selectEndingDate,
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(endingDate),
                        ),
                      ),
              ),
              ElevatedButton(
                onPressed: () {
                  book();
                  Navigator.pop(context);
                },
                child: const Text('Book the room'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
