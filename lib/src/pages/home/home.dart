import 'dart:convert';
import 'dart:typed_data';

import 'package:counter/src/global.dart';
import 'package:counter/src/model/student_model.dart';
import 'package:counter/src/pages/attendance/attendance.dart';
import 'package:counter/src/pages/app_login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  void initState() {
    fetchStudentInfo();
    super.initState();
  }

  Uint8List? list;
  void requestImg() async {
    //login this  user and get Cookie and then call image section.
    try {
      final https.Response response = await https.get(
        Uri.parse(
            'http://115.240.101.51:8282//CampusPortalSOA/image/studentPhoto'),
        headers: {
          'Cookie': 'JSESSIONID=${sharedPreferences.getString('cookie')}',
        },
      );

      // print(profileImage);
      setState(() {
        list = response.bodyBytes;
      });
    } catch (e) {}
  }

  late Student student;

  fetchStudentInfo() async {
    // try {
    var response = await https.post(
        Uri.parse('http://115.240.101.51:8282//CampusPortalSOA/studentinfo'),
        headers: {
          "Cookie": "JSESSIONID=${sharedPreferences.getString('cookie')}"
        });
    print(response.body);
    var decoded = jsonDecode(response.body);
    if (decoded["detail"].isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const App_login_page()));
    } else {
      student = Student(
        name: decoded["detail"][0]["name"] ?? "Not given",
        regdNo: decoded["detail"][0]["enrollmentno"] ?? "Not given",
        dob: decoded["detail"][0]["dateofbirth"] ?? "Not given",
        branch: decoded["detail"][0]["branchdesc"] ?? "Not given",
        sec: decoded["detail"][0]["sectioncode"] ?? "Not given",
        email: decoded["detail"][0]["semailid"] ?? "Not given",
        mName: decoded["detail"][0]["mothersname"] ?? "Not given",
        address: decoded["detail"][0]["paddress2"] ?? "Not given",
        bloodgroup: decoded["detail"][0]["bloodgroup"] ?? "Not given",
        caddress3: decoded["detail"][0]["caddress2"] ?? "Not given",
        maritalstatus: decoded["detail"][0]["maritalstatus"] ?? "Not given",
        nationality: decoded["detail"][0]["nationality"] ?? "Not given",
        pNo: decoded["detail"][0]["scellno"] ?? "Not given",
        parentNumber: decoded["detail"][0]["stelephoneno"] ?? "Not given",
        phoneNo: decoded["detail"][0]["scellno"] ?? "Not given",
        pincode: decoded["detail"][0]["ppin"] ?? "Not given",
      );
      requestImg();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      list == null
                          ? const CircularProgressIndicator()
                          : Align(
                              child: CircleAvatar(
                                radius: 60,
                                child: CircleAvatar(
                                  backgroundImage: MemoryImage(list!),
                                  radius: 55,
                                ),
                              ),
                            ),

                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(40),
                      //   child: Image.memory(list!, width: 100),
                      // ),

                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 15),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.name!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 10),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.regdNo!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.address!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.email!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.branch!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.sec!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.name!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.parentNumber!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.caddress3!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text(
                          student.mName!,
                          style: const TextStyle(color: Colors.white),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.co_present_outlined),
            label: "Profile",
          ),
          // BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.cube), label: "Shipments"),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outlined),
            label: "Attendence",
          ),
        ],
        
        // enableFeedback: true,
       
        onTap: (value) { 
          int _selectedIndex=0;
          if (value == 0) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
            // return;
          }
          if (value == 1) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Attendencepage()));

            // return;
          }
          setState(() {
            _selectedIndex = value;
          });
        },
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
