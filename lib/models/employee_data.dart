class EmployeeData {
  EmployeeData({
    required this.date,
    required this.locations,
    required this.hours,
  });
  String date;
  List locations;
  double hours;

  static EmployeeData fromJson(Map<String, dynamic> json) => EmployeeData(
      date: json["date"], locations: json["location"], hours: json["hours"]);

  Map<String, dynamic> toJson() =>
      {"employee-id": date, "location": locations, "hours": hours};
}
