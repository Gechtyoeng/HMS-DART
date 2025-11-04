// import '../domian/hms.dart';
// import '../domian/patient.dart';

// void main() {
//   final hms = HMS(
//     hospitalName: 'Phnom Penh General Hospital',
//     location: 'Phnom Penh, Cambodia',
//     contact: '+855 23 456 789',
//   );

//   // Add mock patients
//   hms.patients.addAll([
//     Patient(
//       firstName: 'Alice',
//       lastName: 'Nguyen',
//       gender: Gender.female,
//       contact: '0123456789',
//     ),
//     Patient(
//       firstName: 'Sokha',
//       lastName: 'Chan',
//       gender: Gender.male,
//       contact: '0987654321',
//     ),
//   ]);

//   hms.showAllPatients();
// }

import '../domian/hms.dart';
import '../domian/patient.dart';
import '../domian/room.dart';
import '../domian/bed_assignment.dart';

void initializeMockData(HMS hms) {
  final roomGeneral = Room(roomNumber: 'G101', capacity: 4);
  final roomPrivate = Room.private(roomNumber: 'P201');
  final roomVIP = Room.vip(roomNumber: 'V301');
  final roomICU = Room.icu(roomNumber: 'I401');

  roomGeneral.addBed(Bed(bedNumber: 'G1', room: roomGeneral));
  roomGeneral.addBed(Bed(bedNumber: 'G2', room: roomGeneral));
  roomGeneral.addBed(Bed(bedNumber: 'G3', room: roomGeneral));
  roomGeneral.addBed(Bed(bedNumber: 'G4', room: roomGeneral));
  roomPrivate.addBed(Bed(bedNumber: 'P1', room: roomPrivate));
  roomVIP.addBed(Bed(bedNumber: 'V1', room: roomVIP));
  roomICU.addBed(Bed(bedNumber: 'I1', room: roomICU));

  hms.rooms.addAll([roomGeneral, roomPrivate, roomVIP, roomICU]);

  final patient1 = Patient(
    firstName: 'Alice',
    lastName: 'Chan',
    gender: Gender.female,
    contact: '011111111',
  );
  final patient2 = Patient(
    firstName: 'Bob',
    lastName: 'Sok',
    gender: Gender.male,
    contact: '022222222',
  );
  final patient3 = Patient(
    firstName: 'Charlie',
    lastName: 'Kim',
    gender: Gender.male,
    contact: '033333333',
  );
  final patient4 = Patient(
    firstName: 'Dana',
    lastName: 'Lim',
    gender: Gender.female,
    contact: '044444444',
  );

  hms.patients.addAll([patient1, patient2, patient3, patient4]);

  roomGeneral.beds[0].status = BedStatus.busy;
  roomVIP.beds[0].status = BedStatus.busy;

  hms.bedAllocations.addAll([
    Bedassignment(patient: patient1, bed: roomGeneral.beds[0]),
    Bedassignment(patient: patient2, bed: roomVIP.beds[0]),
  ]);

  print('✅ Mock data initialized.');
}
