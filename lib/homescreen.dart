import 'package:appattendance/calendarscreen.dart';
import 'package:appattendance/model/user.dart';
import 'package:appattendance/profilescreen.dart';
import 'package:appattendance/services/location_service.dart';
import 'package:appattendance/todayscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  String id = " ";
  Color primary = const Color(0xffeef444c);
  int currentIndex = 1;
  List<IconData> navigationIcons = [
    FontAwesomeIcons.calendarAlt,
    FontAwesomeIcons.check,
    FontAwesomeIcons.user,
  ];

  @override
  void initState() {
    super.initState();
    _startLocationService();
    getId();
  }

void _startLocationService() async{
    LocationService().initialize();

    LocationService().getLongitude().then((value){
      setState(() {
        User.long = value!;
      });
    });

    LocationService().getLatitude().then((value){
      setState(() {
        User.lat = value!;
      });
    });
}

  void getId() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection("Employee")
        .where('id', isEqualTo: User.employeeId)
        .get();
    setState(() {
      User.id = snap.docs[0].id;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          CalendarScreen(),
          TodayScreen(),
          ProfileScreen(),
        ],
      ),
      // body: Center(
      //   child: Text(
      //     "Welcome to Home Screen",
      //     style: TextStyle(
      //       fontFamily: "NexaBold",
      //       fontSize: 30,
      //       fontWeight: FontWeight.w900,
      //       letterSpacing: 2.5,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 60, offset: Offset(3, 3)),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    child: Container(
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color:
                                  i == currentIndex ? primary : Colors.black26,
                              size: i == currentIndex ? 30 : 24,
                            ),
                            i == currentIndex
                                ? Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 3,
                                    width: 22,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40)),
                                        color: primary),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
