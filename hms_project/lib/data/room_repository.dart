import 'dart:convert';
import 'dart:io';
import '../domian/room.dart';

/// Save all rooms (with their beds) to a JSON file
void saveRooms(List<Room> rooms, String path) {
  final jsonList = rooms.map((room) => room.toJson()).toList();
  File(path).writeAsStringSync(jsonEncode(jsonList));
}

/// Load rooms from a JSON file and re-link beds to their rooms
List<Room> loadRooms(String path) {
  final jsonString = File(path).readAsStringSync();
  final jsonList = jsonDecode(jsonString) as List<Object?>;

  // First pass: create Room objects without beds
  final roomMap = <String, Room>{};
  for (final json in jsonList) {
    final roomJson = json as Map<String, Object?>;
    final room = Room(
      roomNumber: roomJson['roomNumber'] as String,
      capacity: roomJson['capacity'] as int,
      type: RoomType.values.firstWhere((t) => t.name == roomJson['type']),
    );
    roomMap[room.roomNumber] = room;
  }

  // Second pass: populate beds using roomMap
  for (final json in jsonList) {
    final roomJson = json as Map<String, Object?>;
    final roomNumber = roomJson['roomNumber'] as String;
    final room = roomMap[roomNumber]!;

    final bedsJson = roomJson['beds'] as List<Object?>;
    final beds = bedsJson
        .map((b) => Bed.fromJsonWithRoom(b as Map<String, Object?>, roomMap))
        .toList();

    room.beds.addAll(beds);
  }

  return roomMap.values.toList();
}
