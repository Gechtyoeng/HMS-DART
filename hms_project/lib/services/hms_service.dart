import 'package:hms_project/domian/bed_assignment.dart';
import 'package:hms_project/domian/hms.dart';
import 'package:hms_project/domian/patient.dart';
import 'package:hms_project/domian/room.dart';

class hmsService {
  final HMS hms;
  hmsService(this.hms);

  //check if the contact valid
  bool ifValidContact(String contact) {
    return RegExp(r'^[0-9]+$').hasMatch(contact);
  }

  //function to handle regster new patient
  String handleRegister({required String firstName, required String lastName, required String genderInput, required String contact}) {
    //check if all field are not null
    if (firstName.trim().isEmpty || lastName.trim().isEmpty || genderInput.trim().isEmpty || contact.trim().isEmpty) {
      return 'All fields are required.';
    }

    //valid phone number format
    contact = contact.trim().replaceAll(' ', '');
    if (!ifValidContact(contact)) return 'Invalid contact format.';
    //validate the gender
    Gender? gender;
    if (genderInput.toLowerCase() == 'male') {
      gender = Gender.male;
    } else if (genderInput.toLowerCase() == 'female') {
      gender = Gender.female;
    } else {
      return 'Invalid gender, please enter male or female.';
    }

    //register the patient
    final Patient newPatient = Patient(firstName: firstName.trim(), lastName: lastName.trim(), gender: gender, contact: contact);
    try {
      hms.registerPatient(newPatient);
      return 'Patient ${newPatient.fullName} registered successfully.';
    } catch (e) {
      return e.toString();
    }
  }

  //assign bed to patient
  String assignBedToPatient(Patient patient, Bed bed) {
    try {
      hms.assignRoomToPatient(patient, bed);
      return 'Bed ${bed.bedNumber} assigned to ${patient.fullName}.';
    } catch (e) {
      return e.toString();
    }
  }

  //check out patient
  String checkoutPatient(String contact) {
    final patient = hms.searchPatientByContact(contact);
    if (patient == null) return 'Patient not found.';

    try {
      hms.checkoutPatient(patient);
      return 'Checkout patient: ${patient.fullName} sucessfully.';
    } catch (e) {
      return e.toString();
    }
  }

  // Search patient
  Patient? searchPatient(String contact) {
    contact =contact.trim()..replaceAll(' ', '');
    return hms.searchPatientByContact(contact);
  }

  // get all bed assignment
  List<Bedassignment> getAllBedAssignments() => hms.getAllBedAssignments();
  // get all patients
  List<Patient> getAllPatients() => hms.getAllPatients();

  // get available rooms
  Map<Room, List<Bed>> getAvailableRooms() => hms.getAvailableRooms();

  // get available room with room type
  Map<Room, List<Bed>> getAvailableRoomsByType(RoomType type) => hms.getAvailableBedsByRoomType(type);

  // get occupied room
  Map<Room, List<Bed>> getOccupiedRooms() => hms.getOccupiedRooms();
}
