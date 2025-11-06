import 'package:hms_project/data/hms_repository.dart';
import 'package:hms_project/domian/hms.dart';
import 'package:hms_project/ui/room_allocation.dart';
import 'package:hms_project/services/hms_service.dart';
// void main() {

//   RoomAllocation console = RoomAllocation();
//   console.startRoomAllocation();
// }

void main() {
  final hms = HMS(hospitalName: "CADT", location: "Prek Leab", contact: "012345678");

  // Load from JSON files
  loadFromJson(hms);

  // Create service
  final service = hmsService(hms);

  // Launch the console UI
  final console = RoomAllocationUI(service);
  console.start();
}
