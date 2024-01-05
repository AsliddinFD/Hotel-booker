import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/functions.dart';
import 'package:frontend/utils/urls.dart';
import 'package:http/http.dart' as http;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() {
    return _OrdersScreenState();
  }
}

class _OrdersScreenState extends State<OrdersScreen> {
  String bookingStatus = 'Upcoming';

  @override
  void initState() {
    super.initState();
    getBookings();
  }

  var responseDate = [];
  getBookings() async {
    final response = await http.get(
      Uri.parse(listBookings),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        responseDate = json.decode(response.body);
      });
    }
  }

  void getBookingStatus() {
    for (var index in responseDate) {
      if (DateTime.parse(responseDate[index]['ending_date'])
          .isBefore(DateTime.now())) {
        setState(() {
          bookingStatus = 'Passed';
        });
      } else if (DateTime.now()
              .isAfter(DateTime.parse(responseDate[index]['starting_date'])) &&
          DateTime.now().isBefore(
            DateTime.parse(responseDate[index]['ending_date']),
          )) {
        setState(() {
          bookingStatus = 'Processing';
        });
      }
    }
  }

  void cancelTheBooking(int bookingID) async {
    final response = await http.delete(
      Uri.parse(cancelBooking.replaceAll('id', bookingID.toString())),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 204 && context != null && context!.mounted) {
      getBookings();
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          content: Text('Booking is cancelled'),
        ),
      );
    }
  }

  askUserPermission(bookingID) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          content: const Text('Do you want to cancel the booking?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    cancelTheBooking(bookingID);
                    getBookings();
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ],
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('Do you want to cancel the booking?'),
          actions: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                const SizedBox(width: 100),
                TextButton(
                  onPressed: () {
                    cancelTheBooking(bookingID);
                    getBookings();
                    Navigator.pop(context);
                  },
                  child: const Text('Yes'),
                ),
              ],
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: token.isEmpty
          ? const Center(
              child: Text('Please, login to see your bookings'),
            )
          : responseDate.isEmpty
              ? const Center(
                  child: Text('You have no bookings, create some'),
                )
              : ListView.builder(
                  itemCount: responseDate.length,
                  itemBuilder: (context, index) => Stack(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Room Number: ',
                                    style: customTextStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    responseDate[index]['room'].toString(),
                                    style: customTextStyle,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Price: ',
                                    style: customTextStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${responseDate[index]['price']}\$/night',
                                    style: customTextStyle,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Starting Date: ',
                                    style: customTextStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${responseDate[index]['starting_date']}',
                                    style: customTextStyle,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Ending date: ',
                                    style: customTextStyle,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${responseDate[index]['ending_date']}',
                                    style: customTextStyle,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        await askUserPermission(
                                          responseDate[index]['id'],
                                        );
                                        getBookings();
                                      },
                                      child: const Text('Cancel the book'),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(bookingStatus),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
