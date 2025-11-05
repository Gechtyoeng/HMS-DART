//store all the information about the assignment between patient and bed
import 'package:hms_project/domian/patient.dart';
import 'package:hms_project/domian/room.dart';

class Bedassignment {
  Patient patient;
  Bed bed;
  DateTime startDate;
  DateTime? endDate; //store when patient checkout

  Bedassignment({required this.patient, required this.bed, DateTime? endDate})
    : startDate = DateTime.now();

  //check if the bed assignment is still active
  bool isActive() => endDate == null;

  //check out patient (set end date)
  void checkout() {
    endDate = DateTime.now();
    bed.freeBed(); //free the bed
  }

  //calculate stay duration in day
  int stayDurationInDay() {
    var end = endDate ?? DateTime.now();
    Duration diff = end.difference(startDate);

    return diff.inDays;
  }

  //show bed assignment datail
  void assignmentDetail() {
    print('---- Assignment Detail -----');
    print('Room number: ${bed.room.roomNumber}');
    print('Bed number: ${bed.bedNumber}');
    print('Patient name: ${patient.fullName}');
    print('Start date: $startDate');
    print(endDate != null ? 'End date: $endDate' : 'Status : Active');
  }

  Map<String, Object?> toJson() => {
    'patientId': patient.id,
    'bedNumber': bed.bedNumber,
    'roomNumber': bed.room.roomNumber,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
  };

  static Bedassignment fromJson(
    Map<String, Object?> json,
    Map<String, Patient> patientMap,
    Map<String, Room> roomMap,
  ) {
    final patientId = json['patientId'] as String;
    final roomNumber = json['roomNumber'] as String;
    final bedNumber = json['bedNumber'] as String;

    final patient = patientMap[patientId];
    final room = roomMap[roomNumber];
    if (patient == null || room == null) {
      throw Exception('Missing patient or room for assignment');
    }

    final bed = room.beds.firstWhere((b) => b.bedNumber == bedNumber);

    final assignment = Bedassignment(patient: patient, bed: bed);
    assignment.startDate = DateTime.parse(json['startDate'] as String);
    assignment.endDate = json['endDate'] != null
        ? DateTime.parse(json['endDate'] as String)
        : null;

    return assignment;
  }
}
