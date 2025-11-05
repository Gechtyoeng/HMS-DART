import '../domian/hms.dart';
import 'room_repository.dart';
import 'patient_repository.dart';
import 'bed_assigment.dart';

void loadFromJson(HMS hms) {
  final patients = loadPatients('assets/patients.json');
  final rooms = loadRooms('assets/rooms.json');
  final assignments = loadAssignments('assets/assignments.json', patients, rooms);

  hms.patients.addAll(patients);
  hms.rooms.addAll(rooms);
  hms.bedAllocations.addAll(assignments);
}

void saveToJson(HMS hms) {
  savePatients(hms.patients, 'assets/patients.json');
  saveRooms(hms.rooms, 'assets/rooms.json');
  saveAssignments(hms.bedAllocations, 'assets/assignments.json');
}
