/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-03 17:16:21
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-03 23:25:17
/// @FilePath: lib/pages/register.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passenger/widgets/CustomTextField.dart';
import 'package:passenger/widgets/SecondaryButton.dart';

import '../widgets/PrimaryButton.dart';

class RegisterPagea extends StatefulWidget {
  const RegisterPagea({super.key});

  @override
  State<RegisterPagea> createState() => _RegisterPageaState();
}

class _RegisterPageaState extends State<RegisterPagea> {
  TextEditingController nameController = TextEditingController();
  TextEditingController icController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Uint8List? image;
  String? imageName;

  String nameError = "";
  String icError = "";
  String genderError = "";
  String phoneError = "";
  String emailError = "";
  String addressError = "";
  String passwordError = "";

  String gender = "";

  bool isNameValid = false;
  bool isIcValid = false;
  bool isGenderValid = false;
  bool isPhoneValid = false;
  bool isEmailValid = false;
  bool isAddressValid = false;
  bool isImageValid = false;
  bool isPasswordValid = false;

  bool hidePassword = true;

  int pageIndex = 0;

  void ShowError(String message, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: Text(category),
        );
      },
    );
  }

  void ShowSucess(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(message),
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("Continue to login")),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void PickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final chosenImage = await imagePicker.pickImage(source: source);
    final imageData = await File(chosenImage!.path).readAsBytes();
    if (imageData != null) {
      image = imageData!;
      imageName = chosenImage.name;
      isImageValid = true;
      setState(() {});
    }
    Navigator.pop(context);
  }

  void Register(String ic, String password, String name, String email,
      String phone, String address, String gender, Uint8List img) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$ic@passenger.cc",
        password: password,
      );

      final imageRef = FirebaseStorage.instance.ref(
          "passenger/images/${credential.user!.uid}/${DateTime.now()}.jpg");
      await imageRef.putData(image!);
      final imageUrl = await imageRef.getDownloadURL();

      final db = FirebaseFirestore.instance;
      db
          .collection("Users")
          .doc("${credential.user!.uid}")
          .set(<String, dynamic>{
        "name": name,
        "ic": ic,
        "gender": gender,
        "phone": phone,
        "email": email,
        "address": address,
        "image": imageUrl,
        "role": "passenger"
      });
      Navigator.pop(context);
      ShowSucess("Registration successfull");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        ShowError('The password provided is too weak.', 'Registration failed');
      } else if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        ShowError('The account already exists for that email.',
            'Registration failed');
      }
    } catch (e) {
      Navigator.pop(context);
      ShowError(e.toString(), 'Unknown Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: MediaQuery.sizeOf(context).height * 30 / 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Register"),
                    Text("Create a new passenger account")
                  ],
                ),
              ),
              CustomTextField(
                  keyboardType: TextInputType.number,
                  controller: icController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(12)
                  ],
                  onChanged: (value) {
                    if (value!.length < 12) {
                      icError = "Enter a valid IC number";
                      isIcValid = false;
                    } else {
                      icError = "";
                      isIcValid = true;
                    }
                    setState(() {});
                  },
                  hintText: "IC Number",
                  errorText: icError),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: hidePassword == true
                          ? Icon(
                              CupertinoIcons.eye_slash_fill,
                              color: Colors.grey,
                            )
                          : Icon(
                              CupertinoIcons.eye_fill,
                              color: Colors.grey,
                            )),
                  obsureText: hidePassword,
                  controller: passwordController,
                  onChanged: (value) {
                    if (value!.length < 5) {
                      passwordError = "Password length must be more than 6";
                      isPasswordValid = false;
                    } else {
                      passwordError = "";
                      isPasswordValid = true;
                    }
                    setState(() {});
                  },
                  hintText: "Password",
                  errorText: passwordError),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Primarybutton(
                        onPressed: (isIcValid == true &&
                                isPasswordValid == true)
                            ? () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  },
                                );
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email:
                                              "${icController.text}@passenger.cc",
                                          password: passwordController.text);
                                  Navigator.pop(context);
                                  ShowError("Account already exists",
                                      "Registration failed");
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    Navigator.pop(context);
                                    setState(() {
                                      pageIndex += 1;
                                    });
                                  } else if (e.code == 'wrong-password') {
                                    Navigator.pop(context);
                                    ShowError("Account already exists",
                                        "Registration failed");
                                  }
                                }
                              }
                            : null,
                        text: "Next"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Expanded(
                      child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  )),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.white),
                    child: Text(
                      "Or",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Login with an existing account"),
              )
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Text("Complete registration"),
                SizedBox(
                  height: 40,
                ),
                CustomTextField(
                    controller: nameController,
                    onChanged: (value) {
                      if (value!.isEmpty) {
                        nameError = "Name cannot be empty";
                        isNameValid = false;
                      } else {
                        nameError = "";
                        isNameValid = true;
                      }
                      setState(() {});
                    },
                    hintText: "Name",
                    errorText: nameError),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    onChanged: (value) {
                      bool isValid = EmailValidator.validate(value!);
                      print(isValid);
                      if (isValid == false) {
                        emailError = "Invalid email";
                      } else {
                        emailError = "";
                      }
                      isEmailValid = isValid;
                      setState(() {});
                    },
                    hintText: "Email Address",
                    errorText: emailError),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: phoneController,
                    onChanged: (value) {
                      if (value!.length < 10) {
                        phoneError = "Invalid phone number";
                        isPhoneValid = false;
                      } else {
                        phoneError = "";
                        isPhoneValid = true;
                      }
                      setState(() {});
                    },
                    hintText: "Phone Number",
                    errorText: phoneError),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    maxLines: 4,
                    controller: addressController,
                    keyboardType: TextInputType.streetAddress,
                    onChanged: (value) {
                      if (value!.isEmpty) {
                        addressError = "Name cannot be empty";
                        isAddressValid = false;
                      } else {
                        addressError = "";
                        isAddressValid = true;
                      }
                      setState(() {});
                    },
                    hintText: "Home Address",
                    errorText: addressError),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text("Gender"),
                    SizedBox(
                      width: 20,
                    ),
                    if (gender == "")
                      Text(
                        "( Please select a gender )",
                        style: GoogleFonts.montserrat(color: Colors.red),
                      )
                  ],
                ),
                Column(
                  children: [
                    RadioListTile(
                        title: Text("Male"),
                        contentPadding: EdgeInsets.zero,
                        value: "Male",
                        groupValue: gender,
                        onChanged: (value) {
                          gender = value!;
                          isGenderValid = true;
                          setState(() {});
                        }),
                    RadioListTile(
                        title: Text("Female"),
                        contentPadding: EdgeInsets.zero,
                        value: "Female",
                        groupValue: gender,
                        onChanged: (value) {
                          gender = value!;
                          isGenderValid = true;
                          setState(() {});
                        }),
                    RadioListTile(
                        title: Text("Other"),
                        contentPadding: EdgeInsets.zero,
                        value: "Other",
                        groupValue: gender,
                        onChanged: (value) {
                          gender = value!;
                          isGenderValid = true;
                          setState(() {});
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("Profile Photo"),
                        SizedBox(
                          width: 20,
                        ),
                        if (image == null)
                          Text(
                            "( Please select a profile photo )",
                            style: GoogleFonts.montserrat(color: Colors.red),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    image == null
                        ? Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            title: Text("Choose upload method"),
                                            actions: [
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              PickImage(
                                                                  ImageSource
                                                                      .camera);
                                                            },
                                                            child:
                                                                Text("Camera")),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                            onPressed: () {
                                                              PickImage(
                                                                  ImageSource
                                                                      .gallery);
                                                            },
                                                            child: Text(
                                                                "Gallery")),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Upload",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ],
                          )
                        : Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    imageName!,
                                    maxLines: 2,
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        image = null;
                                        imageName = null;
                                        isImageValid = false;
                                      });
                                    },
                                    icon: Icon(
                                      CupertinoIcons.xmark_circle,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue, width: 3),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Secondarybutton(
                          text: "Back",
                          onPressed: () {
                            setState(() {
                              pageIndex -= 1;
                            });
                          },
                        ),
                        Primarybutton(
                            onPressed: (isNameValid == true &&
                                    isEmailValid == true &&
                                    isPhoneValid == true &&
                                    isAddressValid == true &&
                                    isGenderValid == true &&
                                    isImageValid == true)
                                ? () {
                                    Register(
                                        icController.text,
                                        passwordController.text,
                                        nameController.text,
                                        emailController.text,
                                        phoneController.text,
                                        addressController.text,
                                        gender,
                                        image!);
                                  }
                                : null,
                            text: "Register")
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ][pageIndex],
      ),
    );
  }
}
