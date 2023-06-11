import 'dart:convert';
import 'package:counter/src/global.dart';
import 'package:counter/src/model/attendance_model.dart';
import 'package:counter/src/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as https;

class Attendencepage extends StatefulWidget {
  const Attendencepage({super.key});

  @override
  State<Attendencepage> createState() => _AttendencepageState();
}

class _AttendencepageState extends State<Attendencepage> {
  List<AttendanceModal> attendence = [];
  List<Color> color = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.teal,
    Colors.purple,
  ];
  bool isLoading = true;
  @override
  void initState() {
    fetchAttedenceId();
    super.initState();
  }

  fetchAttedenceId() async {
    var response = await https.post(
      Uri.parse(
          'http://115.240.101.51:8282//CampusPortalSOA/studentSemester/lov'),
      headers: {
        'Cookie': 'JSESSIONID=${sharedPreferences.getString('cookie')}',
      },
    );
    var decode = jsonDecode(response.body);
    String attendenceid = decode["studentdata"][0]["REGISTRATIONID"];
    fetchAttendence(attendenceid);
  }

  fetchAttendence(String atId) async {
    var response = await https.post(
      Uri.parse('http://115.240.101.51:8282//CampusPortalSOA/attendanceinfo'),
      // body: json.encode({"registerationid": atId}),
      body: json.encode({"registerationid": "ITERRETD2209A0000001"}),
      headers: {
        'Cookie': 'JSESSIONID=${sharedPreferences.getString('cookie')}',
      },
    );
    var decode = jsonDecode(response.body);
    int len = decode["griddata"].length;
    for (int e = 0; e < len; e++) {
      attendence.add(AttendanceModal(
        latt: decode["griddata"][e]["Latt"],
        patt: decode["griddata"][e]["Patt"],
        subject: decode["griddata"][e]["subject"],
        totalAttandence: decode["griddata"][e]["TotalAttandence"],
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Attendence'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: attendence.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                    bottom: 5,
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                      color: color[index],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Total attendence : ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            attendence[index].totalAttendance.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Lect : ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            attendence[index].latt.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Pract : ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            attendence[index].patt.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Subject : ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              attendence[index].subject.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
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
        enableFeedback: true,
        onTap: (value) {
          if (value == 1) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()));
            // return;
          }
          if (value == 2) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Attendencepage()));

            // return;
          }
          // setState(() {
          //   // _selectedIndex = value;
          // });
        },
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
