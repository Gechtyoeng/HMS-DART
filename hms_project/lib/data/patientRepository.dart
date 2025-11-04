import 'dart:io';
import 'dart:convert';
import '../domian/patient.dart';

class Patientrepository {
  void writePatients(String filePath, List<Patient> patients) {
    final file = File(filePath);

    // Convert each patient to Map<String, String>
    final jsonList = patients.map((p) => p.toJson()).toList();

    // Wrap in a top-level object
    final jsonData = {'patients': jsonList};

    // Write with indentation
    final jsonString = JsonEncoder.withIndent('  ').convert(jsonData);
    file.writeAsStringSync(jsonString, flush: true);
  }

  List<Patient> readPatients(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();

    // Decode as Map<String, Object> using cast
    final decodedRaw = json.decode(content);
    if (decodedRaw is! Map) {
      throw FormatException('Top-level JSON is not a map');
    }

    final decoded = Map<String, Object>.from(decodedRaw);

    final rawList = decoded['patients'];
    if (rawList is! List) {
      throw FormatException('"patients" is not a list');
    }

    return rawList.map((obj) {
      if (obj is! Map) {
        throw FormatException('Each patient must be a map');
      }

      final map = Map<String, Object>.from(obj);
      final stringMap = map.map((k, v) => MapEntry(k, v.toString()));
      return Patient.fromJson(stringMap);
    }).toList();
  }
}
