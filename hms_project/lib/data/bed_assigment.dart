import 'dart:convert';
import 'dart:io';
import '../domian/bed_assignment.dart';
import '../domian/patient.dart';
import '../domian/room.dart';

List<Bedassignment> loadAssignments(
  String path,
  List<Patient> patients,
  List<Room> rooms,
) {
  final jsonString = File(path).readAsStringSync();
  final jsonList = jsonDecode(jsonString) as List<Object?>;

  final roomMap = {for (var r in rooms) r.roomNumber: r};
  final patientMap = {for (var p in patients) p.id: p};

  return jsonList.map((e) {
    final map = e as Map<String, Object?>;
    final patient = patientMap[map['patientId']]!;
    final room = roomMap[map['roomNumber']]!;
    final bed = room.beds.firstWhere((b) => b.bedNumber == map['bedNumber']);
    return Bedassignment(patient: patient, bed: bed);
  }).toList();
}

void saveAssignments(List<Bedassignment> assignments, String path) {
  final jsonList = assignments.map((a) => a.toJson()).toList();
  File(path).writeAsStringSync(jsonEncode(jsonList));
}
