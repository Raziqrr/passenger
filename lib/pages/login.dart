/// @Author: Raziqrr rzqrdzn03@gmail.com
/// @Date: 2024-08-03 17:16:29
/// @LastEditors: Raziqrr rzqrdzn03@gmail.com
/// @LastEditTime: 2024-08-04 16:46:16
/// @FilePath: lib/pages/login.dart
/// @Description: 这是默认设置,可以在设置》工具》File Description中进行配置

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passenger/pages/home.dart';
import 'package:passenger/pages/register.dart';
import 'package:passenger/widgets/CustomTextField.dart';
import 'package:passenger/widgets/PrimaryButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController icController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String icHintText = "IC Number";
  String passwordHintText = "Password";
  String icErrorText = "";
  String passwordErrorText = "";

  bool hidePassword = true;
  bool isIcValid = false;
  bool isPasswordValid = false;
  bool rememberMe = false;

  Map<String, dynamic> userData = {};

  Future<Map<String, dynamic>?> GetUserData(String uid) async {
    final db = FirebaseFirestore.instance;
    final UserRef = await db.collection("Users").doc(uid).get();
    return UserRef.data();
  }

  void GetCredentials() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final uid = await _prefs.getString("uid");
    if (uid != null || uid != "") {
      userData = (await GetUserData(uid!))!;
      setState(() {});
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage(
          userData: userData,
          id: uid,
        );
      }));
    }
  }

  void StoreCredentials(UserCredential credentials) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('uid', credentials.user!.uid!);
  }

  void Login(String ic, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "$ic@passenger.cc",
        password: password,
      );
      if (rememberMe == true) {
        StoreCredentials(credential);
      }
      userData = (await GetUserData(credential.user!.uid))!;
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return HomePage(
          userData: userData,
          id: credential.user!.uid,
        );
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShowError('Account doesnt exist.', "Login");
      } else if (e.code == 'wrong-password') {
        ShowError('Wrong-password provided.', "Login");
      }
    } catch (e) {
      ShowError(e.toString(), 'Unknown Error');
    }
  }

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

  @override
  void initState() {
    // TODO: implement initState
    GetCredentials();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.sizeOf(context).height * 30 / 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("Login"), Text("Access your account")],
              ),
            ),
            CustomTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                controller: icController,
                onChanged: (value) {
                  if (value!.isEmpty) {
                    icErrorText = "Please enter a valid IC number";
                    isIcValid = false;
                    setState(() {});
                  } else {
                    icErrorText = "";
                    isIcValid = true;
                    setState(() {});
                  }
                },
                hintText: icHintText,
                keyboardType: TextInputType.number,
                errorText: icErrorText),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
                obsureText: hidePassword,
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
                controller: passwordController,
                onChanged: (value) {
                  if (value!.length < 6) {
                    passwordErrorText =
                        "Password must be at least 6 characters long";
                    isPasswordValid = false;
                  } else {
                    passwordErrorText = "";
                    isPasswordValid = true;
                  }
                  setState(() {});
                },
                hintText: passwordHintText,
                errorText: passwordErrorText),
            CheckboxListTile(
                activeColor: CupertinoColors.systemGreen,
                title: Text("Remember me"),
                contentPadding: EdgeInsets.all(0),
                checkboxShape: CircleBorder(),
                controlAffinity: ListTileControlAffinity.leading,
                value: rememberMe,
                onChanged: (value) {
                  rememberMe = value!;
                  setState(() {});
                }),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                  child: Primarybutton(
                      onPressed: (isIcValid == true && isPasswordValid == true)
                          ? () {
                              Login(icController.text, passwordController.text);
                            }
                          : null,
                      text: "Login"),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return RegisterPagea();
                }));
              },
              child: Text("Register a new account"),
            )
          ],
        ),
      ),
    );
  }
}
