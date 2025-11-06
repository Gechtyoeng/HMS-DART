//import 'dart:developer';
import 'dart:io';
import 'package:hms_project/domian/patient.dart';
import '../services/hms_service.dart';
//import '../domian/hms.dart';
import '../data/hms_repository.dart';
import '../domian/room.dart';
// import '../data/mockup_data.dart';

class RoomAllocationUI {
  // HMS hms = HMS(
  //   hospitalName: "CADT",
  //   location: "Prek Leab",
  //   contact: "012345678",
  // );
  final hmsService service;

  RoomAllocationUI(this.service);

  void start() {
    // initializeMockData(hms);
    bool running = true;
    while (running) {
      showMenu();
      stdout.write('Please select an option: ');
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          showAllPatientsUI();
          break;
        case '2':
          registerPatientUI();
          break;
        case '3':
          roomAllocationMenu();
          break;
        case '4':
          showBedAssignmentUI();
          break;
        case '5':
          checkOutPatientUI();
          break;
        case '6':
          searchPatientUI();
          break;
        case '7':
          saveToJson(service.hms);
          running = false;
          print('\nThank you for using Hospital Room Manager. Stay healthy!');
          break;
        default:
          print('Invalid option. Please try again.');
      }
    }
  }

  //separate the room allocation menu
  void roomAllocationMenu() {
    bool isSubMenu = true;
    while (isSubMenu) {
      print('======Room Allocation Menu======');
      print('1. View Occupied Rooms');
      print('2. View Available Rooms');
      print('3. Assign Room to Patient');
      print('4. Change Room');
      print('5. Back to Menu');
      stdout.write('Select an option: ');
      String? subChoice = stdin.readLineSync();

      switch (subChoice) {
        case '1':
          showOccupiedRooms();
          break;
        case '2':
          showAvaliableRoom();
          break;
        case '3':
          assignPatient();
          break;
        case '4':
          changeRoom();
          break;
        case '5':
          isSubMenu = false;
          break;
        default:
          print('Invalid room allocation option.');
      }
    }
  }

  //display all the patients
  void showAllPatientsUI() {
    final patients = service.getAllPatients();
    if (patients.isEmpty) {
      print('No patients found.');
    } else {
      print('\n--- All Patients ---\n');
      for (var p in patients) {
        print(p);
      }
    }
  }

  //display all bed assignment
  void showBedAssignmentUI() {
    print('\n--- All assignment detail ---\n');
    final bedassignments = service.getAllBedAssignments();
    if (bedassignments.isEmpty) {
      print('No bed assignment found.');
    } else {
      for (var ba in bedassignments) {
        ba.assignmentDetail();
      }
    }
  }

  //register patient ui
  void registerPatientUI() {
    print('\n--- Register New Patient ---\n');
    stdout.write('Enter First Name: ');
    String firstName = stdin.readLineSync() ?? '';

    stdout.write('Enter Last Name: ');
    String lastName = stdin.readLineSync() ?? '';

    stdout.write('Enter Gender (male/female): ');
    String genderInput = stdin.readLineSync() ?? '';

    stdout.write('Enter Contact Number: ');
    String contact = stdin.readLineSync() ?? '';

    final status = service.handleRegister(firstName: firstName, lastName: lastName, genderInput: genderInput, contact: contact);
    print(status);
  }

  //check out patient ui
  void checkOutPatientUI() {
    print('\n--- Patient Checkout ---\n');
    stdout.write('Enter patient contact: ');
    String contact = stdin.readLineSync() ?? '';

    final status = service.checkoutPatient(contact);
    print(status);
  }

  //search patient ui
  void searchPatientUI() {
    print('\n--- Search patient by contact ---\n');
    stdout.write('Enter contact number: ');
    String contact = stdin.readLineSync() ?? '';

    final patientFound = service.searchPatient(contact);
    if (patientFound != null) {
      print(patientFound);
    } else {
      print('Patient with contact: $contact not found.');
    }
  }

  //separate funtion to show all occupied room
  void showOccupiedRooms() {
    final occupied = service.getOccupiedRooms();
    if (occupied.isEmpty) {
      print('No occupied rooms found.');
    } else {
      print('\n--- Occupied Rooms ---');
      occupied.forEach((room, beds) {
        print('\nRoom Number: ${room.roomNumber}');
        print('Room Type: ${room.type.name}');
        print('Occupied Beds:');
        for (var bed in beds) {
          print('  - Bed ${bed.bedNumber} [Status: ${bed.status.name}]');
        }
      });
    }
  }

  //funtion to assign bed to patient
  void assignPatient() {
    print('\n--- Assign Room for Patient ---');
    stdout.write('Enter patient contact: ');
    String contact = stdin.readLineSync() ?? '';
    final patient = service.searchPatient(contact);

    if (patient == null) {
      print('Patient not found.');
      return;
    }
    assignBedFlow(patient);
  }

  //change room for patient
  void changeRoom() {
    print('\n--- Change Room for Patient ---\n');
    stdout.write('Enter patient contact: ');
    String contact = stdin.readLineSync() ?? '';

    final status = service.checkoutPatient(contact);
    print(status);

    stdout.write('Assign new bed to this patient? (yes/no): ');
    String confirm = stdin.readLineSync() ?? '';
    if (confirm.toLowerCase() != 'yes') {
      print('Room change cancelled. patient checkout.');
      return;
    }
    final patient = service.searchPatient(contact);
    assignBedFlow(patient!);
  }

  //separate funtion to show all avaliable room
  void showAvaliableRoom() {
    final available = service.getAvailableRooms();
    if (available.isEmpty) {
      print('No available rooms found.');
    } else {
      print('\n--- Available Rooms ---');
      available.forEach((room, beds) {
        print('\nRoom Number: ${room.roomNumber}');
        print('Room Type: ${room.type.name}');
        print('Available Beds:');
        for (var bed in beds) {
          print('  - Bed ${bed.bedNumber} [Status: ${bed.status.name}]\n');
        }
      });
    }
  }

  //funtion to handle assign bed flow
  void assignBedFlow(Patient patient) {
    print('Select Room Type:');
    for (var i = 0; i < RoomType.values.length; i++) {
      print('${i + 1}. ${RoomType.values[i].name}');
    }
    stdout.write('Enter choice: ');
    int? index = int.tryParse(stdin.readLineSync() ?? '');
    if (index == null || index < 1 || index > RoomType.values.length) {
      print('Invalid room type.');
      return;
    }
    RoomType selectedType = RoomType.values[index - 1];

    final available = service.getAvailableRoomsByType(selectedType);
    if (available.isEmpty) {
      print('No available beds in $selectedType rooms.');
      return;
    }

    print('\nAvailable Rooms and Beds:');
    final roomList = available.keys.toList();
    for (var i = 0; i < roomList.length; i++) {
      final room = roomList[i];
      print('${i + 1}. Room ${room.roomNumber} (${room.type.name})');
      for (var bed in available[room]!) {
        print('   - Bed ${bed.bedNumber} [${bed.status.name}]\n');
      }
    }

    stdout.write('Select room number: ');
    int? roomIndex = int.tryParse(stdin.readLineSync() ?? '');
    if (roomIndex == null || roomIndex < 1 || roomIndex > roomList.length) {
      print('Invalid room selection.');
      return;
    }
    final selectedRoom = roomList[roomIndex - 1];
    final bedsInRoom = available[selectedRoom]!;

    print('Available beds in Room ${selectedRoom.roomNumber}:');
    for (var i = 0; i < bedsInRoom.length; i++) {
      print('${i + 1}. Bed ${bedsInRoom[i].bedNumber}');
    }

    stdout.write('Select bed number: ');
    int? bedIndex = int.tryParse(stdin.readLineSync() ?? '');
    if (bedIndex == null || bedIndex < 1 || bedIndex > bedsInRoom.length) {
      print('Invalid bed selection.');
      return;
    }

    final selectedBed = bedsInRoom[bedIndex - 1];
    print(service.assignBedToPatient(patient, selectedBed));
  }
}

//function to display the main menu
void showMenu() {
  print('\n====================================');
  print('  Welcome to Hospital Room Manager');
  print('====================================');
  print('1. Show All Patients');
  print('2. Register Patient');
  print('3. Room Allocation');
  print('4. View all bed assignment');
  print('5. Patient Checkout');
  print('6. Search Patient by Contact');
  print('7. Exit');
  print('------------------------------------');
}
