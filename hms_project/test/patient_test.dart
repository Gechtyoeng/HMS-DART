import 'package:hms_project/domian/patient.dart';
import 'package:test/test.dart';
import 'package:hms_project/domian/hms.dart';

void main() {
  //group for patient registration
  group('Patient registration', () {
    late HMS hms;

    setUp(() {
      hms = HMS(hospitalName: 'CADT', location: 'Phnom Penh', contact: '012345678');
    });
    //case 01 ---register new patient with valid input
    test('Add new patient with valid input', () {
      hms.registerPatient(firstName: 'oeng', lastName: 'gechty', genderInput: 'female', contact: '0978989898');
      expect(hms.patients.length, 1);
    });
    //case 02 ---register new patient with Invalid input (miss first name)
    test('Fail to add new patient with Invalid input', () {
      hms.registerPatient(firstName: '', lastName: 'gechty', genderInput: 'female', contact: '0978989898');
      expect(hms.patients.isEmpty, true);
    });
    //case 03 ---register new patient with exited phone number
    test('Duplicate phone number', () {
      hms.registerPatient(firstName: 'oeng', lastName: 'gechty', genderInput: 'female', contact: '0978989898');
      hms.registerPatient(firstName: 'kem', lastName: 'veysean', genderInput: 'female', contact: '0978989898');
      expect(hms.patients.length, 1);
    });
    //case 04 ---register new patient with wrong phone number format
    test('wrong format phone number', () {
      hms.registerPatient(firstName: 'kem', lastName: 'veysean', genderInput: 'female', contact: '*097898989');
      expect(hms.patients.isEmpty, true);
    });
  });

  //group for search patient
  group('Search patient', () {
    late HMS hms;
    late Patient? patient;
    setUp(() {
      hms = HMS(hospitalName: 'CADT', location: 'Phnom Penh', contact: '012345678');
      hms.registerPatient(firstName: 'kao', lastName: 'sovann', genderInput: 'male', contact: '0978989898');
      hms.registerPatient(firstName: 'kem', lastName: 'veysean', genderInput: 'female', contact: '0972458003');
      hms.registerPatient(firstName: 'oeng', lastName: 'gechty', genderInput: 'female', contact: '077532774');
    });
  //case 01 ---search patient with valid phone number
    test('Search patient with exist phone number', () {
      patient = hms.searchPatientByContact('077532774');
      expect(patient, isNotNull);
    });
  //case 02 ---search patient with invalid phone number( not exist phone number)
    test('Search patient with not exist phone number', () {
      patient = hms.searchPatientByContact('090 896666');
      expect(patient, isNull);
    });
  });
}
