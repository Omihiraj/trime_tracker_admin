import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/employee.dart';
import '../models/employee_data.dart';

class FireService {
  static Stream<List<Employee>> getEmployees() => FirebaseFirestore.instance
      .collection('user')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Employee.fromJson(doc.data())).toList());
  static Stream<List<EmployeeData>> getEmployeeData(
          String date, String docId) =>
      FirebaseFirestore.instance
          .collection('user')
          .doc(docId)
          .collection("dates")
          .where("date", isEqualTo: date)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => EmployeeData.fromJson(doc.data()))
              .toList());
}
