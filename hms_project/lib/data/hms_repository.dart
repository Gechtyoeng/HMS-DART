import '../domian/hms.dart';
import 'room_repository.dart';
import 'patient_repository.dart';
import 'bed_assigment.dart';

void loadFromJson(HMS hms) {
  final patients = loadPatients(
    'D:\\Y3\\Develop\\Molibe\\HMS-DART\\hms_project\\lib\\data\\patientsList.json',
  );
  final rooms = loadRooms(
    'D:\\Y3\\Develop\\Molibe\\HMS-DART\\hms_project\\lib\\data\\roomList.json',
  );
  final assignments = loadAssignments(
    'D:\\Y3\\Develop\\Molibe\\HMS-DART\\hms_project\\lib\\data\\assignment.json',
    patients,
    rooms,
  );

  hms.patients.addAll(patients);
  hms.rooms.addAll(rooms);
  hms.bedAllocations.addAll(assignments);
}

void saveToJson(HMS hms) {
  savePatients(
    hms.patients,
    'D:\\Y3\\Develop\\Molibe\\HMS-DART\\hms_project\\lib\\data\\patientsList.json',
  );
  saveRooms(
    hms.rooms,
    'D:\\Y3\\Develop\\Molibe\\HMS-DART\\hms_project\\lib\\data\\roomList.json',
  );
  saveAssignments(
    hms.bedAllocations,
    'D:\\Y3\\Develop\\Molibe\\HMS-DART\\hms_project\\lib\\data\\assignment.json',
  );
}
