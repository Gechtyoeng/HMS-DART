import 'package:hms_project/domian/patient.dart';
import 'package:test/test.dart';
import 'package:hms_project/domian/hms.dart';
import 'package:hms_project/services/hms_service.dart';

void main() {
  //group for patient registration
  group('Patient registration', () {
    late hmsService service;
    late HMS hms;

    setUp(() {
      hms = HMS(hospitalName: 'CADT', location: 'Phnom Penh', contact: '012345678');
      service = hmsService(hms);
    });
    //case 01 ---register new patient with valid input
    test('Add new patient with valid input', () {
      service.handleRegister(firstName: 'oeng', lastName: 'gechty', genderInput: 'female', contact: '0978989898');
      expect(hms.patients.length, 1);
      expect(hms.patients.first.gender, Gender.female);
    });

    //case 02 ---register new patient with invalid input (miss first name)
    test('Add new patient with Invalid input', () {
      service.handleRegister(firstName: '', lastName: 'gechty', genderInput: 'female', contact: '0978989898');
      expect(hms.patients.isEmpty, true);
    });

    //case 03 ---register new patient with duplicate phone number
    test('Fail to add new patient with duplicate phone number', () {
      String result1 = service.handleRegister(firstName: 'oeng', lastName: 'gechty', genderInput: 'female', contact: '0978989898');
      String result2 = service.handleRegister(firstName: 'kem', lastName: 'veysean', genderInput: 'female', contact: '0978989898');
      expect(result1, 'Patient oeng gechty registered successfully.');
      expect(result2, 'Exception: Patient with 0978989898 already registered.');
    });

    //case 04 ---register new patient with wrong phone number format
    test('wrong format phone number', () {
      String result = service.handleRegister(firstName: 'kem', lastName: 'veysean', genderInput: 'female', contact: '*097898989');
      expect(result, 'Invalid contact format.');
    });

    //case 05 ---search patient with valid phone number
    test('Search patient with exist and not exist contact', () {
      service.handleRegister(firstName: 'kao', lastName: 'sovann', genderInput: 'male', contact: '0978989898');
      service.handleRegister(firstName: 'kem', lastName: 'veysean', genderInput: 'female', contact: '0972458003');
      service.handleRegister(firstName: 'oeng', lastName: 'gechty', genderInput: 'female', contact: '077532774');

      Patient? patient1 = service.searchPatient('077 532774');
      Patient? patient2 = service.searchPatient('090565656');

      expect(patient1, isNotNull);//exist
      expect(patient2, isNull);//not exist
    });
  });
}
