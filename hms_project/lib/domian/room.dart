//enum for different room type
enum RoomType { vip, private, general, icu }

enum BedStatus { busy, free }

//class for each bed
class Bed {
  final String bedNumber;
  BedStatus status;
  final Room room;
  Bed({
    required this.bedNumber,
    this.status = BedStatus.free,
    required this.room,
  });

  //toString method for bed
  @override
  String toString() {
    return '''
    Bed number: $bedNumber
    Current status: $status
  ''';
  }

  //function to check if the bed is free
  bool ifBedFree() => status == BedStatus.free;

  //free the bed
  void freeBed() => status = BedStatus.free;

  // Serialize with roomNumber only (to avoid circular reference)
  Map<String, Object?> toJson() => {
    'bedNumber': bedNumber,
    'status': status.name,
    'roomNumber': room.roomNumber,
  };

  // Deserialize using a room lookup map
  static Bed fromJsonWithRoom(
    Map<String, Object?> json,
    Map<String, Room> roomMap,
  ) {
    final roomNumber = json['roomNumber'] as String;
    final room = roomMap[roomNumber];
    if (room == null) {
      throw Exception(
        'Room $roomNumber not found for bed ${json['bedNumber']}',
      );
    }

    return Bed(
      bedNumber: json['bedNumber'] as String,
      status: BedStatus.values.firstWhere((s) => s.name == json['status']),
      room: room,
    );
  }
}

class Room {
  final String roomNumber;
  final int capacity;
  final List<Bed> beds = [];
  final RoomType type;

  Room({required this.roomNumber, required this.capacity, required this.type});
  //default room set to general room
  Room.general({required this.roomNumber, required this.capacity})
    : type = RoomType.general;
  Room.private({required this.roomNumber})
    : capacity = 1,
      type = RoomType.private;
  Room.icu({required this.roomNumber}) : capacity = 1, type = RoomType.icu;
  Room.vip({required this.roomNumber}) : capacity = 1, type = RoomType.vip;

  //function to add bed
  void addBed(Bed bed) {
    beds.add(bed);
  }

  //function to remove bed
  bool removeBed(String bedNumber) {
    int totalBed = beds.length;
    beds.removeWhere((bed) => bed.bedNumber == bedNumber);

    return totalBed < beds.length; //return true of bed lenght decrease
  }

  //show all bed by room number
  void roomDetail() {
    print('-----Room detail-----');
    print('Room number: $roomNumber');
    print('Room type: $type');
    print('Room capacity: $capacity');
    print('----- Total bed -----');
    for (var bed in beds) {
      print(bed);
    }
  }

  // JSON serialization
  Map<String, Object?> toJson() => {
    'roomNumber': roomNumber,
    'capacity': capacity,
    'type': type.name,
    'beds': beds.map((b) => b.toJson()).toList(),
  };

  factory Room.fromJson(Map<String, Object?> json) {
    final type = RoomType.values.firstWhere((t) => t.name == json['type']);
    final roomNumber = json['roomNumber'] as String;
    final capacity = json['capacity'] as int;

    // Choose constructor based on type
    late Room room;
    switch (type) {
      case RoomType.private:
        room = Room.private(roomNumber: roomNumber);
        break;
      case RoomType.vip:
        room = Room.vip(roomNumber: roomNumber);
        break;
      case RoomType.icu:
        room = Room.icu(roomNumber: roomNumber);
        break;
      case RoomType.general:
        room = Room.general(roomNumber: roomNumber, capacity: capacity);
        break;
    }

    // Deserialize beds
    final bedsJson = json['beds'] as List<Object?>;
    final beds = bedsJson
        .map(
          (b) => Bed.fromJsonWithRoom(b as Map<String, Object?>, {
            room.roomNumber: room,
          }),
        )
        .toList();

    room.beds.addAll(beds);
    return room;
  }
}
