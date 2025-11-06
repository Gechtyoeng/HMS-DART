import 'package:hms_project/domian/bed_assignment.dart';
import 'package:hms_project/domian/patient.dart';
import 'package:hms_project/domian/room.dart';

class HMS {
  final String hospitalName;
  final String location;
  final String contact;

  final List<Patient> patients = [];
  final List<Room> rooms = [];
  final List<Bedassignment> bedAllocations = [];

  HMS({required this.hospitalName, required this.location, required this.contact});

  // Function to get all patients
  List<Patient> getAllPatients() => patients;

  //function to get all bed assignment
  List<Bedassignment> getAllBedAssignments() => bedAllocations;

  //register new patient
  void registerPatient(Patient patient) {
    //check if patient already existed
    if (patients.any((p) => p.contact == patient.contact)) {
      throw Exception('Patient with $contact already registered.');
    }
    patients.add(patient);
  }

  //search patient
  Patient? searchPatientByContact(String contact) {
    contact = contact.trim().replaceAll(' ', ''); //remove space before compare
    try {
      return patients.firstWhere((p) => p.contact == contact);
    } catch (e) {
      return null;
    }
  }

  // Return a map of occupied rooms and their busy beds
  Map<Room, List<Bed>> getOccupiedRooms() {
    return {
      for (var room in rooms)
        if (room.beds.any((b) => b.status == BedStatus.busy)) room: room.beds.where((b) => b.status == BedStatus.busy).toList(),
    };
  }

  // Return a map of available rooms and their free beds
  Map<Room, List<Bed>> getAvailableRooms() {
    return {
      for (var room in rooms)
        if (room.beds.any((b) => b.status == BedStatus.free)) room: room.beds.where((b) => b.status == BedStatus.free).toList(),
    };
  }

  //function find available room type and its bed
  Map<Room, List<Bed>> getAvailableBedsByRoomType(RoomType type) {
    return {
      for (var room in rooms.where((r) => r.type == type))
        if (room.beds.any((b) => b.ifBedFree())) room: room.beds.where((b) => b.ifBedFree()).toList(),
    };
  }

  // Function assign room to patient
  void assignRoomToPatient(Patient patient, Bed bed) {
    if (!bed.ifBedFree()) {
      throw Exception('Bed ${bed.bedNumber} in Room ${bed.room.roomNumber} is already occupied.');
    }

    // Check if patient already has an active bed assignment
    final hasActiveAssignment = bedAllocations.any((assignment) => assignment.patient == patient && assignment.isActive());

    if (hasActiveAssignment) {
      throw Exception('Patient ${patient.fullName} already has a bed assigned.');
    }

    bed.assignBed();
    final assignment = Bedassignment(patient: patient, bed: bed);
    bedAllocations.add(assignment);
  }

  //Function checkout for patient
  void checkoutPatient(Patient patient) {
    final assignment = bedAllocations.firstWhere(
      (a) => a.patient.id == patient.id && a.isActive(),
      orElse: () => throw Exception('Bed assignment with patient: ${patient.fullName} not found.'),
    );

    assignment.checkout();
  }
}
