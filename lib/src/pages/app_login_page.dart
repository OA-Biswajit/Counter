import 'dart:convert';

import 'package:counter/src/global.dart';
import 'package:counter/src/pages/home/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class App_login_page extends StatefulWidget {
  const App_login_page({super.key});

  @override
  State<App_login_page> createState() => _App_login_pageState();
}

class _App_login_pageState extends State<App_login_page> {
  final TextEditingController regdNo = TextEditingController();
  final TextEditingController password = TextEditingController();

  setCookie(response) {
    String rawCookie = response.headers['set-cookie']!;
    int index = rawCookie.indexOf(';');
    String refreshToken =
        (index == -1) ? rawCookie : rawCookie.substring(0, index);
    int idx = refreshToken.indexOf("=");
    if (kDebugMode) {
      print(refreshToken.substring(idx + 1).trim());
    }
    String cookieID = refreshToken.substring(idx + 1).trim();
    sharedPreferences.setString('cookie', cookieID);
  }

  tryLoggingThisUser() async {
    var response = await https.post(
        Uri.parse('http://115.240.101.51:8282//CampusPortalSOA/login'),
        body: json.encode({
          "username": regdNo.text,
          "password": password.text,
          "MemberType": "S"
        }));
    var decoded = jsonDecode(response.body);
    print(decoded);
    if (decoded["status"].toString().contains("success")) {
      //cookie save
      setCookie(response);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()));
      sharedPreferences.setBool("isAuthenticated", true);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(decoded["message"])));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(decoded["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/LoginIcon.png")),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Access your account',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 108, 51, 51),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: regdNo,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      hintText: "Enter Registraton Number",
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    controller: password,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      hintText: "Enter Password",
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        tryLoggingThisUser();
                      },
                      child: const Text("Sign In"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
