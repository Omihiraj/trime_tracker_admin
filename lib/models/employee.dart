class Employee {
  Employee({
    required this.employeeId,
    required this.employeeName,
    required this.docId,
  });
  String employeeId;
  String employeeName;
  String docId;

  static Employee fromJson(Map<String, dynamic> json) => Employee(
      employeeId: json["employee-id"],
      employeeName: json["name"],
      docId: json["doc-id"]);

  Map<String, dynamic> toJson() =>
      {"employee-id": employeeId, "name": employeeName, "doc-id": docId};
}
