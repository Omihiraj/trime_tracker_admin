import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_admin/models/employee_data.dart';

import 'dart:html' as html;
import '../../components/constants.dart';
import '../../controller/employee_data_change.dart';
import '../../services/fire_service.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  TextEditingController hourController = TextEditingController();
  double total = 0;
  @override
  void dispose() {
    hourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: Container(),
        title: const Text(
          "Employee Data",
          style: TextStyle(
              color: secondaryColor,
              fontSize: headlineText,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: bgColor,
      ),
      body: StreamBuilder<List<EmployeeData>>(
          stream: FireService.getEmployeeData(
              Provider.of<EmployeeDChange>(context).getDate,
              Provider.of<EmployeeDChange>(context).getDocId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  if (snapshot.data == null) {
                    return const Text('No data to show');
                  } else if (snapshot.data!.isEmpty) {
                    return const Text("No Data Found For Selected Date");
                  } else {
                    final employeeData = snapshot.data!;

                    return SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("Date : ${employeeData[0].date}"),
                            ],
                          ),
                          SizedBox(
                            width: 300,
                            height: 100,
                            child: locationList(employeeData[0].locations),
                          ),
                          Row(
                            children: [
                              Text("Hours : 0${employeeData[0].hours}"),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 75,
                                height: 50,
                                child: TextField(
                                  controller: hourController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    total = int.parse(hourController.text) *
                                        employeeData[0].hours;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: secondaryColor),
                                  child: const Text(
                                    "Calculate",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text("Total : $total")
                        ],
                      ),
                    );
                  }
                }
            }
          }),
    );
  }

  Widget locationList(List locations) {
    return ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                print(locations[index]["lat"]);
                openInWindow(
                    "https://www.google.com/maps/search/?api=1&query=${locations[index]["lat"]},${locations[index]["long"]}",
                    'new tab');
              },
              child: Row(
                children: [
                  Text("Location 0${index + 1} "),
                  Text("Time ${locations[index]["time"]} "),
                ],
              ));
        });
  }

  void openInWindow(String uri, String name) {
    html.window.open(uri, name);
  }
}
