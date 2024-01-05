import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/booking_screen.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/orders.dart';
import 'package:frontend/utils/functions.dart';
import 'package:transparent_image/transparent_image.dart';

class RoomDetail extends StatefulWidget {
  const RoomDetail({super.key, required this.room});
  final Map<dynamic, dynamic> room;
  @override
  State<RoomDetail> createState() {
    return _RoomDetailState();
  }
}

class _RoomDetailState extends State<RoomDetail> {
  @override
  void initState() {
    super.initState();
    print(widget.room);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.room['number']}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                ),
                clipBehavior: Clip.hardEdge,
                height: 200,
                child: Swiper(
                  loop: false,
                  pagination: const SwiperPagination(),
                  itemCount: widget.room['image'].split(' ').length,
                  itemBuilder: (context, index) => Card(
                    clipBehavior: Clip.hardEdge,
                    child: Hero(
                      tag: widget.room['id'],
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(
                            widget.room['image'].split(' ')[index]),
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Text(
                  'Room number: ',
                  style: customTextStyle,
                ),
                trailing: Text(
                  '${widget.room['number']}',
                  style: customTextStyle,
                ),
              ),
              ListTile(
                leading: Text(
                  'Number of beds: ',
                  style: customTextStyle,
                ),
                trailing: Text(
                  '${widget.room['number_of_beds']}',
                  style: customTextStyle,
                ),
              ),
              ListTile(
                leading: Text(
                  'Number of restrooms: ',
                  style: customTextStyle,
                ),
                trailing: Text(
                  '${widget.room['number_of_restrooms']}',
                  style: customTextStyle,
                ),
              ),
              ListTile(
                leading: Text(
                  'Number of wardrobes: ',
                  style: customTextStyle,
                ),
                trailing: Text(
                  '${widget.room['number_of_wardrobes']}',
                  style: customTextStyle,
                ),
              ),
              ListTile(
                leading: Text(
                  'Price: ',
                  style: customTextStyle,
                ),
                trailing: Text(
                  '${widget.room['price']}\$/per night',
                  style: customTextStyle,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        token.isEmpty
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              )
                            : showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    BookingScreen(room: widget.room),
                              );
                      },
                      style: customButtonStyle,
                      child: const Text('Book'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
