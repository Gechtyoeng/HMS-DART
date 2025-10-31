//contain all the operate of the bed allocation in the hospital;
import 'package:hms_project/domian/BedAssignment.dart';
import 'package:hms_project/domian/patient.dart';
import 'package:hms_project/domian/Room.dart';

class HMS {
    final String hospitalName;
    final String location;
    final String contact;

    final List<Patient> patients = []; 
    final List<Room> rooms = [];
    final List<Bedassignment> bedAllocations = [];

    HMS ({required this.hospitalName, required this.location, required this.contact});
}
