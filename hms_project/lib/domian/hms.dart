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

  // Function that display all patients
  void showAllPatients() {
    if (patients.isEmpty) {
      print("No patient founded.");
    } else {
      for (var patient in patients) {
        print(patient);
      }
    }
  }

  // Function register new patient
  void registerPatient({required String firstName, required String lastName, required String genderInput, required String contact}) {
    if (firstName.isEmpty || lastName.isEmpty || genderInput.isEmpty || contact.isEmpty) {
      print('Invalid input. All fields are required.');
      return;
    }
    //clean the contact
    contact = contact.trim().replaceAll(' ', '');
    // Contact validation
    if (!RegExp(r'^[0-9]+$').hasMatch(contact)) {
      print('Invalid contact number. Please enter digits only.');
      return;
    }

    //check if contact existed
    bool contactExisted = patients.any((p) => p.contact == contact);
    if (contactExisted) {
      print('Contact number: $contact is already registered.');
      return;
    }

    Gender? gender;
    if (genderInput.toLowerCase() == 'male') {
      gender = Gender.male;
    } else if (genderInput.toLowerCase() == 'female') {
      gender = Gender.female;
    } else {
      print('Invalid gender. Please enter "male" or "female".');
      return;
    }

    final newPatient = Patient(firstName: firstName, lastName: lastName, gender: gender, contact: contact);

    patients.add(newPatient);
    print("Patient ${newPatient.fullName} registered successfully.");
  }

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
      print('Bed ${bed.bedNumber} is already occupied.');
      return;
    }
    
    //check if patient already assigned
    for (var assignment in bedAllocations) {
      if (assignment.patient == patient) {
        print('Patient already have bed assignment.');
        return;
      }
    }

    bed.assignBed();
    final assignment = Bedassignment(patient: patient, bed: bed);
    bedAllocations.add(assignment);

    print('Assigned Bed ${bed.bedNumber} in Room ${bed.room.roomNumber} to ${patient.fullName}.');
  }

  //Function checkout for patient
  void checkoutPatient(Patient patient) {
    Bedassignment? assignment;

    try {
      assignment = bedAllocations.firstWhere((a) => a.patient.id == patient.id && a.isActive());
    } catch (e) {
      assignment = null;
    }

    if (assignment != null) {
      assignment.checkout();
      print('Freed bed ${assignment.bed.bedNumber} in Room ${assignment.bed.room.roomNumber}.');
    } else {
      print('No active bed assignment found for ${patient.fullName}.');
    }
  }
}
