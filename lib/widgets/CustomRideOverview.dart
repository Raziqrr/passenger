/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-04 16:13:09
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-04 18:06:59
/// @FilePath: lib/widgets/CustomRideOverview.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passenger/pages/detail.dart';

class CustomRideOverview extends StatelessWidget {
  const CustomRideOverview(
      {super.key,
      required this.ride,
      required this.rideId,
      required this.myRide,
      required this.myId,
      required this.userData});
  final Map<String, dynamic> ride;
  final Map<String, dynamic> userData;
  final String rideId;
  final bool myRide;
  final String myId;

  void JoinRide() {
    final db = FirebaseFirestore.instance;
    final rideRef = db.collection("Rides").doc("${rideId}");
    rideRef.update({
      "passengers": FieldValue.arrayUnion([userData]),
      "passengerIds": FieldValue.arrayUnion([myId]),
      "passengerCount": FieldValue.increment(1)
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return DetailPage(
            ride: ride,
            userData: userData,
            rideId: rideId,
            myRide: myRide,
            myId: myId,
          );
        }));
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            ride["driver"]["image"],
                            width: 40,
                            height: 40,
                            scale: 1,
                            fit: BoxFit.cover,
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(ride["driver"]["name"])
                    ],
                  ),
                  Container(
                    height: 20,
                    child: VerticalDivider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(ride["driver"]["carModel"]),
                      Text(ride["driver"]["carBrand"])
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(ride["status"]),
                  Container(
                    height: 15,
                    child: VerticalDivider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.yellow),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        Text(
                            "${ride["passengerCount"]}/${ride["driver"]["capacity"]}"),
                      ],
                    ),
                  ),
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
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${ride["price"]}",
                        style: GoogleFonts.montserrat(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text("/seat")
                    ],
                  ),
                  ElevatedButton(
                      onPressed: myRide == false
                          ? () {
                              JoinRide();
                            }
                          : () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return DetailPage(
                                  ride: ride,
                                  userData: userData,
                                  rideId: rideId,
                                  myRide: myRide,
                                  myId: myId,
                                );
                              }));
                            },
                      child: myRide == false ? Text("Join") : Text("View"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
