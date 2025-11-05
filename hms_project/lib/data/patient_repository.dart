import 'dart:convert';
import 'dart:io';
import '../domian/patient.dart';

void savePatients(List<Patient> patients, String path) {
  const encoder = JsonEncoder.withIndent('  ');
  final jsonList = encoder.convert(patients.map((p) => p.toJson()).toList());
  File(path).writeAsStringSync(jsonList);
}

List<Patient> loadPatients(String path) {
  final jsonString = File(path).readAsStringSync();
  final jsonList = jsonDecode(jsonString) as List<Object?>;
  return jsonList
      .map((e) => Patient.fromJson(e as Map<String, Object?>))
      .toList();
}
