/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-03 17:16:03
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-04 17:57:23
/// @FilePath: lib/pages/home.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passenger/widgets/CustomRideOverview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userData, required this.id});
  final Map<String, dynamic> userData;
  final String id;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController tabController;
  final Stream<QuerySnapshot> availableRides = FirebaseFirestore.instance
      .collection('Rides')
      .where("status", isEqualTo: "pending")
      .snapshots();
  final Stream<QuerySnapshot> myRides = FirebaseFirestore.instance
      .collection('Rides')
      .where("status", isEqualTo: "pending")
      .snapshots();

  @override
  void initState() {
    // TODO: implement initState
    print(widget.userData);
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(controller: tabController, tabs: [
            Tab(
              text: "Available Rides",
            ),
            Tab(
              text: "My Schedule",
            )
          ]),
          automaticallyImplyLeading: false,
          leading: widget.userData != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.userData["image"]))),
                  ),
                )
              : SizedBox(),
          backgroundColor: Colors.transparent,
          title: Text("KongsiKereta"),
        ),
        body: TabBarView(controller: tabController, children: [
          StreamBuilder<QuerySnapshot>(
            stream: availableRides,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              final availableRides = snapshot.data!.docs.where((doc) {
                return (doc["driver"]["capacity"] > doc["passengerCount"] &&
                    !doc["passengerIds"].contains(widget.id));
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  itemCount: availableRides.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomRideOverview(
                      ride:
                          availableRides[index].data() as Map<String, dynamic>,
                      rideId: availableRides[index].id,
                      myRide: false,
                      myId: widget.id,
                      userData: widget.userData,
                    );
                  },
                ),
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: myRides,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              final availableRides = snapshot.data!.docs.where((doc) {
                return (doc["passengerIds"].contains(widget.id));
              }).toList();

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  itemCount: availableRides.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomRideOverview(
                      ride:
                          availableRides[index].data() as Map<String, dynamic>,
                      rideId: availableRides[index].id,
                      myRide: true,
                      myId: widget.id,
                      userData: widget.userData,
                    );
                  },
                ),
              );
            },
          )
        ]),
      ),
    );
  }
}
