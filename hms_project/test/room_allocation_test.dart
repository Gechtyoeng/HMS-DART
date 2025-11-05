import 'package:hms_project/domian/patient.dart';
import 'package:test/test.dart';
import 'package:hms_project/domian/hms.dart';
import 'package:hms_project/domian/room.dart';

void main() {
  group('Room allocation test case', () {
    late HMS hms;

    setUp(() {
      //mock data for test case
      hms = HMS(hospitalName: 'CADT', location: 'Phnom Penh', contact: '012345678');
      final roomGeneral = Room(roomNumber: 'G101', capacity: 2, type: RoomType.general);
      final roomPrivate = Room.private(roomNumber: 'P201');
      final roomVIP = Room.vip(roomNumber: 'V301');
      final roomICU = Room.icu(roomNumber: 'I401');

      roomGeneral.addBed(Bed(bedNumber: 'G1', room: roomGeneral));
      roomGeneral.addBed(Bed(bedNumber: 'G2', room: roomGeneral));
      roomPrivate.addBed(Bed(bedNumber: 'P1', room: roomPrivate));
      roomVIP.addBed(Bed(bedNumber: 'V1', room: roomVIP));
      roomICU.addBed(Bed(bedNumber: 'I1', room: roomICU));

      hms.rooms.addAll([roomGeneral, roomPrivate, roomVIP, roomICU]);
      final patient1 = Patient(firstName: 'oeng', lastName: 'gechty', gender: Gender.female, contact: '077532774');
      final patient2 = Patient(firstName: 'kem', lastName: 'veysean', gender: Gender.female, contact: '090898989');
      hms.patients.addAll([patient1, patient2]);
    });
    //case 01 ---assign patient to first bed in general room
    test('Assign bed to patient in general room', () {
      //search patient by contact
      var patient = hms.searchPatientByContact('077532774');
      var availableRooms = hms.getAvailableBedsByRoomType(RoomType.general);
      expect(availableRooms.isNotEmpty, true);

      var room = availableRooms.keys.first;
      var bed = availableRooms[room]!.first;
      //assign first bed in general room to patient
      hms.assignRoomToPatient(patient!, bed);
      expect(bed.bedNumber, 'G1');
      expect(bed.status, BedStatus.busy);
      expect(hms.bedAllocations.length, 1);
    });

    //case 02 ---fail to assign patient with busy room
    test('Assign busy bed to patient', () {
      //set the bed in vip room to busy
      var patient = hms.searchPatientByContact('077532774');
      var vipRooms = hms.getAvailableBedsByRoomType(RoomType.vip);
      var bed = vipRooms.values.first.first;
      hms.assignRoomToPatient(patient!, bed);

      var secondPatient = hms.searchPatientByContact('090898989');
      hms.assignRoomToPatient(secondPatient!, bed);
      expect(hms.bedAllocations.length, 1); //only one bed assignment
      expect(hms.bedAllocations.first.patient, patient);
    });
    //case 03 ---fail to assign to patient who already had bed assignment
    test('Assign second bed assignment to patient', () {
      var patient = hms.searchPatientByContact('077532774');
      var generalRoom = hms.getAvailableBedsByRoomType(RoomType.general);
      var firstRoom = generalRoom.keys.first;
      var bedsInFirstRoom = generalRoom[firstRoom]!;
      var bed1 = bedsInFirstRoom[0];
      var bed2 = bedsInFirstRoom[1];

      hms.assignRoomToPatient(patient!, bed1);
      hms.assignRoomToPatient(patient, bed2);
      expect(hms.bedAllocations.length, 1);
      expect(bed1.status, BedStatus.busy);
      expect(bed2.status, BedStatus.free);
    });

    //case 04 ---check out patient
    test('check out patient', () {
      var patient = hms.searchPatientByContact('077532774');
      var availableRooms = hms.getAvailableBedsByRoomType(RoomType.general);
      expect(availableRooms.isNotEmpty, true);

      var room = availableRooms.keys.first;
      var bed = availableRooms[room]!.first;
      //assign first bed in general room to patient
      hms.assignRoomToPatient(patient!, bed);
      //check out patient
      hms.checkoutPatient(patient);
      expect(hms.bedAllocations.first.endDate, isNotNull);
      expect(bed.status, BedStatus.free);
    });
  });
}
