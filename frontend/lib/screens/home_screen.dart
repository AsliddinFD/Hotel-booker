import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/room_details.dart';
import 'package:frontend/utils/urls.dart';
import 'package:frontend/widget/room_trait.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getRooms();
  }

  late Widget mainWidget;
  List responseData = [];
  getRooms() async {
    final response = await http.get(
      Uri.parse(listRooms),
    );
    responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(
        () {
          mainWidget = ListView.builder(
            itemCount: responseData.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.hardEdge,
              elevation: 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomDetail(
                        room: responseData[index],
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Hero(
                      tag: responseData[index]['id'],
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(
                            responseData[index]['image'].split(' ')[0]),
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 44),
                        child: Column(
                          children: [
                            Text(
                              '\$${responseData[index]['price']}/per night',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RoomTrait(
                                  icon: CupertinoIcons.bed_double,
                                  label: responseData[index]['number_of_beds']
                                      .toString(),
                                ),
                                const SizedBox(width: 10),
                                RoomTrait(
                                  icon: Icons.bathtub_outlined,
                                  label: responseData[index]
                                          ['number_of_restrooms']
                                      .toString(),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: responseData.isEmpty
          ? const Center(
              child: Text('You have nothing to do yet.'),
            )
          : mainWidget,
    );
  }
}
