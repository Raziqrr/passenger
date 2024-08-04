/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-03 17:16:40
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-04 19:18:54
/// @FilePath: lib/pages/detail.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(
      {super.key,
      required this.ride,
      required this.userData,
      required this.rideId,
      required this.myRide,
      required this.myId});
  final Map<String, dynamic> ride;
  final Map<String, dynamic> userData;
  final String rideId;
  final bool myRide;
  final String myId;

  void JoinRide(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final rideRef = db.collection("Rides").doc("${rideId}");
    rideRef.update({
      "passengers": FieldValue.arrayUnion([userData]),
      "passengerIds": FieldValue.arrayUnion([myId]),
      "passengerCount": FieldValue.increment(1)
    }).then((value) => Navigator.pop(context),
        onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Ride Details"),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ride["date"]),
                          Text(ride["time"]),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black),
                              ),
                              Container(
                                height: 30,
                                child: VerticalDivider(
                                  thickness: 4,
                                  color: Colors.black,
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 15,
                                    width: 15,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ride["origin"]),
                              Container(
                                height: 30,
                              ),
                              Text(ride["destination"])
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                              "Passengers ${ride["passengerCount"]}/${ride["driver"]["capacity"]}")
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: ride["passengers"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(ride["passengers"][index]["name"]),
                            leading: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          ride["passengers"][index]["image"]))),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: (ride["passengers"].length) -
                            (ride["driver"]["capacity"]),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(ride["passengers"][index]["name"]),
                            leading: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Price"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("RM${ride["price"]}"), Text("/seat")],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Driver"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(ride["driver"]["image"]))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ride["driver"]["name"]),
                              Text(ride["driver"]["gender"]),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone),
                          SizedBox(
                            width: 10,
                          ),
                          Text(ride["driver"]["phone"])
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [Text("Vehicle status")],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ride["driver"]["carModel"]),
                              Text(ride["driver"]["carBrand"])
                            ],
                          ),
                          Column(
                            children: [
                              Text(ride["driver"]["carPlateNumber"]),
                              Text("")
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("Special Features"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                ride["driver"]["carSpecialFeatures"].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Text(
                                  ride["driver"]["carSpecialFeatures"][index]);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if (myRide == false)
                ElevatedButton(
                    onPressed: () {
                      JoinRide(context);
                    },
                    child: Text("Join"))
            ],
          ),
        ),
      ),
    );
  }
}
