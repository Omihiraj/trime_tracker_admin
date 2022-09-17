import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/constants.dart';
import '../controller/employee_data_change.dart';
import '../controller/page_controller.dart';
import '../models/employee.dart';
import '../services/fire_service.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: Container(),
        title: const Text(
          "Status",
          style: TextStyle(
              color: secondaryColor,
              fontSize: headlineText,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: bgColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  height: 50.0,
                  child: InkWell(
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        if (newDate == null) return;
                        setState(() {
                          date = newDate;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Date : ${date.year}-$month-$day",
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 50.0,
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Enter Employee Id",
                        suffixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          borderSide: BorderSide.none,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Employee>>(
          stream: FireService.getEmployees(),
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
                    return const Text("No Employees Found");
                  } else {
                    final employees = snapshot.data!;

                    return ListView.builder(
                      controller: ScrollController(),
                      itemCount: employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        final employee = employees[index];

                        return statusCard(
                            employeeId: employee.employeeId,
                            name: employee.employeeName,
                            docId: employee.docId,
                            month: month,
                            day: day);
                      },
                    );
                  }
                }
            }
          }),
    );
  }

  Widget statusCard(
      {required String employeeId,
      required String name,
      required String docId,
      required String month,
      required String day}) {
    return InkWell(
      onTap: () {
        Provider.of<EmployeeDChange>(context, listen: false)
            .changeData(docId, "${date.year}-$month-$day");
        Provider.of<PageModel>(context, listen: false).currentPage(1);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Employee ID : $employeeId",
                    style: const TextStyle(
                        color: primaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        color: secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
