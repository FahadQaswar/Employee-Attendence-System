// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'model/user.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xffeef444c);
  String checkIn = "--/--";
  String checkOut = "--/--";
  String location = "";

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void _getLocation() async{
    List<Placemark> placemark = await placemarkFromCoordinates(User.long, User.lat);
    setState(() {
      location = "${placemark[0].street}, ${placemark[0].administrativeArea}, ${placemark[0].postalCode}, ${placemark[0].country}";
    });
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Employee")
          .where('id', isEqualTo: User.employeeId)
          .get();
      // print(snap.docs[0].id);
      // print(DateFormat('dd MMMM yyyy').format(DateTime.now()));
      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Employee")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();
      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Welcome",
              style: TextStyle(
                color: Colors.black54,
                fontFamily: "NexaRegular",
                fontSize: screenWidth / 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "Employee ${User.employeeId}",
              style: TextStyle(
                color: primary,
                fontFamily: "NexaBold",
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 32),
            child: Text(
              "Today's Status",
              style: TextStyle(
                fontFamily: "NexaBold",
                fontSize: screenWidth / 18,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 32),
            height: 150,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check In",
                        style: TextStyle(
                            fontFamily: "NexaRegular",
                            fontSize: screenWidth / 20,
                            color: Colors.black54),
                      ),
                      Text(
                        checkIn,
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Check Out",
                        style: TextStyle(
                            fontFamily: "NexaRegular",
                            fontSize: screenWidth / 20,
                            color: Colors.black54),
                      ),
                      Text(
                        checkOut,
                        style: TextStyle(
                          fontFamily: "NexaBold",
                          fontSize: screenWidth / 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: RichText(
                text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style: TextStyle(
                        color: primary,
                        fontSize: screenWidth / 18,
                        fontFamily: "NexaBold"),
                    children: [
                  TextSpan(
                      text: DateFormat("  MMMM yyyy").format(DateTime.now()),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "NexaBold",
                        fontSize: screenWidth / 20,
                      ))
                ])),
          ),
          StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat(" hh:mm:ss a").format(DateTime.now()),
                    style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54),
                  ),
                );
              }),
          checkOut == "--/--"
              ? Container(
                  margin: const EdgeInsets.only(top: 24, bottom: 12),
                  child: Builder(builder: (context) {
                    final GlobalKey<SlideActionState> key = GlobalKey();

                    return SlideAction(
                      text: checkIn == "--/--"
                          ? "Slide to Check In"
                          : "Slide to Check Out",
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaRegular",
                      ),
                      outerColor: Colors.white,
                      innerColor: primary,
                      key: key,
                      onSubmit: () async {
                        // Timer(const Duration(seconds: 1), (){
                        //
                        // });
                        // Future.delayed(Duration(milliseconds: 500),(){
                        //
                        // });
                        if(User.lat !=0){
                          _getLocation();
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Employee")
                              .where('id', isEqualTo: User.employeeId)
                              .get();
                          // print(snap.docs[0].id);
                          // print(DateFormat('dd MMMM yyyy').format(DateTime.now()));
                          DocumentSnapshot snap2 = await FirebaseFirestore
                              .instance
                              .collection("Employee")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy')
                              .format(DateTime.now()))
                              .get();

                          try {
                            String checkIn = snap2['checkIn'];
                            setState(() {
                              checkOut = DateFormat('hh:mm').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                .format(DateTime.now()))
                                .update({
                              'date': Timestamp.now(),
                              'checkIn': checkIn,
                              'checkOut':
                              DateFormat('hh:mm').format(DateTime.now()),
                              'CheckInLocation': location,
                            });
                          } catch (e) {
                            setState(() {
                              checkIn = DateFormat('hh:mm').format(DateTime.now());
                            });
                            await FirebaseFirestore.instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                .format(DateTime.now()))
                                .set({
                              'date': Timestamp.now(),
                              'checkIn':
                              DateFormat('hh:mm').format(DateTime.now()),
                              'checkOut': "--/--",
                              'CheckOutLocation': location,
                            });
                          }
                          key.currentState!.reset();
                        }else{
                          Timer(const Duration(seconds: 3), () async {
                            _getLocation();
                            QuerySnapshot snap = await FirebaseFirestore.instance
                                .collection("Employee")
                                .where('id', isEqualTo: User.employeeId)
                                .get();
                            // print(snap.docs[0].id);
                            // print(DateFormat('dd MMMM yyyy').format(DateTime.now()));
                            DocumentSnapshot snap2 = await FirebaseFirestore
                                .instance
                                .collection("Employee")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                .format(DateTime.now()))
                                .get();

                            try {
                              String checkIn = snap2['checkIn'];
                              setState(() {
                                checkOut = DateFormat('hh:mm').format(DateTime.now());
                              });

                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                                  .update({
                                'date': Timestamp.now(),
                                'checkIn': checkIn,
                                'checkOut':
                                DateFormat('hh:mm').format(DateTime.now()),
                                'CheckInLocation': location,
                              });
                            } catch (e) {
                              setState(() {
                                checkIn = DateFormat('hh:mm').format(DateTime.now());
                              });
                              await FirebaseFirestore.instance
                                  .collection("Employee")
                                  .doc(snap.docs[0].id)
                                  .collection("Record")
                                  .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                                  .set({
                                'date': Timestamp.now(),
                                'checkIn':
                                DateFormat('hh:mm').format(DateTime.now()),
                                'checkOut': "--/--",
                                'CheckOutLocation': location,
                              });
                            }
                            key.currentState!.reset();
                          });
                        }
                      },
                    );
                  }),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 32, bottom: 32),
                  child: Text(
                    "You have Completed this Day",
                    style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54),
                  ),
                ),
          location !=" "?Text(
            "Location: "+ location,
          ): const SizedBox(),
        ],
      ),
    )
    );
  }
}
