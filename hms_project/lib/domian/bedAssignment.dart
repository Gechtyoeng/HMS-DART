//store all the information about the assignment between patient and bed
import 'package:hms_project/domian/patient.dart';
import 'package:hms_project/domian/room.dart';

class Bedassignment {
  Patient patient;
  Bed bed;
  DateTime startDate;
  DateTime? endDate; //store when patient checkout

  Bedassignment({required this.patient, required this.bed}) : startDate = DateTime.now();

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
}
